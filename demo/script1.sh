#!/bin/bash

source $(shellm-core-path)
shellm-source shellm/loop

loop init "my loop name"

i=1
while true; do

  loop control "my loop name"

  echo Iteration $i
  (( i++ ))
  sleep 1
done

echo End
