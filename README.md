# python-flask-generator
Python flask  app generator that is integrated with docker.
- Creates bask flask app skeleton
- Pushes the created skeleton to git origin


## Running Generator (Docker)
```
sudo docker run --rm  \
    -e GIT_USER="$GIT_USER" \
    -e GIT_USER_EMAIL="$GIT_USER_EMAIL" \
    -e GITHUB_USERNAME="$GITHUB_USERNAME" \
    -e GITHUB_TOKEN="$GITHUB_TOKEN" \
    -e SCM_TYPE="$SCM_TYPE" \
    -e ORCHESTRATOR_HOOK_URL="$ORCHESTRATOR_HOOK_URL" \
    -e IMAGE_FACTORY_HOOK_URL="$IMAGE_FACTORY_HOOK_URL" \
    -e HOOK_SECRET="$HOOK_SECRET" \
    -e GIT_OWNER="$GIT_OWNER" \
    -e GIT_REPO="$GIT_REPO" \
    -e APP_NAME="$APP_NAME" \
    totem/python-flask-generator
```

## Env variables

###  GIT_USER
User to be used for git commits. (Required)

###  GIT_USER_EMAIL
Email to be used for git commits. (Required)

###  GIT_OWNER
Git repository owner. (Required)

###  GIT_REPO
Git repository name. (Required)

###  APP_NAME
Application. (Required)

### SCM_TYPE
Type of SCM (e.g: github) (Required)

### GITHUB_USERNAME
Github username (Required for github)

### ORCHESTRATOR_HOOK_URL
Callback hook url for orchestrator. (Required)

### IMAGE_FACTORY_HOOK_URL
Callback hook url for image-factory. (Required)

### HOOK_SECRET
Hook secret to be sed. (Required)
