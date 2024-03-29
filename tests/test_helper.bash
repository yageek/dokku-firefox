#!/usr/bin/env bash
source "$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")/config"

reset_system_data() {
  local containers=$(sudo docker ps -aq)
  if [ "$containers" != "" ]; then
    sudo docker stop $containers > /dev/null 2>&1
  fi
  sudo docker system prune -f > /dev/null 2>&1
  if [ -z $FIREFOX_ROOT ]; then
    echo "FIREFOX_ROOT not set, can't clean up tests"
    exit -1
  else
    sudo -u dokku rm -rf /home/dokku/app /home/dokku/my_app $FIREFOX_ROOT/*
  fi
}

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$*"
    fi
  }
  return 1
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_exit_status() {
  assert_equal "$status" "$1"
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [[ "$status" -eq 0 ]]; then
    flunk "expected failed exit status"
  elif [[ "$#" -gt 0 ]]; then
    assert_output "$1"
  fi
}

assert_exists() {
  if [ ! -f "$1" ]; then
    flunk "expected file to exist: $1"
  fi
}

assert_contains() {
  if [[ "$1" != *"$2"* ]]; then
    flunk "expected $2 to be in: $1"
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal "$expected" "$output"
}
