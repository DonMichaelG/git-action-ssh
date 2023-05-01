#!/bin/sh -l

: ${HOST?Required host not set.}
: ${USER?Required user not set.}
: ${SSH_PRIVATE_KEY_PATH?Required secret not set.}
: ${TARGET?Required target path not set.}
: ${BRANCH?Required branch not set.}

SOURCE_PATH="."
TARGET_PATH="$USER"@ssh."$HOST":/www/"$TARGET"

echo "$TARGET_PATH"
echo "$BRANCH" > environment

rsync -e "ssh -v -p 22 -i $SSH_PRIVATE_KEY_PATH" --delete -a --exclude={".*","robots.txt"} $SOURCE_PATH $TARGET_PATH

ssh  -i ../sbif/ssh/sbif stockholmsbif.se@ssh.stockholmsbif.se "cache-purge"