#!/usr/bin/env bats

load discover_user

@test "ruby 1.9.3p392 is default" {
  run su - $TEST_USER -c "ruby -v"
  [ "$(echo ${lines[0]} | awk '{print $2}')" = "1.9.3p392" ]
}
