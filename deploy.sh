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

    # list of files and directories on server
    lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "cls $LFTP_PATH; quit" > server_contents.txt

    # remove all files and directories on server contained in local server_contents.txt file
    while read -r line; do
        if [[ $line == *"$LFTP_PATH"* ]]; then
            lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "rm -rf $line; quit"
        fi
    done < server_contents.txt

    lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "cls -al $LFTP_PATH; quit"

    # find all directories and files in site/ and upload them to server
    #find site/ -type d -execdir lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "rm -rf $LFTP_PATH{}; mkdir $LFTP_PATH{}; chmod o+rx $LFTP_PATH{}; quit" \;
    #find site/ -type d -execdir lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "rmdir $LFTP_PATH{}; chmod o+rx $LFTP_PATH{}; quit" \;
#    lftp --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "mirror --delete --reverse site/ $LFTP_PATH; chmod --recursive o-w $LFTP_PATH; chmod --recursive o+r $LFTP_PATH; cls -al $LFTP_PATH; quit"
fi

# Deactivate virtual environment
deactivate