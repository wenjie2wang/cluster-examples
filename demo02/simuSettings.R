################################################################################
### Simulation settings
###
### see simuData.R for details.
################################################################################


### different simulation settings

## sample size (number of subjects)
nSubject <- rep(1000, 3)

## shape parameters
shape <- c(2, 2, 1)

## specify distributions
type <- c("gomp", "weib", "weib")


### put the settings into data.frame or list
options(stringsAsFactors = FALSE)
simuSetMat <- data.frame(nSubject, shape, type)
simuSetMat$simuID <- seq_len(nrow(simuSetMat))


### or generate all combination of different simulation settings by expand.grid?
## nSubject <- 200
## shape <- c(1, 2)
## type <- c("gomp", "weib")
## simuSetMat <- expand.grid(nSubject = nSubject, shape = shape, type = type)
## simuSetMat$simuID <- seq_len(nrow(simuSetMat))
