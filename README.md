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

### Deploying from a new machine

If you run `deploy.sh` for the first time on a new machine, the upload may hang silently right after the
`Uploading site to server ...` message. This happens because the server's SSH host key is not yet known to the machine:
`ssh` (used by LFTP under the hood) asks for confirmation, LFTP answers "no" and keeps retrying the connection.

To fix it, connect once manually with `ssh`, using the connection details from the `.env` file:

```bash
set -a; source .env; set +a
ssh -p $LFTP_PORT $LFTP_USER@$LFTP_HOST
```

`ssh` will ask whether you want to continue connecting and show the server's key fingerprint.
Check that the fingerprint is correct and answer `yes`; the key will be saved in `~/.ssh/known_hosts`.
After that `deploy.sh` should work normally.

If the upload still hangs, run LFTP with debug output enabled (`-d`) to see where it gets stuck, for example:

```bash
lftp -d --env-password sftp://$LFTP_USER@$LFTP_HOST:$LFTP_PORT -e "set net:max-retries 1; cls $LFTP_PATH; quit"
```

## How to contribute

If you want to contribute to the page, please follow these steps:
1. Create new branch from the `main` branch
2. Make changes in the new branch
3. Create pull request to the `main` branch
4. Wait for the review and merge. Once the pull requests is merged, Github Actions will automatically deploy the page to https://grzanka.github.io/proton-irradiation-www/
5. Deploy to the production server is handled manually using `deploy.sh` script. 