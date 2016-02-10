

# 2. Monte Carlo simulations

Fix X. For each bootstrap replicate:
  -- Sample i.i.d. \epsilon, use that to construct Y.  You have to pick a value for \sigma, could be the 
value of \hat{\sigma} from part 1a.  Or could be something close but not identical to  \hat{\sigma}.  
Don't know if it is helpful or confusing to equat sigma^2 and \hat{sigma}^2 by construction.
-- fit \hat{\beta} \hat{sigma}^2 and var/cov, matrix of \hat{beta}, and find t statistic

Now,

a. plot the distribution of \hat{\beta}.  Is \hat{{\beta} unbiased?  What is the standard deviation 
of the sampling distribution?  How does it compare to the estimated standard error in part 1b? What 
is the theoretical standard error of \beta{\hat} in this simulation (i.e. based on \sigma^{2}[X'X}^{-1}?

b. plot the distribution of the t.  How close is the theoretical distribution of t to normal?  
Superimpose a normal curve on the plot (with same mean as t)




# Creating the independent variables (why am I creating these outside of the dgp function?)

x1 <- runif(80, -50, 50)
x2 <- rnorm(80, 5, 20)


dgp <- function(beta0, beta1, beta2, sigma2, x1, x2){
  
  epsilon <- rnorm(80, 0, sigma2)
  
  y <- beta0 + beta1 * x1 + beta2 * x2 + epsilon
  
  return(y)
  
}

# Function that generates the y variable and gets the regression estimates
ols_reg <- function(x1=x1, x2=x2, beta0=14, beta1=8, beta2=3, sigma2=15, retrieve="betas"){
  
  y <- dgp(beta0=beta0, beta1=beta1, beta2=beta2, sigma2=sigma2, x1=x1, x2=x2)
  
  if (retrieve=="betas") out <- summary(lm(y ~ x1 + x2))$coefficients[,1]
  if (retrieve=="ses") out <- summary(lm(y ~ x1 + x2))$coefficients[,2]
  
  return(out)
}

ols_reg(x1=x1, x2=x2)


rep_estimates <- replicate(10000, ols_reg(x1=x1, x2=x2, retrieve="betas"))
rep_ses <- replicate(10000, ols_reg(x1=x1, x2=x2, retrieve="ses"))


par(mfrow=c(1,3))
beta0=14; beta1=8; beta2=3
plot(density(rep_estimates[1,]), col="slateblue", lwd=4, main="Simulated distribution of beta0 hat")
abline(v=beta0, col="darkorange", lwd=3)
plot(density(rep_estimates[2,]), col="slateblue", lwd=4, main="Simulated distribution of beta1 hat")
abline(v=beta1, col="darkorange", lwd=3)
plot(density(rep_estimates[3,]), col="slateblue", lwd=4, main="Simulated distribution of beta2 hat")
abline(v=beta2, col="darkorange", lwd=3)
