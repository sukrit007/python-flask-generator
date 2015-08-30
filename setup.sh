#!/bin/bash -e

if [ -z "$GIT_USER" ]; then
    echo "Error: GIT_USER was not initialized."
    exit 1
fi

if [ -z "$GIT_USER_EMAIL" ]; then
    echo "Error: GIT_USER_EMAIL was not initialized."
    exit 1
fi

if [ -z "$GIT_OWNER" ]; then
    echo "Error: GIT_OWNER was not initialized."
    exit 1
fi

if [ -z "$GIT_REPO" ]; then
    echo "Error: GIT_REPO was not initialized."
    exit 1
fi

if [ -z "$APP_NAME" ]; then
    echo "Error: APP_NAME was not initialized."
    exit 1
fi

if [ -z "$SCM_TYPE" ]; then
    echo "Error: SCM_TYPE was not initialized."
    exit 1
elif [ "$SCM_TYPE" = "github" ]; then
    if [ -z "$GITHUB_USERNAME" ]; then
        echo "Error: GITHUB_USERNAME was not initialized."
        exit 1
    fi
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "Error: GITHUB_TOKEN was not initialized."
        exit 1
    fi
    export GIT_USERNAME="${GIT_USERNAME:-$GITHUB_TOKEN}"
    export GIT_PASSWORD="${GIT_PASSWORD:-}"
    export GIT_REPO_URL="https://github.com/$GIT_OWNER/$GIT_REPO.git"
else
    if [ -z "$GIT_REPO_URL" ]; then
        echo "Error: GIT_REPO_URL was not initialized."
        exit 1
    fi
    if [ -z "$GIT_USERNAME" ]; then
        echo "Error: GIT_USERNAME was not initialized."
        exit 1
    fi
    if [ -z "$GIT_PASSWORD" ]; then
        echo "Error: GIT_PASSWORD was not initialized."
        exit 1
    fi
fi

APP_PORT="${APP_PORT:-8080}"
PYTHON_MAJOR_VERSION="${PYTHON_MAJOR_VERSION:-2}"

get_abs_filename() {
  # $1 : relative filename
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

function git_setup {
    git config --global user.name "$GIT_USER"
    git config --global user.email "$GIT_USER_EMAIL"
    git config --global credential.helper cache
    git config --global credential.$(dirname $(dirname $GIT_REPO_URL)).username "$GIT_USERNAME"
    git config --global core.askpass "$(get_abs_filename gitpass.sh)"
}

function hook_setup {
    if [ "${SCM_TYPE}" = "github" ]; then
        if [ ! -z "${ORCHESTRATOR_HOOK_URL}" ]; then
            curl -u "$GITHUB_USERNAME:$GITHUB_TOKEN" -XPOST -d \
                "{\"name\": \"web\", \"active\": \"true\", \"events\": [\"push\", \"create\", \"delete\"], \
                \"config\": {\"content_type\": \"json\", \"url\": \"$ORCHESTRATOR_HOOK_URL\",\"secret\": \"$HOOK_SECRET\"}  }" \
                 https://api.github.com/repos/$GIT_OWNER/$GIT_REPO/hooks
        fi
        if [ ! -z "${IMAGE_FACTORY_HOOK_URL}" ]; then
            curl -u "$GITHUB_USERNAME:$GITHUB_TOKEN" -XPOST -d \
                "{\"name\": \"web\", \"active\": \"true\", \"events\": [\"push\"], \
                \"config\": {\"content_type\": \"json\", \"url\": \"$IMAGE_FACTORY_HOOK_URL\",\"secret\": \"$HOOK_SECRET\"}  }" \
                 https://api.github.com/repos/$GIT_OWNER/$GIT_REPO/hooks
        fi
    fi
}


function init_app {
    cp -r  ../skeleton/* .

    if [ "$APP_NAME" != "myapp" ]; then
        mv myapp $APP_NAME
        grep -rl 'myapp' ./ | xargs sed -i "s/myapp/$APP_NAME/g"
    fi

    if [ "$APP_PORT" != "8080" ]; then
        sed -i "s/EXPOSE 8080/EXPOSE $APP_PORT/g" Dockerfile
        sed -i "s/port=8080/port=$APP_PORT/g" server.py
        sed -i "s/8080/$APP_PORT/g" totem.yml
    fi

    if [ "$PYTHON_MAJOR_VERSION" != "2" ]; then
        sed -i \
            -e "s/2.7-trusty-.*/3.4-trusty-b4/g" \
            -e "s/pip /pip3 /g" Dockerfile
    fi
    
}

function git_init {
    rm -rf $GIT_REPO
    git clone "$GIT_REPO_URL"
    cd $GIT_REPO
    if git branch | grep 'master'; then
       git checkout master
    else
        git checkout -b master
    fi
}

function git_push {
    echo "git push"
    git add . -A
    git commit . -m 'Totem Seed application for python'
    git push origin master

    if git branch | grep 'develop'; then
       git checkout develop
       git merge master
    else
        git checkout -b develop
    fi
    git push origin develop

}

git_setup
hook_setup
git_init
init_app
git_push




