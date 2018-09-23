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
