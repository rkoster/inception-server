#!/usr/bin/env bats

@test "vcap user created" {
  [ -d /home/vcap ]
  [ -f /home/vcap/.profile ]
  [ -f /home/vcap/.bash_profile ]
  [ -f /home/vcap/.bashrc ]
}