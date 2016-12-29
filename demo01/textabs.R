library(xtable)

sumsim <- function(trued, ns) {
    val <- NULL
    for (td in trued) {
        for (n in ns) {
            fname <- file.path(td, paste0("out-", n))
            comm <- paste0("cat ", td, "/", "out-run-", n, ".R-* > ", fname)
            system(comm)
            pvals <- read.table(fname)
            names(pvals) <-
                c(paste("ks", c("norm", "myt", "logis", "gamma", "weib"),
                        sep="-"),
                  paste("cvm", c("norm", "myt", "logis", "gamma", "weib"),
                        sep="-"),
                  paste("ksa", c("norm", "myt", "logis", "gamma", "weib"),
                        sep="-"),
                  paste("cvma", c("norm", "myt", "logis", "gamma", "weib"),
                        sep="-"),
                  "shapiro", "jb", "ad", "cvm", "lillie", "pearson", "sf")
            pow <- apply(pvals, 2, function(x) {
                sum(x <= 0.05, na.rm = TRUE) / length(x[! is.na(x)]) * 100
                })
            val <- rbind(val, c(n = n, pow))
        }
    }
    val
}

distn <- rep(NA, 25)
distn[(0 : 4) * 5 + 1] <- c("N", "t-5", "L", "G", "W")

italicize <- function(tab, digit, ii, jj) {
    ## tab is the numerical part of the
    n <- length(ii)
    stopifnot(n == length(jj))
    tab.num <- round(as.matrix(tab), digit)
    tab.char <- format(tab.num)
    for (k in 1 : n) {
        tab.char[ii[k], jj[k]] <- paste0("{\\it ", tab.char[ii[k], jj[k]], "}")
    }
    tab.char[grep("NA", tab.char)] <- NA
    tab.char
}

ii1 <- rep(1 : 5, 6)
jj1 <- rep(1 : 6, each = 5)
ii <- rep(6 : 10, 4)
jj <- rep(7 : 10, each = 5)
iis <- c(ii1, ii, ii + 5, ii + 10, ii + 15)
jjs <- c(jj1, jj, jj + 4, jj + 8, jj + 12)

addtorow <- list(pos = list(5, 10, 15, 20),
                 command = rep("[1ex]\n", 4))

nobss <- c(100, 200, 300, 400, 500)
round(norm <- sumsim("norm", nobss), 1)
round(myt <- sumsim("myt", nobss), 1)
round(logis <- sumsim("logis", nobss), 1)
round(gamma <- sumsim("gamma", nobss), 1)
round(weibull <- sumsim("weibull", nobss), 1)

mult <- data.frame(distn, rbind(norm, myt, logis, gamma, weibull))

round(norm.pb <- sumsim("norm-pb", nobss), 1)
round(myt.pb <- sumsim("myt-pb", nobss), 1)
round(logis.pb <- sumsim("logis-pb", nobss), 1)
round(gamma.pb <- sumsim("gamma-pb", nobss), 1)
round(weibull.pb <- sumsim("weibull-pb", nobss), 1)

pb <- data.frame(distn, rbind(norm.pb, myt.pb, logis.pb, gamma.pb, weibull.pb))

mult.tab <- mult[, c("distn", "n", "shapiro", "jb", "cvm.norm", "cvma.norm",
                     "cvm.myt", "cvma.myt", "cvm.logis", "cvma.logis",
                     "cvm.gamma", "cvma.gamma", "cvm.weib", "cvma.weib")]

pb.tab <- pb[, c("distn", "n", "shapiro", "jb", "cvm.norm", "cvma.norm",
                 "cvm.myt", "cvma.myt", "cvm.logis", "cvma.logis",
                 "cvm.gamma", "cvma.gamma", "cvm.weib", "cvma.weib")]

## mult.xtab <- xtable(mult.tab, digits=c(0,0,0, rep(1, 12)))
## print(mult.xtab, include.rownames=FALSE)

## pb.xtab <- xtable(pb.tab, digits=c(0,0,0, rep(1, 12)))
## print(pb.xtab, include.rownames=FALSE)


tab <- cbind(mult.tab, pb.tab[,-c(1:4)])
tab <- tab[, c(1:4, c(rbind(5:14, 15:24)))]

## tabx <- xtable(tab, digits=c(0,0,0, rep(1,22)))
## print(tabx, include.rownames = FALSE)

tabx <- xtable(cbind(tab[, 1 : 2], italicize(tab[, - (1 : 2)], 1, iis, jjs)),
               digits = 0)

print(tabx, include.rownames = FALSE, add.to.row = addtorow,
      sanitize.text.function = function(x) x)


