
rollapply <- function(m, FUN, n=2, padding=c("-", "-", "-")) {
    ## Create and add padding that goes around the input matrix.
    padding <- matrix(rep(padding, each=n), ncol=ncol(m))
    dat <- rbind(padding, m, padding)

    ## Remove column names from the matrix as those will just confuse.
    colnames(dat) <- NULL

    ## Create a vector we can use as a template to get the surrounding
    ## rows from the data matrix.
    surr <- c(-n:n)[-(n+1)]

    ## Start with the first row, and since we added some padding to
    ## the `dat` matrix the first row is the row at the size of the
    ## padding + 1.
    i <- n+1

    ## Since we do not know how long the resulting vector from the
    ## function is just yet we need to run the function on the first
    ## row before we create the resulting matrix.
    head <- FUN(dat[i,], dat[surr+i,])

    ## We create the resulting matrix. It has the same amount of rows
    ## that the input matrix had, but it might have more or less
    ## columns. We can get the number of columns from the length of
    ## the result from applying the function to the first row and its
    ## surrounding rows.
    ret <- matrix(nrow=nrow(m), ncol=length(head))
    ret[1,] <- head

    ## For the rest of the rows we do the same thing as we did for the
    ## first row and add it to the correct place in the return matrix,
    ## except for the last n rows as those are padding and shouldn't
    ## be a part of the result matrix.
    for (i in (i+1):(nrow(dat)-n)) {
        ## Since the return matrix doesn't have the padding we also
        ## need to remove n from from the index.
        ret[i-n,] <- FUN(dat[i,], dat[surr+i,])
    }
    ret
}
