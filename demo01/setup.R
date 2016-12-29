library(fgof)
library(nortest)
library(tseries)
library(survival)
library(copula)
library(mvShapiroTest)

## wrapper for t, with unknown location and scale, but known df = 5
dmyt <- function(x, location, scale, df = 5, log = FALSE) {
    z <- (x - location) / scale
    val <- dt(z, df, log = log)
    if (log) val - log(scale) else val / scale
}

pmyt <- function(x, location, scale, df = 5, log.p = FALSE) {
    z <- (x - location) / scale
    pt(z, df, log.p = log.p)
}

rmyt <- function(n, location, scale, df = 5) {
    rt(n, df) * scale + location
}

qmyt <- function(p, location, scale, df = 5) {
    qt(p, df) * scale + location
}

## pseudo values were obtained from pseudo.R
trueDists <- function() {
    trueDs <- list(function(n) rnorm(n, mean = 10, sd = 1),
                   function(n) rt(n, df = 5) * 0.856 + 10,
                   function(n) rlogis(n, location = 10, scale = 0.572),
                   function(n) rgamma(n, shape = 98.671, rate = 9.866),
                   function(n) rweibull(n, shape = 10.618, scale = 10.452))
    names(trueDs) <- c("norm", "myt", "logis", "gamma", "weibull")
    trueDs
}


## get starting values
getStart <- function(x, d) {
    mm <- mean(x, trim = 0.02) ## trimmed mean for robustness
    ss <- mean(abs(x - mm), trim = 0.02)
    if (d %in% c("norm")) return(list(mean = mm, sd = ss))
    if (d %in% c("myt", "logis")) return(list(location = mm, scale = ss))
    if (d == "gamma") {
        shape = (mm / ss)^2
        scale = ss^2 / mm
        return(list(shape = shape, rate = 1 / scale))
    }
    if (d == "weibull") {
        fit <- survreg(Surv(x) ~ 1, dist = "weibull") ## from package survival
        return(list(shape = 1 / fit$scale, scale = exp(fit$coef)))
    }
}

nortest <- function(x) {
    pval <- rep(NA, 7)
    pval[1] <- shapiro.test(x)$p.value
    pval[2] <- jarque.bera.test(x)$p.value
    pval[3] <- ad.test(x)$p.value
    pval[4] <- cvm.test(x)$p.value
    pval[5] <- lillie.test(x)$p.value
    pval[6] <- pearson.test(x)$p.value
    pval[7] <- sf.test(x)$p.value
    pval
}

## one replicate
do1 <- function(h0s, rtd, nobs, simu = "mult") {
    p <- length(h0s)
    pval <- matrix(NA, p, 4)
    x <- rtd(nobs)
    for (i in 1:p) {
        start <- try(getStart(x, h0s[i]))
        if (inherits(start, "try-error")) next
        psca <- abs(unlist(start))
        psca[1] <- pmax(psca[1], 1)
        gof <- try(gof.test(x, h0s[i], nsim = 1000, start = start,
                            simulation = simu,
                            control = list(maxit = 20000, parscale = psca),
                            qgrid = "fitted", gridStat = TRUE))
        if (inherits(gof, "try-error")) next
        pval[i,] <- gof$p.value
    }
    c(pval, nortest(x))
}
