# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

<a name="unreleased"></a>
## [3.0.1](https://github.com/mirakl/terraform-google-gcr-cleaner/compare/v3.0.0...v3.0.1) (2023-04-24)


### Features

* Add support of `GCRCLEANER_LOG` ([#71](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/71)) ([0531dc9](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/0531dc9d94cb510010648b8e92e258fac212bc3d))

## [3.0.0](https://github.com/mirakl/terraform-google-gcr-cleaner/compare/v2.0.0...v3.0.0) (2023-03-09)


### ⚠ BREAKING CHANGES

* If scheduler name is set use it as name of the job resource ([#69](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/69))

### Features

* Allow setting full version of gcr cleaner ([#68](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/68)) ([ace8dc2](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/ace8dc2d172f68801f80c4b80e70f151789f6333))
* If scheduler name is set use it as name of the job resource ([#69](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/69)) ([efe22ce](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/efe22ce56e0aba4cb1b010106098539a22e8c1f5))

## [2.0.0](https://github.com/mirakl/terraform-google-gcr-cleaner/compare/v1.4.1...v2.0.0) (2022-09-23)


### ⚠ BREAKING CHANGES

* Prepare to work with terraform 1.3.0 (#66)

### Bug Fixes

* Prepare to work with terraform 1.3.0 ([#66](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/66)) ([72f29b6](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/72f29b67323b8510f7f39afd8803d6f50451e3f5))

## [1.4.1](https://github.com/mirakl/terraform-google-gcr-cleaner/compare/v1.4.0...v1.4.1) (2022-09-20)


### Bug Fixes

* Gar multiple projects ([#62](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/62)) ([28d7b66](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/28d7b665fce130b159c2f01b46228a76de43aaa5))

## [1.4.0](https://github.com/mirakl/terraform-google-gcr-cleaner/compare/v1.3.0...v1.4.0) (2022-08-10)


### Features

* Set different rules per docker image in a Artifact Registry docker repository ([#53](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/53)) ([75cc8dd](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/75cc8dd9c59f272ac4f37e50c61a6423aaed14fc))


### Bug Fixes

* Adding repos parameter to payload ([#27](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/27)) ([0b62c57](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/0b62c57161feec5fee91b0d38b75fd47fb9873f7))

## [Unreleased]



<a name="v1.3.0"></a>
## [v1.3.0] - 2022-06-23
Enhancements:
- Add scheduler_job_name and scheduler_job_description optional inputs ([#48](https://github.com/mirakl/terraform-gcr-cleaner/issues/48))
- Update repository security ([#47](https://github.com/mirakl/terraform-gcr-cleaner/issues/47))
- Add serviceAccountUser permission when terraform is running as a service-account ([#45](https://github.com/mirakl/terraform-gcr-cleaner/issues/45))

Continous Integration:
- Upgrade jobs ([#50](https://github.com/mirakl/terraform-gcr-cleaner/issues/50))


<a name="v1.2.0"></a>
## [v1.2.0] - 2022-02-03
Documentation:
- Updating README.md ([#42](https://github.com/mirakl/terraform-gcr-cleaner/issues/42))

Features:
- Add basic Google Artifact Registry support ([#39](https://github.com/mirakl/terraform-gcr-cleaner/issues/39))
- Implement dry_run to easily list images to delete ([#34](https://github.com/mirakl/terraform-gcr-cleaner/issues/34))

Continous Integration:
- Fix release job ([#41](https://github.com/mirakl/terraform-gcr-cleaner/issues/41))


<a name="v1.1.0"></a>
## [v1.1.0] - 2022-01-18
Features:
- Add support for GCR buckets with uniform_bucket_level_access = true ([#32](https://github.com/mirakl/terraform-gcr-cleaner/issues/32))
- Introduce new payload parameters ([#29](https://github.com/mirakl/terraform-gcr-cleaner/issues/29))


<a name="v1.0.0"></a>
## [v1.0.0] - 2021-11-24
Bug Fixes:
- Adding repos parameter to payload ([#27](https://github.com/mirakl/terraform-gcr-cleaner/issues/27))

Continous Integration:
- Upgrade terraform version ([#26](https://github.com/mirakl/terraform-gcr-cleaner/issues/26))

Features:
- Implementing all payload parameters ([#24](https://github.com/mirakl/terraform-gcr-cleaner/issues/24))


<a name="v0.6.0"></a>
## [v0.6.0] - 2021-05-03
Documentation:
- Update documentation ([#13](https://github.com/mirakl/terraform-gcr-cleaner/issues/13))


<a name="v0.5.0"></a>
## [v0.5.0] - 2021-04-30
Continous Integration:
- Trigger the workflow only on push to main branch ([#10](https://github.com/mirakl/terraform-gcr-cleaner/issues/10))

Code Refactoring:
- Upgrade to use terraform 15 ([#9](https://github.com/mirakl/terraform-gcr-cleaner/issues/9))


<a name="v0.4.0"></a>
## [v0.4.0] - 2021-04-13
Enhancements:
- Configure scheduler job retries ([#7](https://github.com/mirakl/terraform-gcr-cleaner/issues/7))


<a name="v0.3.0"></a>
## [v0.3.0] - 2021-04-12
Enhancements:
- Use configurable resources ([#5](https://github.com/mirakl/terraform-gcr-cleaner/issues/5))


<a name="v0.2.0"></a>
## [v0.2.0] - 2021-04-09
Features:
- Implementing get all repositories of a given project ([#3](https://github.com/mirakl/terraform-gcr-cleaner/issues/3))


<a name="v0.1.0"></a>
## v0.1.0 - 2021-04-07
Features:
- First Implementation of GCR Cleaner ([#1](https://github.com/mirakl/terraform-gcr-cleaner/issues/1))


[Unreleased]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v1.3.0...HEAD
[v1.3.0]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v1.2.0...v1.3.0
[v1.2.0]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v0.6.0...v1.0.0
[v0.6.0]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v0.5.0...v0.6.0
[v0.5.0]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/mirakl/terraform-gcr-cleaner/compare/v0.1.0...v0.2.0
