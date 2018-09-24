setup() {
  test_loop=loop1
}

teardown() {
  loop stop $test_loop || true
}

@test "errors without arguments" {
  run loop
  [ "$status" -eq 1 ]
}

@test "correctly initializes a loop" {
  run loop init $test_loop
  [ "$status" -eq 0 ]

  run loop exists $test_loop
  [ "$status" -eq 0 ]
}

@test "correctly stops a loop" {
  loop init $test_loop

  run loop stop $test_loop
  [ "$status" -eq 0 ]

  run loop dead $test_loop
  [ "$status" -eq 0 ]
}

@test "correctly pauses a loop" {
  loop init $test_loop

  run loop pause $test_loop
  [ "$status" -eq 0 ]

  run loop paused $test_loop
  [ "$status" -eq 0 ]
}

@test "correctly resumes a loop" {
  loop init $test_loop
  loop pause $test_loop

  run loop resume $test_loop
  [ "$status" -eq 0 ]

  run loop alive $test_loop
  [ "$status" -eq 0 ]
}

@test "a just initialized loop is alive" {
  loop init $test_loop
  run loop alive $test_loop
  [ "$status" -eq 0 ]
}

@test "can't initialize an already existing loop" {
  loop init $test_loop
  run loop init $test_loop
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "loop: '$test_loop' already initialized" ]
}

@test "can't stop a dead loop" {
  run loop stop $test_loop
  [ "$status" -eq 1 ]
}

@test "can't pause a dead loop" {
  run loop pause $test_loop
  [ "$status" -eq 1 ]
}

@test "can't resume a dead loop" {
  run loop resume $test_loop
  [ "$status" -eq 1 ]
}

@test "pausing a paused loop has no effect" {
  loop init $test_loop
  loop pause $test_loop

  run loop pause $test_loop
  [ "$status" -eq 0 ]

  run loop paused $test_loop
  [ "$status" -eq 0 ]
}

@test "resuming an alive loop has no effect" {
  loop init $test_loop

  run loop resume $test_loop
  [ "$status" -eq 0 ]

  run loop alive $test_loop
  [ "$status" -eq 0 ]
}

@test "control returns 1 with dead loop" {
  run loop control $test_loop
  [ "$status" -eq 1 ]
}

@test "control correctly breaks a loop" {
  breaking_loop() {
    for l in line1 line2; do
      echo $l
      loop control $test_loop || break
    done
  }
  run breaking_loop
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = "line1" ]
}

@test "control lets loop run when alive" {
  loop init $test_loop
  running_loop() {
    for l in line1 line2; do
      echo $l
      loop control $test_loop
    done
  }
  run running_loop
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [ "${lines[0]}" = "line1" ]
  [ "${lines[1]}" = "line2" ]
}
