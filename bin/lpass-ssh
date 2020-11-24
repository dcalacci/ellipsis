#!/bin/bash

KEY_NAME=$1

if ! ( which lpass > /dev/null ); then
  echo "LastPass CLI is required."
  exit 2
fi

# Require something to be passed to this command
if [ -z "${KEY_NAME}" ]; then
  echo "You need to specify a key name."
  exit 2
fi

# Try to find the passed key path / name
if ! [ -e "${KEY_NAME}" ]; then
  if [ -e "${HOME}/.ssh/${KEY_NAME}" ]; then
    KEY_NAME="${HOME}/.ssh/${KEY_NAME}"
  else
    echo "Could not find key file."
    exit 1
  fi
fi

# If this key is already in the agent we don't need to do anything
if ( ssh-add -l | grep -q "${KEY_NAME}" ); then
  echo "Key already present."
  exit 0
fi

# Retrieve key from LastPass
PWD=$(lpass show --field=Passphrase "SSH: $(basename ${KEY_NAME})")

# In case LastPass exitted non-zero we have no password
if ! [ $? -eq 0 ]; then
  echo "Unable to get password. Not trying to unlock."
  exit 1
fi

# Fill password to ssh-add utility
expect <<EOF >/dev/null
spawn ssh-add ${KEY_NAME}
expect "Enter passphrase"
send "$PWD\n"
expect eof
EOF

# Check whether the key was added to the agent
if ( ssh-add -l | grep -q "${KEY_NAME}" ); then
  echo "Key successfully added."
  exit 0
else
  echo "Found passphrase but could not add key."
  exit 1
fi
