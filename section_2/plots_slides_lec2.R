##############################################################
# 231b Section 2. UC Berkeley, Spring 2015.
# GSI: Guadalupe Tuñón. guadalupe.tunon@berkeley.edu
# Proposed section code
##############################################################
#
# 1. Review
# 2. The bootstrap 
# (check variation of bootstrap as function of nr of bootstrap 
# replicates).
# 3. Sampling from the box with and without replacement 
# (variance and correction factor)
#
##############################################################

rm(list=ls())

# Loading needed libraries
library(foreign) # to import csv
library(ggplot2) # for plots using ggplot


# 2. The bootstrap


# 1. Dunning & Harrison (2010) ############################################

# loading the data
setwd("~/Dropbox/231B_Spring2015/Replication files/Dunning_and_Harrison")
cc_data <- read.csv("Cross_Cutting_APSR_ReplicationData.csv")

# indicating directory to save output
setwd("~/Dropbox/231B_Spring2015/231b Lecture_Notes_2015")
# save.figs="yes" # output plots saved in lecture notes folder
save.figs="no" # outputs figs in R viewer



# head and variable names
head(cc_data)
names(cc_data)

# treat_assign takes on a value 1 through 6 and denotes the treatment condition to 
# which the respondent was assigned, as follows:
# 1 -- Same ethnicity, joking cousin
# 2 -- Same ethnicity, not joking cousin
# 3 -- Different ethnicity, joking cousin
# 4 -- Different ethnicity, not joking cousin
# 5 -- No last name given for candidate
# 6 -- Candidate and subject have same last name (and thus ethnicity)

# number of observations by treatment group
table(cc_data$treat_assign)
summary(cc_data$treat_assign)

# vote_prefer is the main outcome variable
# "On a scale from 1 to 7, how much does this speech make you want to vote for (name of politician)?"
summary(cc_data$vote_prefer)

# vecu_ailleurs is a covariate, equal to 1 if the respondent has lived outside of Bamako and 
# equal to 0 otherwise
summary(cc_data$vecu_ailleurs)

# The bootstrap
# To investigate the properties of different sampling procedures, let's use the bootstrap: 

# (1) Take the sample values as the population; 
# (2) Draw a sample from this population (box) with replacement, using the sampling 
# procedure we want to analyze; save the sample statistics (e.g. the mean). 
# This is a "bootstrap replicate."
# (3) Repeat step (2) many times (say, 10,000 times).  
# (4) Plot the distribution of the saved statistics across all the bootstrap replicates.
# This gives us a good glimpse of the sampling distribution of the statistic of interest.

# For this problem, we are going to use the sample values for the co-ethnic cousin 
# (treatment) condition (treat_assign==1)
box <- cc_data$vote_prefer[cc_data$treat_assign==1] 
box <- as.data.frame(box)

# Step (1): let's look at what's in the box, the "bootstrap population". 
# For this, we will plot the empirical distribution of responses in the treatment group
if (save.figs=="yes") pdf("hist_cousinage_treated1_box_R.pdf",width=6, height=4) #################
m <- ggplot(box, aes(x=box))
m + geom_histogram(aes(y = ..density..), alpha=.25, binwidth=1) + 
  # We will overlay a blue line showing the normal distribution with mean equal to the mean
  # of the box and sd equal to the sd of the box
  stat_function(fun=dnorm, args=list(mean=mean(box$box), sd=sd(box$box)), 
                col="blue", size=.8) +
  # and a red line showing the mean of the box
  geom_vline(x=mean(box$box), col="red", size=1.25) +
  theme_bw() + 
  labs(title="",  x="Respondent wants to vote for candidate (1-7 scale)",
       y="Density")
if (save.figs=="yes") dev.off()


# Now, we get to the bootstrap
# We first need to define the number of units we will draw from the box (with replacement). 
# For the first example, let's take N=5
N <- 5

# If we wanted to do step (2) once, we would sample from the box N units with replacement
boot_sample <- sample(box$box, N, replace=T) 
# And then take the statistic of interest for this bootstrap sample, here the mean. 
mean(boot_sample)

# But we want to do this many times--- 10,000 times!
#So we write a for loop that repeats this sampling procedure 10000 times:

boot_reps <- 10000 # number of bootstrap replicates we will repeat step (2) for
boot_mean <- NA # placeholder vector for the results

for (i in 1:boot_reps){
  boot_sample <- sample(box$box, N, replace=T) 
  boot_mean[i] <- mean(boot_sample)
}

# Now we plot the results
m <- ggplot(as.data.frame(boot_mean), aes(x=boot_mean))
# First we plot a histogram with the results
m + geom_histogram(aes(y = ..density..), alpha=.5) + 
  # and overlay a line with the density of a normal distribution with mean equal to the mean
  # of the bootstrap means and sd equal to the sd of the bootstrap means.
  stat_function(fun=dnorm, 
                args=list(mean=mean(boot_mean), sd=sd(boot_mean)), col="blue", size=1) +
  # and we add a vertical line for the mean of the box
  geom_vline(x=mean(box$box), col="red", size=1) + theme_bw()


# We will now repeat this procedure, varying the size of the bootstrap sample, several times.
# We can write a function which does the bootstraps, and plots a histogram for their mean

# Our function will require the data, the number of bootstrap replicates, the 
# number of observations to be sampled from the box in each replicate and the 
# binwidth to be used for the histogram. 
# We will sample N units without replacement and get the mean for that sample
bootstrap_mean <- function(data, replicates=10000, N, bin, title="", 
                           xlab="", ylab="", xmax, xmin){
  boot_mean <- NA #plaaceholder vector
  for (i in 1:replicates){
    # we sample N units from the box with replacement
    boot_sample <- sample(data, N, replace=T)
    # and save their mean
    boot_mean[i] <- mean(boot_sample)
  }
  
  m <- ggplot(as.data.frame(boot_mean), aes(x=boot_mean))
  # First we plot a histogram with the results
  m + geom_histogram(aes(y = ..density..), alpha=.5, binwidth=bin) + 
    # and overlay a line with the density of a normal distribution with mean equal to the mean
    # of the bootstrap means and sd equal to the sd of the bootstrap means.
    stat_function(fun=dnorm, 
                  args=list(mean=mean(boot_mean), sd=sd(boot_mean)), col="blue", size=1) +
    # and we add a vertical line for the mean of the box
    geom_vline(x=mean(box$box), col="red", size=1) +
    # limits for x axis
    scale_x_continuous(limits = c(xmin, xmax)) +
    # and labels
    labs(title=title,  x=xlab, y=ylab) + theme_bw()
}

# Now we will run the bootstrap varying N 

# N = 136
if (save.figs=="yes") pdf("hist_cousinage_bootstrapN_136_R.pdf", width=6, height=4) #################
bootstrap_mean(data=box$box, replicates=10000, N=136, bin=.025, 
               # title="N=136", 
               xmin=1, xmax=7,
               xlab="Mean - Respondent wants to vote for candidate (1-7 scale)", ylab="Density")
if (save.figs=="yes") dev.off()

# N = 5
if (save.figs=="yes") pdf("bootstrap5_R.pdf", width=6, height=4) #################
bootstrap_mean(data=box$box, replicates=10000, N=5, bin=.035, 
               # title="N=5", 
               xmin=1, xmax=7,
               xlab="Mean - Respondent wants to vote for candidate (1-7 scale)", ylab="Density")
if (save.figs=="yes") dev.off()

# N = 25
if (save.figs=="yes") pdf("bootstrap25_R.pdf", width=6, height=4) #################
bootstrap_mean(data=box$box, replicates=10000, N=25, bin=.035, 
               # title="N=25", 
               xmin=1, xmax=7,
               xlab="Mean - Respondent wants to vote for candidate (1-7 scale)", ylab="Density")
if (save.figs=="yes") dev.off()

# N = 100
if (save.figs=="yes") pdf("bootstrap100_R.pdf", width=6, height=4) #################
bootstrap_mean(data=box$box, replicates=10000, N=100, bin=.035,  
               # title="N=100",
               xmin=1, xmax=7,
               xlab="Mean - Respondent wants to vote for candidate (1-7 scale)", ylab="Density")
if (save.figs=="yes") dev.off()



############ vecu_ailleurs (a non-normal box) #####
# New box
box <- cc_data$vecu_ailleurs[cc_data$treat_assign==1]
box <- as.data.frame(box)

# Bootstrap population: Empirical distribution of responses in the treatment group
if (save.figs=="yes") pdf("hist_vecuailleurs_R.pdf", width=6, height=4) #################
m <- ggplot(box, aes(x=box))
m + 
  geom_bar(aes(y = 100 * (..count..)/sum(..count..)), binwidth=1, alpha=.5) + 
  # We will overlay a red line showing the mean of the box
  geom_vline(x=mean(box$box), col="red", size=1.5) +
  labs(title="",  x="Subject has lived outside of Bamako",
       y="Percent") + theme_bw()
if (save.figs=="yes") dev.off()

# Now we will run the bootstrap varying N, sampling from the new box
# N = 5
if (save.figs=="yes") pdf("bootstrap5_nonnormal_R.pdf", width=6, height=4) #################
bootstrap_mean(data=box$box, replicates=10000, N=5, bin=.02, 
               # title="N=5", 
               xmin=0, xmax=1.5,
               xlab="Mean - Subject has lived outside of Bamako", ylab="Density")
if (save.figs=="yes") dev.off()

# N = 25
if (save.figs=="yes") pdf("bootstrap25_nonnormal_R.pdf", width=6, height=4) #################
bootstrap_mean(data=box$box, replicates=10000, N=25, bin=.02, 
               # title="N=25", 
               xmin=0, xmax=1.5,
               xlab="Mean - Subject has lived outside of Bamako", ylab="Density")
if (save.figs=="yes") dev.off()

# N = 100
if (save.figs=="yes") pdf("bootstrap100_nonnormal_R.pdf", width=6, height=4) #################
bootstrap_mean(data=box$box, replicates=10000, N=100, bin=.02, 
               # title="N=100", 
               xmin=0, xmax=1.5,
               xlab="Mean - Subject has lived outside of Bamako", ylab="Density")
if (save.figs=="yes") dev.off()


# Hypothesis testing
# Gerber and Green (2012); Chattopadhyay and Duflo (2004) ###########

# the data
gg_data <- as.data.frame(cbind(c(10,15,20,20,10,15,15), 
                               c(15,15,30,15,20,15,30)))
names(gg_data) <- c("Y_i0", "Y_i1")

# generating empty dataframe to put the results
ate <- as.data.frame(matrix(NA, 10000, 2))
names(ate) <- c("estimated_ate", "se_ate")

# sampling
for (i in 1:10000){
  gg_data$treat <- 0
  gg_data$treat[sample(1:7,2,replace=F)]  <- 1
  
  treat_mean <- mean(gg_data$Y_i1[gg_data$treat==1])
  treat_var <- var(gg_data$Y_i1[gg_data$treat==1])
  
  control_mean <- mean(gg_data$Y_i0[gg_data$treat==0])
  control_var <- var(gg_data$Y_i0[gg_data$treat==0])
  
  ate[i,1] <- treat_mean - control_mean
  ate[i,2] <- sqrt(treat_var/2 + control_var/5) 
}

head(ate)

if (save.figs=="yes") pdf("hist_estimated_ate_R.pdf", width=6, height=4) #################
m <- ggplot(ate, aes(x=estimated_ate))
m + 
  geom_bar(aes(y = 100 * (..count..)/sum(..count..)), binwidth=.5, alpha=.5) + 
  # geom_histogram(aes(y = ..density..)) +
  geom_vline(x=mean(ate$estimated_ate), col="red", size=1.25) +
  theme_bw() +
  xlab("Estimated ATE") +
  ylab("Percent")
if (save.figs=="yes") dev.off()

if (save.figs=="yes") pdf("hist_estimated_se_R.pdf", width=6, height=4) #################
m <- ggplot(ate, aes(x=se_ate))
m + 
  geom_bar(aes(y = 100 * (..count..)/sum(..count..)), binwidth=.2, alpha=.5) + 
  # geom_histogram(aes(y = ..density..)) +
  geom_vline(x=mean(ate$se_ate), col="red", size=1.25) +
  theme_bw() +
  xlab("estimated_SE") +
  ylab("Percent")
if (save.figs=="yes") dev.off()



