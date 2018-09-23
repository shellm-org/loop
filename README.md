<p align="center">
  <img src="https://gl.githack.com/shellm/loop/raw/master/logo.png">
</p>

<h1 align="center">Control your loop flow</h1>

<p align="center">Pause, resume or stop loops running in a process, from anywhere.</p>

<p align="center">
  <a href="https://gitlab.com/shellm/loop/commits/master">
    <img alt="pipeline status" src="https://gitlab.com/shellm/loop/badges/master/pipeline.svg" />
  </a>
  <!--<a href="https://gitlab.com/shellm/loop/commits/master">
    <img alt="coverage report" src="https://gitlab.com/shellm/loop/badges/master/coverage.svg" />
  </a>-->
  <a href="https://gitter.im/shellm/loop">
    <img alt="gitter chat" src="https://badges.gitter.im/shellm/loop.svg" />
  </a>
</p>

`loop` allows you to control the flow of a loop
running in a script or shell process from another script or process.

```bash
# in script or shell 1
loop init "my loop name"

i=1
while true; do
  loop control "my loop name"
  echo Iteration $i
  (( i++ ))
  sleep 1
done

echo End
```

```bash
# in script or shell 2
# ...sleep a bit
loop pause "my loop name"
# ...sleep a bit
loop resume "my loop name"
# ...sleep a bit
loop stop "my loop name"
```

<h2 align="center">Demo</h2>
<p align="center"><img src="https://gl.githack.com/shellm/loop/raw/master/demo/demo.svg"></p>

## Installation
Installation is done with [basher](https://github.com/basherpm/basher):

```bash
basher install gitlab.com/shellm/loop
```

## Usage
TODO
