Cluster Demo 2
==============================


# Sample Simulation

1. Generate right-censoring data with event times following Gompertz,
   Weibull, or Exponential distribution.

2. Fit regular Cox model to the simulated data.

3. Summarize the simulation results.


# Files

## **R** scripts

+ clusBase.R: The main executable **R** script that performs model fitting on
  one simulated dataset.

+ simuData.R: Function that generates simulated datesets.

+ simuFun.R: A collection of functions that helps simulation.

+ simuSettings: Simulation settings.

+ summar.R: Script summarizing simulation results.

## Others

+ clusBase.sh: Bash script that submits generate condor files from condor
  template, submit jobs for clusBase.R.

+ condorBase: condor template.

+ Makefile: simple Makefile to save some typing.


# Sample Usage

1. Place all the files under `~/jobs/` by `scp`. For example,

    ```
    $ scp -r ../demo02/* userName@statsCluster:~/jobs/
    ```

2. Submit jobs by `bash clusBase.sh` or `make submit`.  If everything works
   fine, condor files will be generated and directories, `condors`, `err`,
   `log`, `output`, and `Rout` will be created (if previously they did not
   exist).

3. Check status of the submitted jobs by `condor_q` or `condor_q -submitter
   userName`.

4. After all jobs are completed, `make move` to move model fitting results
   saved in `.RData` files to directory `output` and condor files generated
   to `condors`.

5. Pull `output` from cluster to local by `scp`. For example,

    ```
    $ scp -r userName@statsCluster:~/jobs/output .
    ```

6. Combine simulation results from each setting by `make collect`.

7. Summarize simulation results by `make summary`.


# Notes

For demonstration purpose, the number of queues specified in condor is 10.
Therefore, only 10 times replicates will be performed. For more serious
simulation studies, one may increase the queue number to the number of
replicates needed.

