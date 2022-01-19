# Tech Docs GitHub Pages Publisher

[![Releases](https://img.shields.io/github/release/ministryofjustice/tech-docs-github-pages-publisher/all.svg?style=flat-square)](https://github.com/ministryofjustice/tech-docs-github-pages-publisher/releases)

Docker image that compiles the markdown into HTML+assets using the [GOV.UK Tech Docs Template](https://github.com/alphagov/tech-docs-template).

Provides scripts which are often specified as the entry point:

* [preview.sh](publishing-scripts/preview.sh) - serve the compiled HTML+assets on a localhost port - useful for previewing the site locally
* [publish.sh](publishing-scripts/publish.sh) - compiles the docs into /docs and pushes it to gh-pages branch, which GitHub Pages will serve

This image is used by [template-documentation-site][https://github.com/ministryofjustice/template-documentation-site], which is a template for a repo, for MOJ technical documentation that gets published to GitHub Pages.

## CI/CD

A GitHub Action [publishes the image to DockerHub](.github/workflows/docker-hub.yml).

## Updating

TODO write down the process for updating the version of tech-docs-template
