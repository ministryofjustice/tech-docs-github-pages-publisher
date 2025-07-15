# Tech Docs - GitHub Pages Publisher

[![Ministry of Justice Repository Compliance Badge](https://github-community.service.justice.gov.uk/repository-standards/api/tech-docs-github-pages-publisher/badge)](https://github-community.service.justice.gov.uk/repository-standards/tech-docs-github-pages-publisher)

[![Open in Dev Container](https://raw.githubusercontent.com/ministryofjustice/.devcontainer/refs/heads/main/contrib/badge.svg)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/ministryofjustice/tech-docs-github-pages-publisher)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/ministryofjustice/tech-docs-github-pages-publisher)

This repository packages the Government Digital Service's [tech-docs-gem](https://github.com/alphagov/tech-docs-gem) in a container, to make it simple to use when developing and publishing your technical documentation using the [template-documentation-site](https://github.com/ministryofjustice/template-documentation-site).

Usage of this container will be documented on the [template-documentation-site](https://github.com/ministryofjustice/template-documentation-site).

## Developing

### Build Container

```bash
make build
```

### Previewing Test Site

```bash
make preview
```

## Managing Software Versions

### Base Image and Ruby

> [!NOTE]
> Dependabot might try to update this to the latest `ruby` image, but doing so will fail the [Container Structure Test](test/container-structure-test.yml)

The base image is derived from [tech-docs-gem's](https://github.com/alphagov/tech-docs-gem) latest supported Ruby version, which can be found in their [test matrix](https://github.com/alphagov/tech-docs-gem/blob/main/.github/workflows/test.yaml#L17).

As of 17/06/25, that version is [3.3.8](https://www.ruby-lang.org/en/news/2025/04/09/ruby-3-3-8-released/).

Using 3.3.8, you can find the latest Alpine image by [searching Docker Hub](https://hub.docker.com/_/ruby/tags?name=3.3.8-alpine).

To obtain the SHA, you can run:

```bash
docker pull --platform linux/amd64 docker.io/ruby:3.3.8-alpine3.22

docker image inspect --format='{{ index .RepoDigests 0 }}' docker.io/ruby:3.3.8-alpine3.22
```

### Gemfile and Gemfile.lock

> [!IMPORTANT]
> Dependabot is configured to maintain these, however this repository is just packaging `govuk_tech_docs`, so proceed with caution when reviewing and approving

When the Government Digital Service release a new version of [`govuk_tech_docs`](https://rubygems.org/gems/govuk_tech_docs), update [`src/opt/publisher/Gemfile`](src/opt/publisher/Gemfile) and run `make copy-gemlock`. This will build the image, and copy the generated `Gemfile.lock` out of the image.

## Releasing

To create a new release, follow [GitHub's guidance](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release), opting to create a new tag in the process.
