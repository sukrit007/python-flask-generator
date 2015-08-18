#!/bin/bash -ex

if [ -z "$GIT_REPO_URL" ]; then
    echo "Error: GIT_REPO_URL was not initialized."
    exit 1
fi

if [ -z "$GIT_SSH_KEY" ]; then
    echo "Error: GIT_SSH_KEY was not initialized."
    # exit 1
fi

GIT_REPO_WITH_EXT="$(basename $GIT_REPO_URL)"
GIT_REPO="${GIT_REPO_WITH_EXT%.*}"
GIT_BRANCH="${GIT_BRANCH:-master}"
APP_NAME="${APP_NAME:-myapp}"
APP_PORT="${APP_PORT:-8080}"
PYTHON_MAJOR_VERSION="${PYTHON_MAJOR_VERSION:-2}"

function init_app {
    cp -r  skeleton/* $GIT_REPO
    cd $GIT_REPO

    if [ "$APP_NAME" != "myapp" ]; then
        mv myapp $APP_NAME
        grep -rl 'myapp' ./ | xargs sed -i "s/myapp/$APP_NAME/g"
    fi

    if [ "$APP_PORT" != "8080" ]; then
        sed -i "s/EXPOSE 8080/EXPOSE $APP_PORT/g" Dockerfile
        sed -i "s/port=8080/port=$APP_PORT/g" server.py
    fi

    if [ "$PYTHON_MAJOR_VERSION" != "2" ]; then
        sed -i "s/ENV PYTHON_MAJOR_VERSION 2/ENV PYTHON_MAJOR_VERSION $PYTHON_MAJOR_VERSION/g" Dockerfile
    fi
    
}

function git_init() {
    rm -rf $GIT_REPO
    git clone "$GIT_REPO_URL"
    if git branch | grep $GIT_BRANCH; then
       git checkout $GIT_BRANCH
    else
        git checkout -b $GIT_BRANCH
    fi
}

function git_push() {
    echo "git push"
    git add . -A
    git commit . -m 'Totem Seed application for python'
    git push origin $GIT_BRANCH
}


git_init
mkdir -p $GIT_REPO
init_app
git_push




