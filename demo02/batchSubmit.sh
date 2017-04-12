#!/bin/nohup bash
chmod a+x clusBase.R

# create directories
mkdir -p log output err Rout condors

limit=25

echo "start submitting jobs at $(date)"

for ((condorID = 1; condorID <= 3; condorID++))
do
    echo "condorID was $condorID at $(date)"
    sed "s/condorID/$condorID/g" condorBase > condor_$condorID.condor
    count=$(( $(condor_q $(whoami) | tail -n 1 | sed -n -e 's/ jobs;.*//p') ))
    echo "num. of running jobs was $count at $(date)."
    while [[ $count -ge $limit ]]
    do
        echo "wait 5 minutes at $(date)"
        sleep 5m
        count=$(( $(condor_q $(whoami) | tail -n 1 |\
                        sed -n -e 's/ jobs;.*//p') ))
        echo "num. of running jobs was $count at $(date)."
    done
    condor_submit condor_$condorID.condor
    echo "condorID $condorID was submitted at $(date)"
done

echo "all jobs were submitted at $(date)"
