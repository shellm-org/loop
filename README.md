# loop
Control the flow of your loops (pause/resume/etc.).

- Authors: https://gitlab.com/shellm/loop/AUTHORS.md
- Changelog: https://gitlab.com/shellm/loop/CHANGELOG.md
- Contributing: https://gitlab.com/shellm/loop/CONTRIBUTING.md
- Documentation: https://gitlab.com/shellm/loop/wiki
- License: ISC - https://gitlab.com/shellm/loop/LICENSE

## Installation
Installation with [basher](https://github.com/basherpm/basher):
```bash
basher install shellm/loop
```

Installation from source:
```bash
git clone https://gitlab.com/shellm/loop
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
include shellm/loop lib/loop.sh
# with shellm's include
shellm-include shellm/loop lib/loop.sh
```
