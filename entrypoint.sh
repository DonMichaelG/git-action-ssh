#!/bin/sh -l

: ${HOST?Required host not set.}
: ${USER?Required user not set.}
: ${SSH_PRIVATE_KEY?Required secret not set.}
: ${SSH_PUBLIC_KEY?Required secret not set.}
: ${TARGET?Required target path not set.}
: ${BRANCH?Required branch not set.}

SOURCE_PATH="."
SSH_HOST=ssh."$HOST"
SSH_USER="$USER"@"$SSH_HOST"
TARGET_PATH="$SSH_USER":/www/"$TARGET"

SSH_PATH="$HOME/.ssh"
SSH_PRIVATE_KEY_PATH="$SSH_PATH/key"
SSH_PUBLIC_KEY_PATH="$SSH_PATH/key.pub"
SSH_KNOWN_HOSTS_PATH="$SSH_PATH/known_hosts"

mkdir $SSH_PATH
echo "$SSH_PRIVATE_KEY" > $SSH_PRIVATE_KEY_PATH
echo "$SSH_PUBLIC_KEY" > $SSH_PUBLIC_KEY_PATH
ssh-keyscan -t rsa "$SSH_HOST" > $SSH_KNOWN_HOSTS_PATH

chmod 700 $SSH_PATH
chmod 600 $SSH_PRIVATE_KEY_PATH
chmod 644 $SSH_PUBLIC_KEY_PATH
chmod 644 $SSH_KNOWN_HOSTS_PATH

echo "$BRANCH" > environment

EXCLUDES={".*",".*/",".github",".git",".gitignore"}
FILTERS={"protect robot.txt","protect .htaccess"}

rsync -e "ssh -v -p 22 -i $SSH_PRIVATE_KEY_PATH -o UserKnownHostsFile=$SSH_KNOWN_HOSTS_PATH" -a --verbose --delete-excluded --exclude=$EXCLUDES --filter=$FILTERS $SOURCE_PATH $TARGET_PATH

ssh  -i $SSH_PRIVATE_KEY_PATH -o UserKnownHostsFile=$SSH_KNOWN_HOSTS_PATH $SSH_USER "cache-purge"