#!/bin/bash
PATH=$PATH:/usr/local/bin
sleep 5
./sclang -a -l sclang.yaml mycode.scd

#sleep 30
#/usr/local/bin/jackd -P75 -dalsa -dhw:1 -p1024 -n3 -s -r44100  &
#./sclang -a -l sclang.yaml mycode.scd
