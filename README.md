# Tech Docs GitHub Pages Publisher

[![Releases](https://img.shields.io/github/release/ministryofjustice/tech-docs-github-pages-publisher/all.svg?style=flat-square)](https://github.com/ministryofjustice/tech-docs-github-pages-publisher/releases) [![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.result&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Ftech-docs-github-pages-publisher)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#tech-docs-github-pages-publisher "Link to report")

This repository creates a Docker image and publishes the image to DockerHub.

The Docker image is pulled by other repository CI/CD, uses the container with their source code and call the scripts with the container to create documentation websites that meet government technical documents. The data created, ie html website, is then pushed to GH Pages by the repository CI/CD.

The contents of the Docker image will compile embedded ruby and markdown files, ie .html.md.erb, into HTML and assets using the GOV.UK [Technical Documentation Template](https://tdt-documentation.london.cloudapps.digital/) / [Source code](https://github.com/alphagov/tech-docs-template).

There are three scripts within the Docker image, that use the Middleman gem to either build or serve the data:

- [preview.sh](scripts/preview.sh) - serve the compiled HTML and assets on a localhost port - useful for previewing the site locally
- [deploy.sh](scripts/deploy.sh) - compiles the source code, places the HTML into the ./docs folder, tests the **internal links only** using htmlproofer and and creates a .tar artifact file that other GH Actions will serve to GitHub Pages.
- [check-url-links.sh](scripts/check-url-links.sh) - compiles the source code, places the HTML into the ./docs folder, and tests **internal and external URL links** using htmlproofer.

This image is used by the [MoJ Template Documentation Site](https://github.com/ministryofjustice/template-documentation-site) repository for MOJ technical documentation that gets published to GitHub Pages.

## Breaking Change in v3

The scripts in the Docker container have changed.

`scripts/deploy.sh` is now used to check internal links only during the deploy stage. See `.github/workflows/publish-gh-pages.yml` below.

[Optional]: Use the `scripts/check-url-links.sh` to test internal and external URLs, it may produce false errors for valid working URLs. Add the `.github/workflows/check-links.yml` below to run the check when the PR is created. The false errors can be ignored.

[Optional]: Use the `url-check` job within `.github/workflows/publish-gh-pages.yml` to check the URLs are correct post deployment. Private and internal Github repository URLs and other URLs that create false errors can be listed and skipped within this job.

## Breaking Change in v2

If you have a branch called gh-pages already rename it to gh-pages-old. In repository settings, go to Pages, copy the 'Custom domain' value, for 'Build and deployment' 'Source' change to the option 'GitHubs Actions'. Apply the yml code below to your CI Actions. If all is working you can remove the gh-pages-old branch. You may need to manually run the below workflow once it is merged into main.

## How to use tool in GH Action

Example of using tech-docs-github-pages-publisher. Add the following code to `.github/workflows/publish-gh-pages.yml` in your repository.

```
name: Publish gh-pages

on:
  workflow_dispatch:
  push:
    branches:
      - "main"
    paths-ignore:
      - "docs/**"

# GITHUB_TOKEN permissions to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow one concurrent deployment
concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ministryofjustice/tech-docs-github-pages-publisher:v3
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Compile Markdown to HTML and create artifact
        run: /scripts/deploy.sh
      - name: Upload artifact to be published
        uses: actions/upload-artifact@v3
        with:
          name: github-pages
          path: artifact.tar
          retention-days: 1

  deploy:
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Setup Pages
        uses: actions/configure-pages@v2
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v1

  url-check:
    needs: deploy
    runs-on: ubuntu-latest
    steps:
      - name: Download a Build Artifact from build
        uses: actions/download-artifact@v3
        with:
          name: github-pages
          path: github-pages
      - name: Unpack files and check URL links
        run: |
          cd github-pages
          tar -xvf artifact.tar
          npm install linkinator
          npx linkinator . --recurse --markdown \
          #  --skip https://github.com/ministryofjustice/some-private-repo \
```

Create a `.github/workflows/check-links.yml` file that uses `scripts/check-url-links.sh`.

```
name: Check for broken links

on:
  workflow_dispatch:
  pull_request:
    paths:
      - "source/**"

jobs:
  check_links:
    runs-on: ubuntu-latest
    container:
      image: ministryofjustice/tech-docs-github-pages-publisher:v3
    steps:
      - uses: actions/checkout@v3
      - name: htmlproofer
        run: /scripts/check-url-links.sh
```

## Local development with another MoJ Documentation repository:

This assumes you have Ruby and Bundler already installed on your local machine. See the [installation](https://tdt-documentation.london.cloudapps.digital/create_project/get_started/#get-started) setup.

Copy the `config.rb` file, `Gemfile` and `Gemfile.lock` from this repository to the checked out repository folder that contains the documentation data.

```
gem install middleman

bundle exec middleman build

bundle exec middleman serve
```

Open a browser at http://127.0.0.1:4567/

## Locally in Docker

To run the Docker image locally for development, build the image then run the container from the repository containing the documentation data:

Build the Docker image:

```
docker build -t gh-action -f ./Dockerfile .
```

Start the Docker container:

```
docker run -it --rm -p 4567:4567 --name ghaction gh-action sh
```

In a seperate terminal copy the webpage config and source files:

```
docker cp config ghaction:/app/ && docker cp source ghaction:/app/
```

Inside the Docker container run the server locally:

```
../scripts/preview.sh
```

Open a browser at http://127.0.0.1:4567/

Inside the Docker container run the html-proofer tests locally before creating a PR:

```
../scripts/deploy.sh
```

or

```
../scripts/check-url-links.sh
```

Alternatively use the [makefile](https://github.com/ministryofjustice/technical-guidance/blob/main/makefile) from the technical-guidance repository to run the Docker container locally using the `make preview`, `make deploy` or `make check` commands.

## CI/CD

A [GitHub Action](.github/workflows/docker-hub.yml) publishes this repository Docker image to DockerHub.

## Updating

The [govuk_tech_docs](https://rubygems.org/gems/govuk_tech_docs) gem is within the Gemfile.

Either Dependabot will automatically update the gem or a new PR with the gem updated is required.

The Gems in the `Gemfile` are fixed for various reasons. This prevents incrementing the versions.

## Markdown in html

Markdown syntax used within the compiled down html files can be found [here](https://daringfireball.net/projects/markdown/) and here [kramdown](https://kramdown.gettalong.org/syntax.html).
