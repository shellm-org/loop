#!/bin/bash

sleep 2
echo Pausing loop
loop pause "my loop name"

sleep 2
echo Resuming loop
loop resume "my loop name"

sleep 2
echo Stopping loop
loop stop "my loop name"
