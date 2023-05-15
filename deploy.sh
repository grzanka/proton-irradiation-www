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
pip install -r requirements.txt

# Remove old builds of mkdocs site
rm -rf site

# Build mkdocs site
mkdocs build

# Deactivate virtual environment
deactivate