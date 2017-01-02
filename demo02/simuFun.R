################################################################################
### A collection of functions for simulation
################################################################################


### oracle procedure by Cox model for coefficient estimates
ezCox <- function(...) {
    out <- survival::coxph(...)
    betaHat <- coef(out)
    betaHatSe <- sqrt(diag(out$var))
    ## return esimates of beta and their se estimates
    idx <- seq_along(betaHat)
    setNames(c(betaHat, betaHatSe),
             c(paste0("b", idx), paste0("se(b", idx, ")")))
}


### summarize the simulation results for fitted Cox model
summar <- function (fitList, beta0 = c(1, 1), level = 0.95, ...) {
    coxMat <- do.call(rbind, fitList)
    meanVec <- colMeans(coxMat)
    idx <- seq_along(beta0)
    betaHat <- coxMat[, idx]
    betaHatSe <- coxMat[, - idx]

    ## compute coverage probability
    cri <- stats::qnorm((1 + level) / 2)
    uppVec <- betaHat + cri * betaHatSe
    lowVec <- betaHat - cri * betaHatSe
    coverProb <- sapply(idx, function(a) {
        mean(beta0[a] >= lowVec[, a] & beta0[a] <= uppVec[, a])
    })
    names(coverProb) <- paste0("coverProb(b", idx, ")")

    ## empirical standard error
    empirSe <- sapply(idx, function(a) {
        sd(betaHat[, a])
    })

    res <- c(rbind(meanVec[- idx], empirSe))
    names(res) <- c(rbind(paste0("se(b", idx, ")"),
                          paste0("ese(b", idx, ")")))

    c(meanVec[idx], res, coverProb)
}
