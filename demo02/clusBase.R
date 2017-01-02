#!/home/statsadmin/R/bin/Rscript


################################################################################
### base R script for simulation study for different settings
################################################################################


### read argument
args <- commandArgs(trailingOnly = TRUE)
simuID <- eval(parse(text = args[1L]))
process <- eval(parse(text = args[2L]))


### set up output names
fitName <- paste("simuID", simuID, process, sep = "_")
fileName <- paste0(fitName, ".RData")


### attach packages needed
library(survival)
library(methods)
library(stats)


### source functions
source("simuData.R")
source("simuFun.R")
source("simuSettings.R")


### set up simulation settings
simuSet <- as.list(simuSetMat[simuID, ])


## generate simulated dataset
set.seed(1216 + process)
dat <- do.call(simuData, simuSet)


## mode-fitting
oneFit <- ezCox(Surv(obsTime, status) ~ x1 + x2, data = dat)


### save the results
assign(fitName, oneFit)
save(list = fitName, file = fileName)


proc.time()
