

##Generating potential outcomes
#potential outcome when instrument and treatment are 0
r_0_0 <- runif(100)*10
#Potential outcome when treatment is 0, but instrument is 1
r_0_1 <- r_0_0 #because of exclusion restriction
#Potential outcome when instrument and treatment are 1
r_1_1 <- r_0_0 + rnorm(100, mean=2.5)
#Potential outcome when treatment is 1 and instrument is 0
r_1_0 <- r_1_1

## Treatment: we need 2 treatment vectors, one for the cases where the instrument is 1, and the other for when it is 0
gamma <- rnorm(100)
t_0 <- ifelse((gamma)>.5,1,0)
#strong instrument
t_1 <- ifelse((gamma + rnorm(100,1.5,.5)) > .5, 1,0)

table(t_0, t_1)

#How many compliers? Always takers? Never takers? Defiers?

t_0[(t_1-t_0)==-1] <- 0 # remove defiers if there are any

## Let's make compliers different from the over all population
r_1_1[(t_1-t_0)==1] <- r_1_1[(t_1-t_0)==1] + rnorm(length(r_1_1[(t_1-t_0)==1]),2,1)

#Generate Instrument
z <- matrix(0,nrow=100)
z[sample(1:100,50)] <- 1

## Generate realized treatment and outcome vectors
t <- ifelse(z==1, t_1, t_0)
r <- ifelse(t==1, r_1_1, r_0_0)