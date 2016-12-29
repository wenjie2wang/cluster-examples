#! /bin/bash

work=`pwd`
simu=mult

for td in norm myt logis gamma weibull; do
  cd $work
  echo $td
  if [ ! -d $td ]; then
    mkdir $td
  fi
  cd $work/$td
  echo `pwd`
  ln -s ../setup.R .
  rm condor.log

  for nobs in 100 200 300 400 500; do
    sed "s/TRUEDIST/$td/; s/NOBS/$nobs/; s/SIMU/$simu/;" ../base.R > run-$nobs.R
    bash ../prepcondor.sh run-$nobs.R mycondor-$nobs 10 1000
  done
done

