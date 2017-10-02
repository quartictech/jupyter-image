#!/usr/bin/env bats

@test "MySQL client works" {
  mysql --version
}
