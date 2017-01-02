#!/bin/bash
chmod a+x clusBase.R

# create directories
mkdir -p log output err Rout condors

echo "start submitting jobs"
date
for condorID in {1..3}
do
    sed "s/condorID/$condorID/g" condorBase > condor_$condorID.condor
    condor_submit condor_$condorID.condor
done
echo "all submitted"
date
