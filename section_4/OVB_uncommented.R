
# 3. Monte Carlo simulations: unbiasedness and omitted variable bias

ovb_sim <- function(n=100, muX=c(0,0,0), sigmaX, betas, sigmae, omitt=FALSE){
  
  X <- mvrnorm(n, muX, sigmaX)
  
  y <- cbind(1, X) %*% betas + rnorm(n)*sigmae
  

  if (omitt==FALSE) res <- lm(y~X) 
  if (omitt==TRUE) res <- lm(y~X[,c(1,2)]) 
  

  coefs <- res$coefficients
  

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
# What is the key thing to consider when we build these matrices?

# True variance-covariance matrices

SigmaX_without_cor <- matrix(c(  1,  0,  0,
                                 0,  1,  0,
                                 0,  0,  1 ), nrow=3, ncol=3, byrow=TRUE)

SigmaX_with_cor <- matrix(c(  1,  .5,  .5,
                              .5,   1,  .5,
                              .5,  .5,   1 ), nrow=3, ncol=3, byrow=TRUE)


# For both models, let's also define the true stadard deviation of the error term
sigma <- sqrt(2)

# 1. 

reg1 <- replicate(10000, ovb_sim(n=100, muX=c(0,0,0), sigmaX=SigmaX_with_cor, 
                                 betas=c(1,2,4,3), sigmae=sigma, omitt=FALSE))

# 2. 

reg2 <- replicate(10000, ovb_sim(n=100, muX=c(0,0,0), sigmaX=SigmaX_with_cor, 
                                 betas=c(1,2,4,3), sigmae=sigma, omitt=TRUE))

# 3. 

reg3 <- replicate(10000, ovb_sim(n=100, muX=c(0,0,0), sigmaX=SigmaX_without_cor, 
                                 betas=c(1,2,4,3), sigmae=sigma, omitt=TRUE))


# RESULTS
betas 
apply(reg1, 1, mean) 
apply(reg2, 1, mean) 
apply(reg3, 1, mean) 





