# CHANGELOG

Starting from v5.0.0, all notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v5.0.0] - 2024-10-26

### Breaking Changes

As documented in the release notes of tech-docs-gem [v4.0.0](https://github.com/alphagov/tech-docs-gem/releases/tag/v4.0.0):

> * BREAKING: drop support for end-of-life Ruby versions 2.7 and 3.0. The minimum Ruby version is now 3.1.
> * BREAKING: drop support for IE8
> * BREAKING: Upgrade to govuk-frontend v5.7.1 and introduce new Javascript entry point

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

### Removed

- Release to Docker Hub
