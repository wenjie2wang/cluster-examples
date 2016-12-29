library(survival)
library(MASS)

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

## minimizing kl divergence
set.seed(20100310)
n <- 1e6
x <- rnorm(n, 10, 1)
(n.t <- fitdistr(x, dmyt, list(location = 10, scale = sqrt(3 / 5))))
(n.logis <- fitdistr(x, dlogis, list(location = 10, scale = sqrt(3) / pi)))
(n.gamma <- fitdistr(x, dgamma, list(shape = 100, rate = 10)))
fit <- survreg(Surv(x) ~ 1, dist = "weibull") # from package survival
(n.weibull <- fitdistr(x, dweibull, list(shape = 1 / fit$scale,
                                         scale = exp(fit$coef))))

save(n.t, n.logis, n.gamma, n.weibull, file = "pseudo.RData")
