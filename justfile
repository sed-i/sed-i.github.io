serve:
    uvx zensical serve -a 0.0.0.0:8000

lint:
    uvx codespell . --skip .git --skip site --skip '*.pdf'
