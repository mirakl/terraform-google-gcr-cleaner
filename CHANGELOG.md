# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

<a name="unreleased"></a>
## [1.4.0](https://github.com/mirakl/terraform-google-gcr-cleaner/compare/v1.3.0...v1.4.0) (2022-08-10)


### Features

* Add basic Google Artifact Registry support ([#39](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/39)) ([8d6ba49](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/8d6ba495277f9a55b7fce04e3b9f217994548c34))
* Add support for GCR buckets with uniform_bucket_level_access = true ([#32](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/32)) ([16d6232](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/16d6232b71f9a1f3bf38791d589274c7674f7f14))
* Change the release process ([#60](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/60)) ([d046976](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/d0469761e323107622634a3fcf5a2f8b22edfbd0))
* First Implementation of GCR Cleaner ([#1](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/1)) ([5ad9957](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/5ad9957e2acc59ed824848ad2fc5c17c4b5e86c7))
* Implement dry_run to easily list images to delete ([#34](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/34)) ([b5bb78a](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/b5bb78a813d273a3d2bcfefd2a062e0d1f83157c))
* Implementing all payload parameters ([#24](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/24)) ([dde3658](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/dde36588108e7636dded10cedda97cac35d13618))
* Implementing get all repositories of a given project ([#3](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/3)) ([f043971](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/f0439719eae592fdba2812652449890dcc547ab7))
* Introduce new payload parameters ([#29](https://github.com/mirakl/terraform-google-gcr-cleaner/issues/29)) ([0ea8b25](https://github.com/mirakl/terraform-google-gcr-cleaner/commit/0ea8b25761502e6d82606cb3c7defb8437b09667))
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
