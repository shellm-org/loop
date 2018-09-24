#!/bin/bash

export SHELLS="bash-4.4.12"

scripts=$(find bin -type f)
libs=$(find lib -name '*.sh')

success=0
failure=1
