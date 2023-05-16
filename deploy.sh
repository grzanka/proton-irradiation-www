#!/bin/bash

# Exit on any error
set -e

# Check if python3 is installed
if ! command -v python3 &> /dev/null
then
    echo "Python3 could not be found"
    exit
fi

# Check if venv directory exists
if [ ! -d "venv" ]
then
    echo "Creating virtual environment"
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install --requirement requirements.txt --upgrade

# Remove old builds of mkdocs site
rm -rf site

# Build mkdocs site
mkdocs build

# Import all enviroment variables from .env file if exists
set -o allexport
[[ -f .env ]] && source .env
set +o allexport

# Check if LFTP_PASSWORD environment variable is set, if that is the case, upload site to server
if [ -z "$LFTP_PASSWORD" ]
then
    echo "LFTP_PASSWORD environment variable is not set, skipping upload"
elif [ -z "$LFTP_USER" ]
then
    echo "LFTP_USER environment variable is not set, skipping upload"
elif [ -z "$LFTP_HOST" ]
then
    echo "LFTP_HOST environment variable is not set, skipping upload"
elif [ -z "$LFTP_PORT" ]
then
    echo "LFTP_PORT environment variable is not set, skipping upload"
elif [ -z "$LFTP_PATH" ]
then
    echo "LFTP_PATH environment variable is not set, skipping upload"
else
    echo "Uploading site to server from $PWD/site to $LFTP_PATH on $LFTP_HOST:$LFTP_PORT as $LFTP_USER"
    lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "mirror --delete --reverse site/ $LFTP_PATH; chmod --recursive o-w $LFTP_PATH; quit"
fi

# Deactivate virtual environment
deactivate