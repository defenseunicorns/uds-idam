# Changelog

## [0.1.9](https://github.com/defenseunicorns/uds-idam/compare/v0.1.8...v0.1.9) (2023-08-23)


### Features

* remove hardcoded realm names ([0cde515](https://github.com/defenseunicorns/uds-idam/commit/0cde515e81c196362bc3fd5dd4368f861383aa93))


### Bug Fixes

* remove DUBBD nexus client ([b466876](https://github.com/defenseunicorns/uds-idam/commit/b466876b4b6aecb54fb13ea498fa4a4d6f6c61d6))
* remove P1 defined clientScopes ([1619a18](https://github.com/defenseunicorns/uds-idam/commit/1619a18253a13eeffb1c595dc93adb56345d3b43))
* remove P1 groups ([9871394](https://github.com/defenseunicorns/uds-idam/commit/9871394f2e04ac2cf1425dc99c7cb6a668fc1fec))
* update readme to reference new REALM variable ([3c4dfe8](https://github.com/defenseunicorns/uds-idam/commit/3c4dfe8d1b54f83f012507b6ad94f91a1f53def6))


### Miscellaneous

* update key certs for keycloak browser certs ([9a8d9e5](https://github.com/defenseunicorns/uds-idam/commit/9a8d9e56b52d60ecce761c581068da239fe28b04))

## [0.1.8](https://github.com/defenseunicorns/uds-idam/compare/v0.1.7...v0.1.8) (2023-08-09)


### Bug Fixes

* ci workflow reference ([aa2c9b3](https://github.com/defenseunicorns/uds-idam/commit/aa2c9b3232c41be95285e276a25869455f7e411e))
* move ip range for dev ([4e1ad30](https://github.com/defenseunicorns/uds-idam/commit/4e1ad300acf22acd55fb6e0c654c8de2b3b793ff))

## [0.1.7](https://github.com/defenseunicorns/uds-idam/compare/v0.1.6...v0.1.7) (2023-08-08)


### Bug Fixes

* clean up renovate stuff and things ([2696884](https://github.com/defenseunicorns/uds-idam/commit/2696884216b734008f2da17bc999f769b999754d))
* remove duplicated helm parameter ([31a9b57](https://github.com/defenseunicorns/uds-idam/commit/31a9b57bf3483a82cfc165dc8f117691b695d611))
* remove unneeded idam config file ([135a803](https://github.com/defenseunicorns/uds-idam/commit/135a803641111b7ec2121cfb3c59221655c57f3f))
* renovate comment regex ordering ([d862316](https://github.com/defenseunicorns/uds-idam/commit/d862316f78c687d09b0361cdd04d0461277768a2))
* renovate expects no quotes, more consistent ([d5d8994](https://github.com/defenseunicorns/uds-idam/commit/d5d899428194c86dc3cf05fdda9dd5df81ac84ad))
* renovate updates for catching more deps ([bdf7472](https://github.com/defenseunicorns/uds-idam/commit/bdf74725df08a75a23673ce49deafa2edda92534))
* rerun github action for MR ([33f621e](https://github.com/defenseunicorns/uds-idam/commit/33f621ec1bcf41e27fb5697dec2d796408b4a2b1))
* update renovate configurations ([d2f7d00](https://github.com/defenseunicorns/uds-idam/commit/d2f7d004afa20ab5a170cd213b7f3566cda44af9))


### Miscellaneous

* **deps:** update all dependencies ([f65d4b8](https://github.com/defenseunicorns/uds-idam/commit/f65d4b814de634fccaa5697d36a1af87643b9250))

## [0.1.6](https://github.com/defenseunicorns/uds-idam/compare/v0.1.5...v0.1.6) (2023-07-28)


### Bug Fixes

* template realm routes ([1f8efe3](https://github.com/defenseunicorns/uds-idam/commit/1f8efe36d7c4970e1af67b17d80ae921e7c5d819))
* use latest flux support chart ([d1ed822](https://github.com/defenseunicorns/uds-idam/commit/d1ed82281ca73c60468c72b5a9a11ba0b938d3c6))
* wait for HelmRelease ([ce06bc0](https://github.com/defenseunicorns/uds-idam/commit/ce06bc00583a0efa08fd1f17ce2af8e6bc30e714))


### Miscellaneous

* **deps:** update dependency stefanprodan/podinfo to v6.4.0 ([644b263](https://github.com/defenseunicorns/uds-idam/commit/644b2636f3a2a9566b4e6b6933d38ced7a18246a))
* metallb and podinfo test packages ([fff743c](https://github.com/defenseunicorns/uds-idam/commit/fff743cc23d3630c5ceac61634397e57032de9ff))
* move dev packages around ([c80b3c0](https://github.com/defenseunicorns/uds-idam/commit/c80b3c0472f91f3ec0124573163e785a94448943))
* remove k3d dir, use dubbd for testing ([06a6d4b](https://github.com/defenseunicorns/uds-idam/commit/06a6d4b89dcbcbe26ae0ef67eeb72527f15e6aba))

## [0.1.5](https://github.com/defenseunicorns/uds-idam/compare/v0.1.4...v0.1.5) (2023-07-25)


### Bug Fixes

* update default base domain ([cd025b0](https://github.com/defenseunicorns/uds-idam/commit/cd025b0aca1d6e196d43869fbc30f72de247d05e))
* use zarf var for gateway hostname ([180fa54](https://github.com/defenseunicorns/uds-idam/commit/180fa54441d7d9395ad91f498cbee5b624140625))

## [0.1.4](https://github.com/defenseunicorns/uds-idam/compare/v0.1.3...v0.1.4) (2023-07-20)


### Bug Fixes

* add values component ([fb93e6b](https://github.com/defenseunicorns/uds-idam/commit/fb93e6b5810e2d5ae24248cf6792ed969a4f0692))

## [0.1.3](https://github.com/defenseunicorns/uds-idam/compare/v0.1.2...v0.1.3) (2023-07-20)


### Miscellaneous

* **ci:** bump package version ([195bcf7](https://github.com/defenseunicorns/uds-idam/commit/195bcf71bb43d2f2b7fa51e417f600fae4d07341))

## [0.1.2](https://github.com/defenseunicorns/uds-idam/compare/v0.1.1...v0.1.2) (2023-07-20)


### Miscellaneous

* **ci:** fix publish step ([25ceea1](https://github.com/defenseunicorns/uds-idam/commit/25ceea1dd32c9fcbc616fd06005cd35420cda91a))

## [0.1.1](https://github.com/defenseunicorns/uds-idam/compare/v0.1.0...v0.1.1) (2023-07-20)


### Features

* **values:** configure realm values via files ([e602ce0](https://github.com/defenseunicorns/uds-idam/commit/e602ce0650ef99721562d190f1d02d6153380f08))


### Miscellaneous

* **ci:** add init step ([34d77be](https://github.com/defenseunicorns/uds-idam/commit/34d77befcabb791347dc3913e577a0bf8200c2bc))
* **ci:** release process for package ([809fdc0](https://github.com/defenseunicorns/uds-idam/commit/809fdc0624dd08ca35ad3b3bc4bc1b5eadb8e6e4))
* **ci:** remove timeout for package create ([434c90c](https://github.com/defenseunicorns/uds-idam/commit/434c90c9a176a1b65a68b1dd3150398a24aad32c))
* **ci:** use latest zarf for ci ([4d85f9b](https://github.com/defenseunicorns/uds-idam/commit/4d85f9b74a5832dcfdd510270c195be26eaac0a5))
