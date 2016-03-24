#!/bin/bash
/usr/bin/jackd -P75 -dalsa -dhw:1 -p1024 -n3 -s -r44100  &
./sclang -a -l sclang.yaml mycode.scd
