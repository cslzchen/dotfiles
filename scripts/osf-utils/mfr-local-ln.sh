#!/usr/local/bin/zsh

# Source .zshrc for each tmux session/window/tab
echo "source ~/.zshrc"
source "${HOME}/.zshrc"

# CD into the working directory
DIR="${HOME}/Projects/cos/mfr/develop"
echo "cd ${DIR}"
cd $DIR

# Work on the virutal environment
VIRTUAL_ENV="mfr-local"
echo "workon ${VIRTUAL_ENV}"
workon $VIRTUAL_ENV

# Update remote branches and obtain current status
echo "git fetch and status"
git fetch upstream develop
git fetch upstream master
git status

