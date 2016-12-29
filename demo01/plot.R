pdf("uniden.pdf", height = 3, width = 4, pointsize = 9)
par(mar = c(2.5, 2.5, 0.1, 0.1), mgp = c(1.5, 0.5, 0))
plot(c(6, 14), c(0, 0.45), type = "n",  xlab = "x", ylab = "density f(x)")
curve(dnorm(x, 10, 1), add = TRUE)
curve(dt((x - 10) / 0.856, df = 5) / 0.856, add = TRUE, lty = 2,
      col = "darkblue")
curve(dlogis(x, 10, 0.572), add = TRUE, lty = 3, col = "darkred")
curve(dgamma(x, shape = 98.671, rate = 9.866), add = TRUE, lty = 4,
      col="darkgreen")
curve(dweibull(x, shape = 10.618, scale = 10.452), add = TRUE, lty = 5,
      col="purple")
legend("topright", c("normal", "t-5", "logistic", "gamma", "weibull"),
       col = c("black", "darkblue", "darkred", "darkgreen", "purple"),
       lty = 1:5, cex = 0.75)
dev.off()
