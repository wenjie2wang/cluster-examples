################################################################################
### functions generating simulated right-censoring data
################################################################################


##' Generate Simulated Survival Data
##'
##' The function generates survival data with exact event times and
##' right-censoring time.  The event times can be simulated from Gompertz
##' distribution, Weibull distribution, and exponential distribution as a
##' special case of Weibull distribution (\code{shape = 1}).  Censoring times
##' are generated from uniform distribution.
##'
##' @param nSubject Number of subjects.
##' @param beta0 Time-invariant covariate coefficients.
##' @param xMat Design matrix.
##' @param censorMin A non-negative number, lower bound of uniform
##'     distribution for censoring times.
##' @param censorMax A positive number, upper bound of uniform distribution
##'     for censoring times.
##' @param shape A positive number, shape parameter in baseline hazard
##'     function for event times.
##' @param scale A positive number, scale parameter in baseline hazard
##'     function for event times.
##' @param type Distribution name of event times. Partial matching is allowed.
##' @return A data frame.
##' @author Wenjie Wang
##' @references
##' Bender, R., Augustin, T., & Blettner, M. (2005).
##' Generating survival times to simulate Cox proportional hazards models.
##' \emph{Statistics in Medicine}, 24(11), 1713--1723.
##' @examples
##' simuData(100, type = "weibull")
simuData <- function(nSubject = 1e3, beta0, xMat, censorMin = 0,
                     censorMax = 10, shape = 1, scale = 0.01,
                     type = c("gompertz", "weibull"), ...) {

    ## set design matrix and coefficients for event times if missing
    if (missing(xMat)) {
        x1 <- sample(c(0, 1), size = nSubject, replace = TRUE)
        x2 <- round(rnorm(nSubject), 3)
        xMat <- cbind(x1, x2)
    } else
        xMat <- as.matrix(xMat)

    beta0 <- if (missing(beta0)) c(1, 1) else as.numeric(beta0)
    expXbeta <- as.numeric(exp(xMat %*% beta0))

    ## censoring times
    censorTime <- runif(n = nSubject, min = censorMin, max = censorMax)

    ## event times
    type <- match.arg(type)
    eventTime <- if (type == "gompertz")
                     rGompertz(nSubject, shape, scale * expXbeta)
                 else
                     rWeibull(nSubject, shape, scale * expXbeta)

    ## event indicator
    status <- as.integer(eventTime < censorTime)

    ## observed times
    obsTime <- ifelse(status, eventTime, censorTime)

    ## return
    data.frame(ID = seq_len(nSubject), xMat, obsTime, status)
}


### internal function ==========================================================
## similar function with eha::rgompertz, where param == "canonical"
rGompertz <- function(n, shape = 1, scale = 1, ...) {
    u <- runif(n)
    1 / shape * log1p(- shape * log1p(- u) / (scale * shape))
}


## similar function with stats::rweibull but with different parametrization
## reduces to exponential distribution when shape == 1
rWeibull <- function(n, shape = 1, scale = 1, ...) {
    u <- runif(n)
    (- log1p(- u) / scale) ^ (1 / shape)
}
