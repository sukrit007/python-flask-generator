# python-flask-generator
Python flask  app generator that is integrated with docker.
- Creates bask flask app skeleton
- Pushes the created skeleton to git origin

## Env variables

### GIT_REPO_URL
Target repository (git) URL.

### GIT_BRANCH
Target git branch. Defaults to master.  If branch does not exist a new one will be created

### GIT_SSH_KEY
SSH Key for accessing git repository.

