# proton-irradiation-www
Website for proton irradiation station at IFJ PAN:
  - https://grzanka.github.io/proton-irradiation-www/

## Installation

To serve the page install first mkdocs in virtual environment:

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

Page layout is based on the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme.