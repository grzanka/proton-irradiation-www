# proton-irradiation-www
Website for proton irradiation station at IFJ PAN:
  - development version of the site: https://grzanka.github.io/proton-irradiation-www/
  - production version of the site: https://proton-irradiation.ifj.edu.pl/

## Installation

To serve the page install first `mkdocs` in a virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Then serve the page:

```bash
mkdocs serve
```

## Contents of the repository

The page is generated using [mkdocs](https://www.mkdocs.org/). The repository contains:
- `docs/` - directory with the content of the page in the Markdown format
- `mkdocs.yml` - configuration file for the mkdocs
- `overrides` - directory with the customised CSS and HTML files
- `requirements.txt` - list of Python packages required to generate the page
- `.env` - file with enviroment variables for connection details to deploy site to IFJ server (server, username, path)
- `deploy.sh` - deploy script which builds the page and uploads it to IFJ server

Page layout is based on the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme.

Github Actions (customised in `.github/workflows/`) are used to run automatic tests after every commit. 
These checks ensure that the page is generated correctly and that all links are valid.

## Deployment

LFTP deploy is handled by `deploy.sh` script. It assumes that necessary credentials are stored in the `.env` file of in the environment variables.
You can use it to deploy site to the IFJ web server.

## How to contribute

If you want to contribute to the page, please follow these steps:
1. Create new branch from the main `master` branch
2. Make changes in the new branch
3. Create pull request to the `master` branch
4. Wait for the review and merge. Once the pull requests is merged, Github Actions will automatically deploy the page to https://grzanka.github.io/proton-irradiation-www/