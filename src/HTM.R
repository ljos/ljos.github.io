
png(filename="sinusoid.png")
x <- seq(0, 2, by = 0.01)                                               
y <- round(sin(2 * pi * (x - 1/4)), 2)                                  

plot(x, y, xlab = 'time', ylab = 'value', type='l')
dev.off()

buckets <- unique(y)                                              
w <- 3                                                                  
bits <- length(buckets) + w - 1

to.vector <- function(value) {
    result <- rep(0, length(buckets))
    n <- match(value, buckets)
    for (i in 0:(w-1)) {
        result[i+n] <- 1
    }
    return(result)
}

htm <- list(                                                         
  cells      = 16,
  columns    = 10,
  permanence = 0.3,
  overlap    = 10,
  activity   = 0.1)

htm$synapses <- round(                                            
  matrix(
    data = runif(htm$columns*bits),
    nrow = bits,
    ncol = htm$columns))
htm$synapses <- htm$synapses * runif(bits*htm$columns,
                                     htm$permanence-0.1,
                                     htm$permanence+0.1)

htm$boost <- rep(1, htm$columns)

overlap <- function(htm) {
    ov <- ifelse(htm$synapses > htm$permanence, 1, 0)
    ov <- apply(ov, 2, sum)
    ov <- ifelse(ov < htm$overlap, 0, ov)
    return(ov * htm$boost)
}


