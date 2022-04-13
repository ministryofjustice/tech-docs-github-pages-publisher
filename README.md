# Tech Docs GitHub Pages Publisher

[![Releases](https://img.shields.io/github/release/ministryofjustice/tech-docs-github-pages-publisher/all.svg?style=flat-square)](https://github.com/ministryofjustice/tech-docs-github-pages-publisher/releases)

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.data%5B%3F%28%40.name%20%3D%3D%20%22tech-docs-github-pages-publisher%22%29%5D.status&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fgithub_repositories)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/github_repositories#tech-docs-github-pages-publisher "Link to report")

This repository creates a Docker image and publishes the image to DockerHub. 

The Docker image is pulled by other repository CI/CD and combined with their source code to create documentation websites that meet government technical documents and then push the data to GH Pages.

The contents of the Docker image will compile markdown files, ie .html.md.erb, into HTML and assets using the GOV.UK [Technical Documentation Template](https://tdt-documentation.london.cloudapps.digital/) / [Source code](https://github.com/alphagov/tech-docs-template).

There are two scripts within the Docker image:

* [preview.sh](publishing-scripts/preview.sh) - serve the compiled HTML and assets on a localhost port - useful for previewing the site locally
* [publish.sh](publishing-scripts/publish.sh) - compiles the docs into /docs and pushes it to the gh-pages branch, which GitHub Pages will serve

This image is used by the [MoJ Template Documentation Site](https://github.com/ministryofjustice/template-documentation-site) repository for MOJ technical documentation that gets published to GitHub Pages.

## CI/CD

A [GitHub Action](.github/workflows/docker-hub.yml) publishes this repository Docker image to DockerHub.

## Updating

The [govuk_tech_docs](https://rubygems.org/gems/govuk_tech_docs) gem is within the Gemfile.
Either dependabot will automatically update the Gem or a new PR with the gem updated is required.
