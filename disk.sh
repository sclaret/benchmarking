#! /usr/bin/env bash

function clear_caches {
  rm cachebuster_mini.txt cachebuster.txt
  hexdump -e '"%u"' /dev/urandom | fold -w 64 | head -16384 >> cachebuster_mini.txt
  for i in {0..1024}; do
    cat cachebuster_mini.txt >> cacherbuster.txt
    echo "$i MB"
  done
}

function run {
  output=$(fio \
             --ioengine=sync \
             --direct=1 \
             --gtod_reduce=1 \
             --name=test \
             --bs=4k \
             --size=$1 \
             --readwrite=randrw \
             --output-format=json)

  read=$(echo $output | jq .jobs[0].read)
  write=$(echo $output | jq .jobs[0].write)

  read_iops=$(echo $read | jq .iops)
  read_bw=$(echo $read | jq .bw)

  write_iops=$(echo $write | jq .iops)
  write_bw=$(echo $write | jq .bw)

  echo "$1 $read_iops $write_iops $read_bw $write_bw"
}

function run_all {
  echo "run_size read_iops write_iops read_bw write_bw"
  run 4MB
  run 4MB
  echo "- - - - - "
  run 16MB
  run 16MB
  echo "- - - - - "
  run 32MB
  run 32MB
  echo "- - - - - "
  run 64MB
  run 64MB
  echo "- - - - - "             #
  run 128MB
  run 128MB
  echo "- - - - - "
  run 256MB
  run 256MB
  echo "- - - - - "
  run 512MB
  run 512MB
  echo "- - - - - "
  run 1024MB
  run 1024MB
  echo "- - - - - "
  run 2048MB
  run 2048MB
  run 2048MB
  run 2048MB
}

#clear_caches
run_all #| column -t
