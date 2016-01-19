############################################################################
# Advanced Quantitative Methods and Research Design
# Department of Peace and Conflict Research, Uppsala University.
# R crash code - Part I
# Guadalupe Tuñón
############################################################################

# Acknowledgements: this code has been adapted from previous codes by 
# Joseph Chang, Danny Hidalgo, Jennifer Pan and Rocio Titiunik. 

########################################################
## PREAMBLE: Script and Console
########################################################

# R works by 
# 1. typing code in the console (next to the 'greater than' sign) 
# 2. OR by typing on a script (like this one) and sending the lines of
# code to the console.
# For windows: use Ctrl-R to send text from Editor to Console
# For macs: use Command-Enter to send text to Console

# If R seems to sit there waiting for more without showing you 
# the usual prompt "> ", you may need to hit "Enter".

# Unless you are working on very simple calculations, write in the editor 
# and save your code as a script using a ".R" file extension (again, 
# like this one).

# Every line that begins with '#' is ignored by the console.
# So you can add comments to your code without generating syntax errors.
# In fact, your code should be heavily commented so that you can understand
# what you've done if you had to come back to it later.

## REMEMBER: the learning curve is steep but it pays off!


########################################################
## R help!
########################################################

## Use the "help" command; it's your friend.

?mean

## or 

help(mean)

########################################################
## R as a calculator
########################################################

2 + 18

50821/6

21^4

log(4)/9^2


# R is an object-oriented programming language
# Store an object for later retrieval by using " <- " as assignment operator
# (mac shortcut:  hit option and the minus sign at the same time).

a <- 2 + 18
a

b <- 50821/6
b

my.name <- "Guadalupe"
my.name


## Use the ls() command to see what objects are currently stored 
## in the R environment

ls()

## Use the rm() command to get rid of a particular object stored

rm(my.name)
ls()

## Use the rm(list = ls()) command to get rid of all objects stored

rm(list = ls())
ls()


########################################################
## Objects
########################################################

## R can store objects, and you can call these up later.
## As noted above objects are defined using "<-" 

scalar1 <- 2
scalar1              # this is a NUMERIC "data type"
class(scalar1)

R <- "fun"
R                    # this is a CHARACTER "data type"
class(R)

truth.vec <- TRUE
truth.vec            # this is a LOGICAL "data type"
class(truth.vec)

## Note: Don't name your objects things like "mean"
## or "sum" or "7" since those are things that R already
## has pre-packaged.

# You can make longer things, like vectors,
# which we create with c(), for concatenate 

vec1 <- c(2,2,7,-1,4)

R <- c("getting","better","at", "R")
R

## R performs math on numeric objects

vec2 <- c(2,5,1,3,2)

vec1 + vec2

vec1 - vec2

3*vec2

vec2*3

## Tricks for creating vectors

vec3 <- 1:5 # uses integers from 1 to 5
vec3

vec3 <- c(1:5, 7, 11) # integers from 1 to 5 plus then 7 and 11
vec3

vec4 <- c(vec1, vec2) # concatenates vector 1 and vector 2
vec4

## Subsetting (use [ ] to pick out elements of an object)
## recall: vec1 is c(2,2,7,-1,4); vec4 is c(2,2,7,-1,4, 2,5,1,3,2)

vec1[1]

vec1[6] # there is nothing in the sixth place of vector 1!

vec1[-1] # retrieves vector1 WITHOUT the first element

vec4[c(5,7)] # retrieves positions 5 and 7 in vector4

vec4[c(5:7)] # retrieves positions from 5 to 7 in vector4

## You can also replace a particular element of a vector

vec1[3] <- 6
vec1 # now the third element is a 6 instead of a 7!


########################################################
## Basic R functions
########################################################

# R has many preprogrammed functions that manipulate objects.
# To use a function, you type the function name followed by the
# arguments in parentheses.

a <- c(1,3,6,5,9,22) # concatenate
a

b <- c(4,5,6,5,2,1)
b

sum(a) ## sum of all elements of a

sum(b)

sum(a,b)

max(a) ## maximum element in a

min(a) ## minimum element in a

mean(a) ## mean of a

length(a) ## number of elements in a,
## useful for when you need to calculate the sample size, n

sort(a) ## sorts the elements of a from lowest to highest

## you can store the output of a function, as a new object.

output <- length(a)
output

## These functions are useful for creating vectors

seq(from = 0, to = 5, by = .5) 
## creates a sequence of numbers

rep(10, 27) 
## repeats the number "10" 27 times.

## to learn the arguments for a particular 
## function, use the help commands:

?sort

sort(a)
sort(a, decreasing = TRUE)


# Create a vector of 12 random numbers drawn from a uniform distribution 
# over the interval between 0 and 1:
z <-  runif(12)

z

# We can see which of these is less than 0.5 with the expression "z < 0.5"
z < 0.5

# R identifies "True" with "1" and "False" with "0":
as.numeric(z < 0.5)


########################################################
## Matrices
########################################################

## the matrix() function in R is one way to create a matrix

matrix(data = 1:12, nrow = 3, ncol = 4)

matrix(data = 1:12, nrow = 2, ncol = 6)

matrix(data = 1:12, nrow = 2, ncol = 6, byrow = TRUE)

## You can also create a matrix from vectors
## using the cbind and rbind commands

my.vec <- c(4:8)
my.vec2 <- c(5:9)
my.vec3 <- c(1:5)

cbind(my.vec, my.vec2, my.vec3)
rbind(my.vec, my.vec2, my.vec3)

## Let's store the last matrix

mat <- rbind(my.vec, my.vec2, my.vec3)

## You can give your matrix colums and rows names

rownames(mat)

colnames(mat) <- c("col1","col2","col3","col4","col5")

mat

## We can extract particular elements of a matrix just like
## we could from a vector, though this time we have to specify
## two dimensions, the row and the column

## remember: what comes before the comma refers to row, 
## after the comma refers to columns

mat[1,1] # first row, first column

mat[,1]  # first column

mat[1,]  # first row



########################################################
## Dataframes
########################################################

#### Dataframe: a data frame is also a two-dimensional (row x column) object

## Each column must be of the same data type
## But data type may vary by column

## Regression and other statistical functions usually use dataframes
## Use as.data.frame() to convert matrices to dataframes

as.data.frame(mat)
class(mat)
mydataframe <- as.data.frame(mat)
mydataframe
class(mydataframe)

## When working with dataframes, we can subset and retrieve a column with '$'
mydataframe$col1
# we will use this often to refer to a variable in a dataset.

## We can subset using logical statements
## This means we can find certain items in our data sets
## by what they are (they satisfy the logical statement), not their position.

mydataframe$col1 == 1
# look at which elements of the "dem" columns are 1's
mydataframe$col2 == 1


mydataframe[mydataframe$col1 == 1, ]
# show me the rows for which "col1" is 1

# Logical tests
# == is equal to
# != is not equal to
# & and
# | or
# <= less than or equal to
# >= greater than or equal to

mydataframe[mydataframe$col1 > 1, ]
# show me the rows for which "col1" is greater than 1


#################################################################
## We encourage you to go through this code more than once.
# You can also experiment by making changes in the commands and 
# re-running them as often as possible.  
#################################################################




