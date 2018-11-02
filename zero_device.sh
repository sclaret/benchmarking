#! /usr/bin/env bash

run=0
runs=2
if=/dev/urandom

while [[ "$run" -lt "$runs" ]]; do
  echo "Run: $run (if: $if)"
  dd if=$if of=$1 iflag=fullblock bs=4MB #count=8
  run=$((run+1))
  if=/dev/zero
  echo
done
