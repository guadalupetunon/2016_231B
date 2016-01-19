# t-test with complete output
# df for two sample t test with unequal variances
# function written by Guadalupe Tuñón
###################################################

ttest <- function(y, x, two.tailed=TRUE){ 
  
  # Calculating difference in means
  mean1 <- mean(y[x==1], na.rm=T)
  mean0 <- mean(y[x==0], na.rm=T)
  diff <- mean1 - mean0
  
  # Calculating SE of the difference
  N1 <- length(na.omit(y[x==1]))
  N0 <- length(na.omit(y[x==0]))
  var1 <- var(y[x==1],na.rm=T)
  var0 <- var(y[x==0],na.rm=T)
  varN1 <- var1/N1
  varN0 <- var0/N0
  se.diff <- sqrt(varN1 + varN0)
  
  # T-statistic
  t <- diff/se.diff
  
  # Degrees of freedom
  df.num <- ((varN1 + varN0)^2)
  df.den <- (varN1^2)/(N1-1) + (varN0^2)/(N0-1)
  df <- df.num/df.den
  
  # P-value
  if(two.tailed==TRUE){
    p <- 2 * pt(abs(t), df, lower.tail=F)
  }
  
  if(two.tailed==FALSE){
    p <- pt(t, df, lower.tail=F)
  }
  
  # Preparing output
  res <- c(mean1, mean0, diff, se.diff, 
           t, (N1+N0), df, p)
  names(res) <- c("Mean 1", "Mean 0", "Difference", 
                  "SE_Diff","t-stat", "N", "df", "p-value")
  
  return(c(res))
}