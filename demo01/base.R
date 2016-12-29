source("setup.R")
options(show.error.messages = FALSE, warn = -1)

set.seed("SEED")

h0s <- c("norm", "myt", "logis", "gamma", "weibull")

tds <- trueDists()
rtd <- tds[["TRUEDIST"]]

nobs <- NOBS
simu <- "SIMU"

foo <- round(t(replicate(NSIM, do1(h0s, rtd, nobs, simu))), 3)
write.table(foo, file = "FILE", row.names = FALSE, col.names = FALSE)
proc.time()
