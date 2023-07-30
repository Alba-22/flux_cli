# Flux CLI

Just a simple interactive CLI for help running and building flutter projects that use dart-defines as its environments variables approach.

## Getting Started 🚀

Activate globally via:

```sh
dart pub global activate flux_cli
```

Or locally via:

```sh
dart pub global activate --source=path <path to this package>
```

## Available Commands

### Run

Run a flutter project getting the dart-defines arguments from .vscode/launch.json

```sh
$ flux run

# Specifying device
$ flux run -d <device_id>
```

### Build

Build a flutter project getting the dart-defines arguments from .vscode/launch.json

```sh
$ flux build
```

### Deploy

Builds and deploy a flutter project to android and ios stores using fastlane and getting the dart-defines arguments from .vscode/launch.json.

For this to work, your lane have to has the `deploy\_`` prefix following a name of an valid environment!

```sh
$ flux deploy
```

### Version

Shows CLI version

```sh
$ flux --version
```

### Help

Shows usage help

```sh
$ flux --help
```

---

## TODO

- [ ] List devices on `flux run` command
- [ ] Check for use of FVM - Currently all commands consider that user has FVM installed
- [ ] Add integration with Shorebird

---

[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
