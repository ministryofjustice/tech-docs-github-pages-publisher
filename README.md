# Tech Docs GitHub Pages Publisher

[![Releases](https://img.shields.io/github/release/ministryofjustice/tech-docs-github-pages-publisher/all.svg?style=flat-square)](https://github.com/ministryofjustice/tech-docs-github-pages-publisher/releases) [![repo standards badge](https://img.shields.io/endpoint?labelColor=231f20&color=005ea5&style=for-the-badge&label=MoJ%20Compliant&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fendpoint%2Ftech-docs-github-pages-publisher&logo=data:image/png;base64,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)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#tech-docs-github-pages-publisher)

This repository creates a container image and publishes the image to GitHub Container Registry.

The container image is pulled by other repository CI/CD, uses the container with their source code and call the scripts with the container to create documentation websites that meet government technical documents. The data created, ie html website, is then pushed to GitHub Pages by the repository CI/CD.

The contents of the container image will compile embedded ruby and markdown files, ie .html.md.erb, into HTML and assets using the GOV.UK [Technical Documentation Template](https://tdt-documentation.london.cloudapps.digital/) / [Source code](https://github.com/alphagov/tech-docs-template).

There are three scripts within the container image, that use the Middleman gem to either build or serve the data:

- [`td-preview`](src/usr/local/bin/td-preview) - serve the compiled HTML and assets on a localhost port - useful for previewing the site locally
- [`td-package`](src/usr/local/bin/td-package) - compiles the source code, places the HTML into the ./docs folder, tests the **internal links only** using Lychee and then creates a .tar artifact file that other GitHub Actions will deploy to GitHub Pages.

This image is used by the [MoJ Template Documentation Site](https://github.com/ministryofjustice/template-documentation-site) repository for MOJ technical documentation that gets published to GitHub Pages.

## Breaking Changes in v4

The container is now hosted on GitHub Container Registry

The scripts in the container have changes:

- `preview.sh` is now `td-preview` and can be called from `/usr/local/bin/td-preview`
- `deploy.sh` is now `td-package` and can be called from `/usr/local/bin/td-package`

## Breaking Change in v3

The scripts in the Docker container have changed.

`scripts/deploy.sh` is now used to check internal links only during the deploy stage. See `.github/workflows/publish-gh-pages.yml` below.

If you see an error like this:

```bash
  internally linking to ./*-communications-plan.html#tips-on-format-of-communications-examples; the file exists, but the hash 'tips-on-format-of-communications-examples' does not
```

You can override the `check_interal_hash` argument with `scripts/deploy.sh false`


[Optional]: Use the `scripts/check-url-links.sh` to test internal and external URLs, it may produce false errors for valid working URLs. Add the `.github/workflows/check-links.yml` below to run the check when the PR is created. The false errors can be ignored.

[Optional]: Use the `url-check` job within `.github/workflows/publish-gh-pages.yml` to check the URLs are correct post deployment. Private and internal Github repository URLs and other URLs that create false errors can be listed and skipped within this job.

## Breaking Change in v2

If you have a branch called gh-pages already rename it to gh-pages-old. In repository settings, go to Pages, copy the 'Custom domain' value, for 'Build and deployment' 'Source' change to the option 'GitHubs Actions'. Apply the yml code below to your CI Actions. If all is working you can remove the gh-pages-old branch. You may need to manually run the below workflow once it is merged into main.

## How to use tool in GitHub Actions

Example of using tech-docs-github-pages-publisher. Add the following code to `.github/workflows/publish-gh-pages.yml` in your repository.

```yaml
---
name: Build and Publish

on:
  push:
    branches:
      - main

permissions: {}

concurrency:
  group: github-pages
  cancel-in-progress: true

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/ministryofjustice/tech-docs-github-pages-publisher@sha256:xxxxx # vx.y.z
    permissions:
      contents: read
    steps:
      - name: Checkout
        id: checkout
        uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1

      - name: Build
        id: build
        run: |
          /usr/local/bin/td-package

      - name: Upload Artifact
        id: upload_artifact
        uses: actions/upload-artifact@5d5d22a31266ced268874388b861e4b58bb5c2f3 # v4.3.1
        with:
          name: github-pages
          path: artifact.tar
          retention-days: 1
          overwrite: true

  publish:
    needs: build
    name: Publish
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.configure_pages.outputs.base_url }}
    permissions:
      contents: read
      id-token: write
      pages: write
    steps:
      - name: Configure Pages
        id: configure_pages
        uses: actions/configure-pages@1f0c5cde4bc74cd7e1254d0cb4de8d49e9068c7d # v4.0.0

      - name: Deploy to GitHub Pages
        id: deploy_pages
        uses: actions/deploy-pages@decdde0ac072f6dcbe43649d82d9c635fff5b4e4 # v4.0.4
```

## CI/CD

A [GitHub Action](.github/workflows/docker-hub.yml) publishes this repository Docker image to DockerHub.

## Updating

The [govuk_tech_docs](https://rubygems.org/gems/govuk_tech_docs) gem is within the Gemfile.

Either Dependabot will automatically update the gem or a new PR with the gem updated is required.

The Gems in the `Gemfile` are fixed for various reasons. This prevents incrementing the versions.

## Markdown in html

Markdown syntax used within the compiled down html files can be found [here](https://daringfireball.net/projects/markdown/) and here [kramdown](https://kramdown.gettalong.org/syntax.html).
