load $(basher package-path ztombol/bats-support)/load.bash
load $(basher package-path ztombol/bats-assert)/load.bash

setup() {
  test_loop=loop1
}

teardown() {
  loop stop $test_loop || true
}

@test "errors without arguments" {
  run loop
  assert_failure
}

@test "correctly initializes a loop" {
  run loop init $test_loop
  assert_success

  run loop exists $test_loop
  assert_success
}

@test "correctly stops a loop" {
  loop init $test_loop

  run loop stop $test_loop
  assert_success

  run loop dead $test_loop
  assert_success
}

@test "correctly pauses a loop" {
  loop init $test_loop

  run loop pause $test_loop
  assert_success

  run loop paused $test_loop
  assert_success
}

@test "correctly resumes a loop" {
  loop init $test_loop
  loop pause $test_loop

  run loop resume $test_loop
  assert_success

  run loop alive $test_loop
  assert_success
}

@test "a just initialized loop is alive" {
  loop init $test_loop
  run loop alive $test_loop
  assert_success
}

@test "can't initialize an already existing loop" {
  loop init $test_loop
  run loop init $test_loop
  assert_failure
  assert_output "loop: '$test_loop' already initialized" ]
}

@test "can't stop a dead loop" {
  run loop stop $test_loop
  assert_failure
}

@test "can't pause a dead loop" {
  run loop pause $test_loop
  assert_failure
}

@test "can't resume a dead loop" {
  run loop resume $test_loop
  assert_failure
}

@test "pausing a paused loop has no effect" {
  loop init $test_loop
  loop pause $test_loop

  run loop pause $test_loop
  assert_success

  run loop paused $test_loop
  assert_success
}

@test "resuming an alive loop has no effect" {
  loop init $test_loop

  run loop resume $test_loop
  assert_success

  run loop alive $test_loop
  assert_success
}

@test "control returns 1 with dead loop" {
  run loop control $test_loop
  assert_failure
}

@test "control correctly breaks a loop" {
  breaking_loop() {
    for l in line1 line2; do
      echo $l
      loop control $test_loop || break
    done
  }
  run breaking_loop
  assert_success
  assert_equal ${#lines[@]} 1
  assert_line --index 0 "line1"
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
  assert_success
  assert_equal ${#lines[@]} 2
  assert_line --index 0 "line1"
  assert_line --index 1 "line2"
}
