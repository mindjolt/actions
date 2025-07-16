# Changelog

## [2.19.1](https://github.com/mindjolt/actions/compare/v2.19.0...v2.19.1) (2025-07-16)


### Bug Fixes

* update permission for slack-release-message entrypoint ([0e7fe89](https://github.com/mindjolt/actions/commit/0e7fe89e37f746479a99d64c5cb38ee8a3a89065))

## [2.19.0](https://github.com/mindjolt/actions/compare/v2.18.1...v2.19.0) (2025-07-16)


### Features

* add slack release message action ([8232fb0](https://github.com/mindjolt/actions/commit/8232fb07d02fa7b57e5657c7026564f70ae1f919))

## [2.18.1](https://github.com/mindjolt/actions/compare/v2.18.0...v2.18.1) (2025-05-14)


### Bug Fixes

* don't overwrite openapi.yml files when publishing ([049ef7d](https://github.com/mindjolt/actions/commit/049ef7d403af6f8702880520c27bd7f5c9c15b3a))

## [2.18.0](https://github.com/mindjolt/actions/compare/v2.17.0...v2.18.0) (2025-05-12)


### Features

* modify openapi-publish to replace previous version ([0ca3c2e](https://github.com/mindjolt/actions/commit/0ca3c2e112fd80763b6a5d15a6546094c0de8a6b))


### Bug Fixes

* revert openapi-publish changes for replacing previous versions ([b9868c2](https://github.com/mindjolt/actions/commit/b9868c27632efb260b382d4f4187e9a0e34aab76))

## [2.17.0](https://github.com/mindjolt/actions/compare/v2.16.1...v2.17.0) (2025-03-03)


### Features

* **SCRUM0-4915:** implement file version replace ([abc82e4](https://github.com/mindjolt/actions/commit/abc82e447a0fd306022a19fb62c7dd9690d32316))

## [2.16.1](https://github.com/mindjolt/actions/compare/v2.16.0...v2.16.1) (2025-02-20)


### Bug Fixes

* resolves issue when extracting info from package.json file, updates commit messages format ([3c02ad6](https://github.com/mindjolt/actions/commit/3c02ad66f0c2a55dd5de0d9eefd93bf0c212f83d))

## [2.16.0](https://github.com/mindjolt/actions/compare/v2.15.2...v2.16.0) (2025-02-19)


### Features

* add jcpm-index-builder ([0f02647](https://github.com/mindjolt/actions/commit/0f02647cf3cd29e5c8ab197be91a1d043ba4c315))

## [2.15.2](https://github.com/mindjolt/actions/compare/v2.15.1...v2.15.2) (2025-02-18)


### Bug Fixes

* removes sdkRepo input parameter from package-manager-prepublish-github action ([657c6e8](https://github.com/mindjolt/actions/commit/657c6e8049836671673b2278be2cf18c9dd3e1ff))

## [2.15.1](https://github.com/mindjolt/actions/compare/v2.15.0...v2.15.1) (2025-02-18)


### Miscellaneous Chores

* release 2.15.1 ([b571473](https://github.com/mindjolt/actions/commit/b571473c5ee7aeff8655bfcb9ed93cb242d9d48d))

## [2.15.0](https://github.com/mindjolt/actions/compare/v2.14.0...v2.15.0) (2025-02-17)


### Features

* adds package-manager-prepublish-github and package-manager-publish-github actions to be used on the new jcpm artifact repo ([b34e559](https://github.com/mindjolt/actions/commit/b34e559671dd193915ec90b83c966c4900c6c86f))

## [2.14.0](https://github.com/mindjolt/actions/compare/v2.13.0...v2.14.0) (2025-02-04)


### Features

* **GS-20988:** NuGet - do not publish snapshots ([99c7117](https://github.com/mindjolt/actions/commit/99c7117a2c8b3047ef630719d4ae93d03974e90b))

## [2.13.0](https://github.com/mindjolt/actions/compare/v2.12.1...v2.13.0) (2024-11-20)


### Features

* Implement OpenAPI (Swagger) publish action ([d55e71d](https://github.com/mindjolt/actions/commit/d55e71d26ef13fc40e537788045445f6267ff115))

## [2.12.1](https://github.com/mindjolt/actions/compare/v2.12.0...v2.12.1) (2022-11-17)


### Bug Fixes

* **ci:** force push the major version tags ([224a895](https://github.com/mindjolt/actions/commit/224a895b480b2e49bbd347885392ae64c020b947))

## [2.12.0](https://github.com/mindjolt/actions/compare/v2.11.1...v2.12.0) (2022-11-17)


### Features

* **ci:** asign tags explicitly in build.yml via inputs ([d92a752](https://github.com/mindjolt/actions/commit/d92a752f02869f91a79f35276e54cea796688c22))
* **ci:** tag the repo with the major version when releasing ([bdd61e7](https://github.com/mindjolt/actions/commit/bdd61e7ac49e744cbd320acfe4530c84e8bcae1e))


### Bug Fixes

* **ci:** properly condition major version tagging ([d221d6d](https://github.com/mindjolt/actions/commit/d221d6d112ccb99e05463566127fca5d7b4d78e4))
* update all docker based actions to assume the v2 tag version ([38c783a](https://github.com/mindjolt/actions/commit/38c783a27080658add199ad8d12a76f80329898a))

## [2.11.1](https://github.com/mindjolt/actions/compare/v2.11.0...v2.11.1) (2022-11-16)


### Bug Fixes

* Fixed confluence-mac/confluence.sh. Stupid bugs. ([9f7a224](https://github.com/mindjolt/actions/commit/9f7a2242425e613f00d6e986252368364c711063))


### Miscellaneous Chores

* release 2.11.1 ([6d4a6fb](https://github.com/mindjolt/actions/commit/6d4a6fb65c603752acabd407bac46cbae626203b))

## [2.11.0](https://github.com/mindjolt/actions/compare/v2.10.3...v2.11.0) (2022-11-16)


### Features

* bump minor version over patch during snapshot bump ([d66d5b3](https://github.com/mindjolt/actions/commit/d66d5b31e707285ca6e1b5ef1913acfccad5e200))

## [2.10.3](https://github.com/mindjolt/actions/compare/v2.10.2...v2.10.3) (2022-11-15)


### Bug Fixes

* **ci:** add fully qualified sem ver for the csharp-build-env so it can be used by the sbt-unity-action Dockerfile ([5affc93](https://github.com/mindjolt/actions/commit/5affc93ebb6270cb49d81e5422c6bf346b87bc3d))

## [2.10.2](https://github.com/mindjolt/actions/compare/v2.10.1...v2.10.2) (2022-11-15)


### Bug Fixes

* **ci:** use correct job output name for the final version ([817bccf](https://github.com/mindjolt/actions/commit/817bccf6e3b8101d412b290a77d8108869a3054a))

## [2.10.1](https://github.com/mindjolt/actions/compare/v2.10.0...v2.10.1) (2022-11-15)


### Bug Fixes

* **ci:** inherit secrets when calling the build workflow ([2157f53](https://github.com/mindjolt/actions/commit/2157f533403eb4426f295785488c2e26bf2eec79))

## [2.10.0](https://github.com/mindjolt/actions/compare/v2.9.1...v2.10.0) (2022-11-15)


### Features

* **build-tag:** adding tagSeparator character option ([a165dfe](https://github.com/mindjolt/actions/commit/a165dfe65ba1e4ed35e8e7bebd29ca44bafd7cac))
* **ci:** add release-please and build workflow with additional version tags ([92e5db7](https://github.com/mindjolt/actions/commit/92e5db7b03359074a2b98ee47256f8192cea88b5))


### Bug Fixes

* **build-tag:** fixing js logging error ([a7d6ca7](https://github.com/mindjolt/actions/commit/a7d6ca78a28de9021326f386ce148d28078292f5))
* build.yml yaml syntax ([9a9a056](https://github.com/mindjolt/actions/commit/9a9a05623a928aae6674752108e6c244e81ecddf))
* consume input env vars from github directly in script ([e5caf96](https://github.com/mindjolt/actions/commit/e5caf96808a819582570b452abb315903a1c6c89))
* set-output and node12 warnings in build-tags, use @vercel/ncc ([3f387ae](https://github.com/mindjolt/actions/commit/3f387aed365a551d35a8235219b77890778139e7))

## Changelog
