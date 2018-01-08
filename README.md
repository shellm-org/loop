# loop
Control the flow of your loops (pause/resume/etc.).

- Authors: https://github.com/shellm-org/loop/AUTHORS.md
- Changelog: https://github.com/shellm-org/loop/CHANGELOG.md
- Contributing: https://github.com/shellm-org/loop/CONTRIBUTING.md
- Documentation: https://github.com/shellm-org/loop/wiki
- License: ISC - https://github.com/shellm-org/loop/LICENSE

## Installation
Installation with [basher](https://github.com/basherpm/basher):
```bash
basher install shellm-org/loop
```

Installation from source:
```bash
git clone https://github.com/shellm-org/loop
cd loop
sudo ./install.sh
```

## Usage
Command-line:
```
loop -h
```

As a library:
```bash
# with basher's include
include shellm-org/loop lib/loop.sh
# with shellm's include
shellm-include shellm-org/loop lib/loop.sh
```
