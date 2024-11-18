<!-- markdownlint-disable no-duplicate-heading -->
# CHANGELOG

Starting from v5.0.0, all notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v5.0.1] - 2024-11-18

### Changed

- `docker.io/ruby` to `sha256:b4c321a99b9f21b7bb24f22e558bf1477630fb55d692aba4e25b2fe5deb7eaf1`

- `bundler` to `2.5.23`

- `govuk_tech_docs` to `4.4.1` ([CHANGELOG](https://github.com/alphagov/tech-docs-gem/blob/main/CHANGELOG.md#411))

### Removes

- `rexml` `3.3.6` ([CVE-2024-49761](https://github.com/advisories/GHSA-2rxp-v6pw-ch6m))

## [v5.0.0] - 2024-10-26

### Breaking Changes

As documented in the release notes of tech-docs-gem [v4.0.0](https://github.com/alphagov/tech-docs-gem/releases/tag/v4.0.0):

> - BREAKING: drop support for end-of-life Ruby versions 2.7 and 3.0. The minimum Ruby version is now 3.1.
> - BREAKING: drop support for IE8
> - BREAKING: Upgrade to govuk-frontend v5.7.1 and introduce new Javascript entry point

The additional file `source/javascripts/govuk_frontend.js` is now required, you can find a copy [here](test/test-docs-example/source/javascripts/govuk_frontend.js).

### Added

- Dev Container

- Makefile

- Container Structure Test definition

- Super-Linter

- Trivy scanning

- Signing of container with Sigstore's [`cosign`](https://github.com/sigstore/cosign)

- GitHub Artifact Attestation

- This CHANGELOG document

### Changed

- tech-docs-gem is now [v4.0.1](https://github.com/alphagov/tech-docs-gem/releases/tag/v4.0.1)

- Refactor GitHub Actions

- Release to GitHub Container Registry

- Working directory has changed from `/app` to `/tech-docs-github-pages-publisher`

### Removed

- Release to Docker Hub
