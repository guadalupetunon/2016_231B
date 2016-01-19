##############################################################
# 231b Section 1. UC Berkeley, Spring 2015.
# GSI: Guadalupe Tuñón. guadalupe.tunon@berkeley.edu
# Proposed section code
##############################################################
#
# 1. Introduction to simulations in R
# The birthday problem
#
# 2. Sampling simulations (one sample): 
# a. Sample mean as unbiased estimator of the population mean.
# b. Variance of the sample mean as m gets closer to N.
#
# 3. Functions: 
# Function for the difference of means
#
##############################################################

rm(list=ls())

# 1. The birthday problem (Feller 1957) 

# Simulating birthdays for 25 people
birthdays <- sample(1:365, 25, replace=T)
birthdays

# Finding the number of birthday matches among 25 people
X <- 25 - length(unique(birthdays))

# Here we have simulated the situation for one room with 25 people, where
# there is
X
#shared birthday(s)

# Using a loop to simulate X for many rooms with 25 people: 
# If we repeat this process a very large number of times, we obtain many 
# realizations of the random variable X, and thus a good idea of the distribution 
# of X. 
# Counting the proportion of rooms with X = 0, we get the approximate 
# probability of no match P(X = 0) or match P(X>0).
# Taking the average of these realizations of X, we get a good approximation to E(X).

X <- NA # Creating placeholder vector
r <- 10000 # We will simulate 10,000 rooms

for (i in 1:r){ 
  
  birthdays <- sample(1:365, 25, replace=T)
  X[i] <- 25 - length(unique(birthdays))
  
}

# Simulated probability of at least one matching birthday. 
mean(X!=0)  # Very close to the combinatorial solution which is 0.5687

# Simulated E(X): the average number of matches per room simulates
mean(X) # This result is not easily obtained by combinatorial methods.

##############################################################

# 2.a Sample mean as an unbiased estimator of the population mean

# First we will need to "create" a population, a box of tickets
population <- c(4,5,7,12,7,8,9,-3,5,8,9,3,2,3,4,6,10,4,6,7,8,9,2)

N <- length(population) # number of observations in the population
N

pop_mean <- mean(population) # population mean
pop_mean 

pop_sd <- sd(population) # population standard deviation
pop_sd

# We will draw several random samples of 8 observation without replacement 
m <- 8

s1 <- sample(population, size=m, replace = FALSE)
s1

s2 <- sample(population, size=m, replace = FALSE)
s2

s3 <- sample(population, size=m, replace = FALSE)
s3

s4 <- sample(population, size=m, replace = FALSE)
s4

samples <- cbind(s1, s2, s3, s4)

# Remember the population mean 
pop_mean 
# And the means of the samples 
apply(samples, MARGIN=2, FUN=mean) 
# By chance each given sample mean may be a little higher or lower than the 
# population mean

# We will use a simulation to show that the sample mean is an unbiased estimator
# of the population mean

# Simulating the sampling process 10000 times
sample_mean <- NA
m <- 8

for (i in 1:10000){
  
  sample <- sample(population, size=m, replace = FALSE)
  sample_mean[i] <- mean(sample)
  
}

par(mfrow=c(1,1))
plot(density(sample_mean), col="blue", lwd=3,
     main="Distribution of sample means")
abline(v=pop_mean, col="red", lwd=2)


##############################################################

# 2b. Variance of the sample mean as m gets closer to N.

plot(density(sample_mean), col="blue", ylim=c(0,1.6),
     main="Distribution of sample means", lwd=3)
abline(v=pop_mean, col="red", lwd=3)

rep <- 10000

for (m in 9:20){
  sample_mean <- NA
  
  for (i in 1:rep){
    sample <- sample(population, size=m, replace = FALSE)
    sample_mean[i] <- mean(sample)
  }
  lines(density(sample_mean), lwd=3,
        col=paste0("grey",140-(7*m)))
}

##############################################################
# 3. Function for the difference of means

diff_means <- function(y, x){ 
  
  # Calculating difference in means
  mean1 <- mean(y[x==1], na.rm=T)
  mean0 <- mean(y[x==0], na.rm=T)
  diff <- mean1 - mean0
  
  # Calculating number of observations
  N <- length(na.omit(y))
  
  # Preparing output
  res <- c(mean1, mean0, diff, N)
  names(res) <- c("Mean 1", "Mean 0", "Difference", "N")
  
  return(c(res))
}

# To try our function, we will use the small dataset in Gerber & Green (2012)

gg_data <- as.data.frame(cbind(c(10,15,20,20,10,15,15), 
                               c(15,15,30,15,20,15,30)))
names(gg_data) <- c("Y_i0", "Y_i1")

# We will need to "create" a treatment vector
gg_data$treat <- sample(c(0,1), 7, replace=T)
gg_data$treat

# and a column with the "observed" outcomes
gg_data$observed <- ifelse(gg_data$treat==1, gg_data$Y_i1, gg_data$Y_i0)

with(gg_data, diff_means(observed, treat))

mean(gg_data$Y_i1[gg_data$treat==1])
mean(gg_data$Y_i0[gg_data$treat==0])

stopifnot((mean(gg_data$Y_i1[gg_data$treat==1])-mean(gg_data$Y_i0[gg_data$treat==0]))==
             with(gg_data, diff_means(observed, treat))[3])



