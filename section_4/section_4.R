##########################################################################
# 231b Section 4. UC Berkeley, Spring 2015.
# GSI: Guadalupe Tuñón. guadalupe.tunon@berkeley.edu
# Proposed section code
##########################################################################
#
# 1. Fitting regression SEs and t-test
#
# 2. Monte Carlo simulations: unbiasedness and omitted variable bias
#
##########################################################################

rm(list=ls())

# Libraries
library(MASS)

# set wd
# setwd("~/Dropbox/231B_Spring2015/231b_section_materials_2015/section_4")

# Let's generate some data following the multivariate regression model
x1 <- runif(80, -50, 50)
x2 <- rnorm(80, 5, 20)
epsilon <- rnorm(80, 0, 16)
Y <- 14 + 8 * x1 + 3 * x2 + epsilon
# Where is $\sigma$ here?
# What parts of this code refer to each of the assumptions in the model?

# 1. Fitting regression SEs and t-test.

# a. Using matrix manipulation, calculate the regression residuals. Show the average of the residuals is zero and
# find $\hat{sigma}$ based on sum of squared residuals, divided by $n-p$.

# The first thing we will need here is to build the matrix for X
X <- cbind(1, x1, x2)

# How do we get the residuals now?
# We know $e=Y-\hat{Y}=Y-X\hat{\beta}$. So we need to calculate $\hat{\beta}$ first. We did this last section:

betas <- solve(t(X)%*%X) %*% t(X)%*%Y

e <- Y - X %*% betas

round(mean(e), 4)

hat_sigma2 <- sum(t(e)%*%e) / (nrow(X)-length(betas))
hat_sigma <- sqrt(hat_sigma2)

hat_sigma


# b. Plot the residuals against $X$, and against the fitted values $\hat{Y}$.  

par(mfrow=c(1,3))
plot(e, x1, pch=16, col="grey30")
plot(e, x2, pch=16, col="grey30")
plot(e, X %*% betas, pch=16, col="grey30")

# For the former, should you see a pattern, and why or why not? For the latter, do you see a pattern?  
# Would a pattern be evidence against the modeling assumption (e.g., constant variance \sigma^2?  

# c. Find estimated standard errors from $\hat{sigma^2}[X'X}^{-1}$.

var_hat_beta <- hat_sigma2 * solve((t(X)%*%X)) # Why do we use * instead of %*% here?

se_hat_beta <- sqrt(diag(var_hat_beta))
se_hat_beta

# d. Using the t-test function you wrote for the difference of means, conduct t-test based on $\hat{\beta}/\hat{SE}$. 

t_stats <- betas/se_hat_beta
t_stats

for (i in 1:3){
  
  if (t_stats[i]>0){p_val <- pt(t_stats[i], df=(nrow(X)-length(betas)), ncp=0, lower.tail = F) + 
                      pt(-t_stats[i], df=(nrow(X)-length(betas)), ncp=0, lower.tail = T)}
  
  if (t_stats[i]<0){p_val <- pt(t_stats[i], df=(nrow(X)-length(betas)), ncp=0, lower.tail = T) + 
                      pt(-t_stats[i], df=(nrow(X)-length(betas)), ncp=0, lower.tail = F)}
  
  print(p_val)
}

# are these one or two-tailed tests?


# e. Let's redo the exercise, now with \epsilon distributed uniform with mean 0 
epsilon <- runif(80, -10, 10)
Y <- 14 + 8 * x1 + 3 * x2 + epsilon

X <- cbind(1, x1, x2)

# How do we get the residuals now?
# We know $e=Y-\hat{Y}=Y-X\hat{\beta}$. So we need to calculate $\hat{\beta}$ first. We did this last section:

betas <- solve(t(X)%*%X) %*% t(X)%*%Y

e <- Y - X %*% betas

round(mean(e), 4)

hat_sigma2 <- sum(t(e)%*%e) / (nrow(X)-length(betas))
hat_sigma <- sqrt(hat_sigma2)

hat_sigma

par(mfrow=c(1,3))
plot(e, x1, pch=16, col="grey30")
plot(e, x2, pch=16, col="grey30")
plot(e, X %*% betas, pch=16, col="grey30")

var_hat_beta <- hat_sigma2 * solve((t(X)%*%X)) # Why do we use * instead of %*% here?

se_hat_beta <- sqrt(diag(var_hat_beta))
se_hat_beta

t_stats <- betas/se_hat_beta
t_stats

for (i in 1:3){
  
  if (t_stats[i]>0){p_val <- pt(t_stats[i], df=(nrow(X)-length(betas)), ncp=0, lower.tail = F) + 
                      pt(-t_stats[i], df=(nrow(X)-length(betas)), ncp=0, lower.tail = T)}
  
  if (t_stats[i]<0){p_val <- pt(t_stats[i], df=(nrow(X)-length(betas)), ncp=0, lower.tail = T) + 
                      pt(-t_stats[i], df=(nrow(X)-length(betas)), ncp=0, lower.tail = F)}
  
  print(p_val)
}


# 2. Monte Carlo simulations: unbiasedness of \hat{\beta} and omitted variable bias

# Now we will write a function that takes the following arguments
# and returns the regression coefficients
# n = sample size
# muX = the true means of the covariates
# sigmaX = the true variance-covariance matrix
# betas = true paramenters of the model
# sigmae = true stadard deviation of the epsilon
# omitt = indicator--should we omitt the third variable in the regression?
ovb_sim <- function(n=100, muX=c(0,0,0), sigmaX, betas, sigmae, omitt=FALSE){
  
  # Draw the simulated covariates from their true
  # multivariate Normal distribution
  X <- mvrnorm(n, muX, sigmaX)
  
  # Create the simulated y by
  # adding together the systematic and stochastic
  # components, according to the true model
  # note that we are adding column of 1s for the intercept
  y <- cbind(1, X) %*% betas + rnorm(n)*sigmae
  
  # Run a regression of the simulated y on the simulated X 
  # with the option of omitting x2 or not
  if (omitt==FALSE) res <- lm(y~X) # complete model
  if (omitt==TRUE) res <- lm(y~X[,c(1,2)]) # omitting the third variable
  
  # Extract the estimated coefficients
  coefs <- res$coefficients
  
  # Return the coefficients
  return(coefs)
}


# We will look at three different cases: 
# 1. model where the three independent variables belong in the real model 
# and they are correlated -- and we specify the right regression
# 2. model where the three independent variables belong in the real model 
# and they are correlated -- and we omitt x3
# 3. model where the three independent variables belong in the real model 
# but they are not correlated -- and we omitt x3

# First we will need to create the variance-covariance matrices.
# note that we can use the same one for cases 1 and 2
# What is the key thing to consider when we build these matrices?

# True variance-covariance matrices
# Here the off-diagonal elements are zero, so they variables are not correlated
# with each other
SigmaX_without_cor <- matrix(c(  1,  0,  0,
                                 0,  1,  0,
                                 0,  0,  1 ), nrow=3, ncol=3, byrow=TRUE)
# In this one, the off-diagonal here they are non-zero and thus the 
# variables are correlated
SigmaX_with_cor <- matrix(c(  1,  .5,  .5,
                              .5,   1,  .5,
                              .5,  .5,   1 ), nrow=3, ncol=3, byrow=TRUE)


# For both models, let's also define the true stadard deviation of the error term
sigma <- sqrt(2)

# 1. model where the three independent variables belong in the real model 
# and they are correlated -- and we specify the right regression

reg1 <- replicate(10000, ovb_sim(n=100, muX=c(0,0,0), sigmaX=SigmaX_with_cor, 
                                 betas=c(1,2,4,3), sigmae=sigma, omitt=FALSE))

# 2. model where the three independent variables belong in the real model 
# and they are correlated -- and we omitt x3

reg2 <- replicate(10000, ovb_sim(n=100, muX=c(0,0,0), sigmaX=SigmaX_with_cor, 
                                 betas=c(1,2,4,3), sigmae=sigma, omitt=TRUE))

# 3. model where the three independent variables belong in the real model 
# but they are not correlated -- and we omitt x3

reg3 <- replicate(10000, ovb_sim(n=100, muX=c(0,0,0), sigmaX=SigmaX_without_cor, 
                                 betas=c(1,2,4,3), sigmae=sigma, omitt=TRUE))

dim(reg3)


# RESULTS #######################################
betas # True parameters
# Average OLS estimate across 10000 simulation runs: 
apply(reg1, 1, mean) # correlated covariates but complete model
apply(reg2, 1, mean) # correlated covariates and omitted variable
apply(reg3, 1, mean) # non-correlated covariates and omitted variable


# Sourcing functions
source("plot_function.R")
plotfunc(coefs=reg1, betas=c(1,2,4,3), omitted=FALSE, 
         maintitle="Complete model")
plotfunc(coefs=reg2, betas=c(1,2,4,3), omitted=TRUE, 
         maintitle="Omitted variable (positive correlation)")
plotfunc(coefs=reg3, betas=c(1,2,4,3), omitted=TRUE, 
         maintitle="Omitted variable (zero correlation)")












