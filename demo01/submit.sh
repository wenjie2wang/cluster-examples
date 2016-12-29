#! /bin/bash

work=`pwd`

for i in norm myt logis gamma weibull; do
  cd $work/$i
  for n in 100 200 300 400 500; do
    condor_submit mycondor-$n
  done
done
