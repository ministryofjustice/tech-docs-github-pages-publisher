# Tech Docs GitHub Pages Publisher

[![Releases](https://img.shields.io/github/release/ministryofjustice/tech-docs-github-pages-publisher/all.svg?style=flat-square)](https://github.com/ministryofjustice/tech-docs-github-pages-publisher/releases)

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.data%5B%3F%28%40.name%20%3D%3D%20%22tech-docs-github-pages-publisher%22%29%5D.status&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fgithub_repositories)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/github_repositories#tech-docs-github-pages-publisher "Link to report")

This repository creates a Docker image and publishes the image to DockerHub.

The Docker image is pulled by other repository CI/CD and combined with their source code to create documentation websites that meet government technical documents and then push the data to GH Pages.

The contents of the Docker image will compile embedded ruby and markdown files, ie .html.md.erb, into HTML and assets using the GOV.UK [Technical Documentation Template](https://tdt-documentation.london.cloudapps.digital/) / [Source code](https://github.com/alphagov/tech-docs-template).

There are two scripts within the Docker image that both use the middleman gem:

- [preview.sh](scripts/preview.sh) - serve the compiled HTML and assets on a localhost port - useful for previewing the site locally
- [compile-and-create-artifact.sh](scripts/compile-and-create-artifact.sh) - compiles the source code and places the HTML into the /docs folder, tests the links using htmlproofer and and creates a .tar artifact file that other GH Actions will serve to GitHub Pages.

This image is used by the [MoJ Template Documentation Site](https://github.com/ministryofjustice/template-documentation-site) repository for MOJ technical documentation that gets published to GitHub Pages.

## Breaking Change in v2

If you have a branch called gh-pages already rename it to gh-pages-old. In repository settings, go to Pages, copy the 'Custom domain' value, for 'Build and deployment' 'Source' change to the option 'GitHubs Actions'. Then apply the new yml code in the README.md in your CI Action that published gh-pages. If all is working can remove the gh-pages-old branch.

## How to use tool in GH Action

Example of using tech-docs-github-pages-compiler. Add the following code to .github/workflows/publish-gh-pages.yml in your repository.

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
      image: ministryofjustice/tech-docs-github-pages-publisher:v2
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Compile Markdown to HTML and create artifact
        run: |
          /scripts/compile-and-create-artifact.sh
      - name: Upload artifact to be published
        uses: actions/upload-artifact@main
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
        uses: actions/configure-pages@v1
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@main
```

## Local development with another MoJ Documentation repository:

This assumes you have Ruby and Bundler already installed on your local machine. See the [installation](https://tdt-documentation.london.cloudapps.digital/create_project/get_started/#get-started) setup.

Copy the config.rb file, Gemfile and Gemfile.lock to the checked out repository folder that contains the webpage data.

```
gem install middleman

bundle exec middleman build

bundle exec middleman serve
```

Open a browser at http://127.0.0.1:4567/

## Locally in Docker

To run the Docker image locally for development, build the image then run the container from the repository containing the webpage data:

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
../scripts/compile-and-create-artifact.sh
```

## CI/CD

A [GitHub Action](.github/workflows/docker-hub.yml) publishes this repository Docker image to DockerHub.

## Updating

The [govuk_tech_docs](https://rubygems.org/gems/govuk_tech_docs) gem is within the Gemfile.

Either dependabot will automatically update the gem or a new PR with the gem updated is required.
