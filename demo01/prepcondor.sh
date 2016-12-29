#! /bin/bash

## $1 is the base R script name, $2 is my.condor
## $3 is number of processors
## $4 is numer of simulations


let nn=$(($4/$3))

## generate R files for distribution to condor
for i in $( seq 1 $3) ; do
  seed=$RANDOM
  let i=i-1
  sed "s/NSIM/$nn/; s/SEED/$seed/; s/FILE/out-$1-$i/;" $1 > $1-$i
done;

echo "executable = /home/statsadmin/R-2.13.0-32b/lib/R/bin/R" > $2
## echo "executable = /usr/local/bin/R" > $2
echo "arguments  = --vanilla"        >> $2
echo 'Requirements = ParallelSchedulingGroup == "stats group"' >> $2
## echo 'Requirements = Arch == "INTEL"' >> $2
echo "universe   = vanilla"          >> $2
echo "log        = condor.log"       >> $2
echo "input      = $1-\$(Process)"   >> $2
echo "output     = $1-\$(Process).Rout" >> $2
echo "error      = err-$1-\$(Process)"  >> $2
echo "notification = never"            >> $2
echo "should_transfer_files = YES"  >> $2
echo "when_to_transfer_output = ON_EXIT" >> $2
echo "transfer_input_files = setup.R"   >> $2
echo "queue $3"                        >> $2
