# Stat 238a/538a  Fall, 2012  Joe Chang
#
# You can use this file to help yourself become familiar with R.
# You can open it in Notepad, or any text editor, or even MS Word.
#
# Copy each line -- actually each group of lines, up to the next blank 
# line -- and paste into your R "console" window and see the results!
# If R seems to sit there waiting for more without showing you 
# the usual prompt "> ", you may need to hit "Enter".
#
# In each case you should think about what R gives you; each line 
# should be telling you something about R, and how you can use it.
#
# Please experiment by making changing in the commands and re-running 
# them as often as possible.  It's painless, a good way to learn    
# about R, and good clean fun.  It's even more painless because 
# you can use your "up arrow" key to recall the previous command, 
# then make whatever change you like, then hit enter to see
# the effect of your change.
#
# After a "#" character, the rest of the line is a comment,
# ignored by R, so you don't have to worry about pasting those
# and causing an error or whatever.
2+3

2*3

2^10

exp(3.0)

print("hello world")

# assigning a variable. ( Some people use "<-" instead of "=" )
x = 9+3

x^2

# Use "c" as follows to create a vector:
y = c(3,7,5,1,2,3,2,5,5)

# We can extract elements of the vector by using square brackets:
y+10

y[2]

2:4

y[2:4]

# We can use various built in functions on vectors.
# For example, "length" returns the number of components in the vector,
# and "table" gives a list of the elements in the
# vector together with their frequencies.
length(y)

table(y)

mean(y)

prod(y)  # <-- Product of elements of y

# Create a vector of 12 random numbers drawn from a uniform distribution 
# over the interval between 0 and 1:
z = runif(12)

z

# We can see which of these is less than 0.5 with the expression "z < 0.5"
z < 0.5

# R identifies "True" with "1" and "False" with "0":
as.numeric(z < 0.5)

# Now let x be a vector of 100 random draws from a "Normal" distribution:
x=rnorm(100)

x

hist(x)

y=rnorm(100)

plot(x,y)

?plot

plot(x,y,type="l") #just for fun

# And you can go back to the R Help on "plot", 
# scroll down to the "examples" section, and copy 
# and paste some of the commands from there!
v = sample(1:10,100,replace=T)

v

table(v)

####################################
# numerical calculations for birthday problem:
####################################
k=40

top = seq(365,length=k,by=-1)

bottom = rep(365,k)

top

bottom

top/bottom

prod(top/bottom)  # <-- this is the prob of NO birthday match

1 - prod(top/bottom)  # <-- this is the prob of having a birthday match

# Let's make a function out of what we just did:

# Paste the following 5 lines as a unit:
bday = function(k){
  top = seq(365,length=k,by=-1)
  bottom = rep(365,k)
  return(1-prod(top/bottom))
} 

bday(40)

bday(22)

bday(23)

####################################
# Loops
####################################
# Remember young Carl Friedrich Gauss?
s = 0
for(i in 1:100){
  s = s+i
}
s

# Sometimes you can do the same thing without a loop:
sum(1:100)

# You can have more commands in the body of the loop:
s = 0
for(i in 1:100){
  s = s+i
  cat("When i = ", i, ", s = ",s, "\n",sep="") # <-- "cat" prints things
}

s = 0
for(i in 1:100){
  s = s+i
  cat("When i = ", i, ", s = ",s, "\n",sep="")
  remainder10 = (i %% 10)
  tens = i/10
  if(remainder10 == 0)cat("I'm getting", rep("really", tens),"tired\n")
}


####################################
# A Monte Carlo simulation experiment to approximate bday probabilities
####################################

# Here is how you can do random sampling, with and without replacement:
#   (The default is without replacement, unless you specify otherwise)
?sample  # <-- to get the relevant help page

sample(10,5)

sample(10, 10)

sample(10, 11)  # <-- should give an error!

y = sample(10, 20, replace = T)

y

table(y)

# Now to start the birthday simulation.
# First do it just once, then put a loop around it to do it as
# many times as we want.
k = 40

bdays = sample(365, k, replace = T)

tally = table(bdays)

tally

max(tally > 1)  # 1 will mean True, 0 will mean False.

# Now make the loop to do it many times and record the results:
ntrials = 1000
results = logical(ntrials)
results[1:50]

for(i in 1:ntrials){
  bdays = sample(365, k, replace = T)
  tally = table(bdays)
  results[i] = (max(tally) > 1)
}

results[1:50]

results = as.numeric(results)

results[1:50]

# Note: in the "results" vector, 
# 1 means "True" 
#     (i.e., "max(tally) > 1" was True for that iteration, 
#      i.e., there was at least one bday match on that iteration),
# and 0 means "False"
#     (i.e., "max(tally) > 1" was False for that iteration, 
#      i.e., there was no bday match on that iteration)

sum(results)/length(results)  # <-- estimated probability of a match  

# R tends to be friendly and robust.  Don't worry about doing something wrong.
i=1
while(i<1000){
  i = i+1
}

i

# An infinite loop:
i=1
while(i>0){
  i = i+1
}

# Just hit "escape" (at least in the Windows version)!
