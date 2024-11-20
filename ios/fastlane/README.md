fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### build_ios_dev

```sh
[bundle exec] fastlane build_ios_dev
```

dev 버전 앱 빌드

### build_ios_prod

```sh
[bundle exec] fastlane build_ios_prod
```

prod 버전 앱 빌드

----


## iOS

### ios dev_testflight

```sh
[bundle exec] fastlane ios dev_testflight
```

dev 버전 앱 빌드 후 TestFlight 업로드

### ios upload_prod

```sh
[bundle exec] fastlane ios upload_prod
```

prod 버전 앱 빌드 후 App Store 업로드

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
