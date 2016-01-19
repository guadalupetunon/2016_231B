###############################################
# A Brief Introduction to R
# Danny Hidalgo (adapted from Erin Hartman's code)
# PS 236A/ Stat 239A Fall 2010
###############################################

# What is R?
# - language and environment mostly used for statistical computing and graphics
# - based on S, a statistical programming language started at Bell Labs
# - has a basis in Fortran and Scheme
# - open source (and free!)
# - many people contribute an abundance of useful packages

# Installation
# can be found at:
# http://cran.r-project.org/
# - download the binary for your OS (or install from source, if you wish)
# - run the installer and follow the instructions



# Most useful tool in R, help

# Starts an interactive html help file
help.start()

# help function for 'mean'
help(mean)

# also help for 'mean'
?mean

# search
# suppose we want to find the command for the product of a vector
help.search("product")

# Installing Packages:
# Jas's matching package
# note: dependencies = TRUE is important to also download all child packages
install.packages("Matching", dependencies = TRUE)
install.packages("rgenoud")

# useful package for dealing with external data files
install.packages("foreign")

# Using packages:

# we must load the package we just installed in order to use it
# note: you only have to install once, but you must load libraries every time you want to use them 

library(Matching)
library(MASS)
library(foreign)


# note that now, we can find the help file
help(read.csv)

# Navigating:

#see what working directory you are in:
getwd()

# change to another working directory
setwd("~/Desktop/Rsession")
getwd()

# list all objects in your workspace (currently should be empty)
ls()



# Assignment

# there are two way of doing assignment, <- and =
x <- 5
y = 2
x
y


# Basic Math:
z <- x + y
z
z - 2
x * 5
y / 3


# Classes and Casting:
# A class refers to the type of an object.
# Casting refers to recasting an object to another type of class
# there are a few major classes:
# integer and numeric:
x <- 1
class(x)
as.integer(x)

x <- 2.5
class(x)
as.integer(x)

# character:
y <- "test"
class(y)
as.numeric(y)

# there is also matrix, array, list, expression, and many more, which we will encounter later


# Loading Data from external files
data <- read.csv(file = "ps_1_exampleData1.csv")
data

# what do we know about 'data'
# gives us the dimensions as nrow, ncol
dim(data)

# gives the column names of data
names(data)

# we can use the $ to access a named column of our object
# by typing objectName$columnName
data$x1
21# gives us the length of a vector
length(data$x1)

# loading data from an R library
# use the lalonde data set in the Matching library
data(lalonde)
ls()
names(lalonde)
dim(lalonde)
lalonde$age




# Some Basic Commands:

# Making Objects:
# sequence

# a sequence from 0 to 5 in 0.5 increments
seq.1 <- seq(0, 5, 0.5)
seq.1
class(seq.1)

# a sequence of integers
seq2 <- 1:10
seq2
class(seq2)

# making squares
myX <- 1:4
myX

# note: for an array, ^2 will to element wise operation
myX <- myX^2
myX

# assign some names to our array usinc "c()", which concatenates
names(myX)
names(myX) <- c("1 squared", "2 squared", "3 squared", "4 squared")
myX
class(myX)

# matrices
mat1 <- matrix(data = 1:10, nrow = 5, ncol = 2, byrow = TRUE)
mat1
mat2 <- matrix(1:10, 5, 2, byrow = FALSE)
mat2


# element wise logical comparison
# == will test for equality in the two compared objects
mat1 == mat2

ls()
x == y
x == z
x == x

# clearing our workspace
rm(list = ls())
ls()


# data frames
# a data frame is a list of variables of the same length with unique row names.
# it is best to put your data in a data frame when working with it
# when you read in data, R coerces it into a data.frame class

data <- read.csv("ps_1_exampleData1.csv")
class(data)
names(data)
rownames(data)

# we can also make our own data frame
x <- 1:16
y <- seq(1, 4, .2)
length(x)
length(y)
myData <- data.frame( X = x, Y = y )
names(myData)
dim(myData)
class(myData)

myData$X
myData$Y

# attach allows us to access the columns of a data frame without typing the object name and run some diagnostics
attach(myData)
X
mean(X)
min(X)
Y
max(Y)
sd(Y)
detach(myData)


# Indexing... Super Important

# indexing arrays:
x
# return the first five elements of x
x[1:5]
# set the first five elements of x to NA
x[1:5] <- NA
x
# check for missing values, returns a logical vector
is.na(x)
class(is.na(x))

# putting a ! infront of a logical command will negate it
!is.na(x)

# find the number of missing values and non-missing values
sum(is.na(x))
sum(!is.na(x))

# check that all elements are accounted for
sum(is.na(x)) + sum(!is.na(x)) == length(x)

# making a new vector from a subset of an existing vector
# in this case, make a vector of all non-missing values of x
x2 <- x[!is.na(x)]
x2
length(x2)
# in this case, drop the first three values
x3 <- x[-c(1:3)]
x3

# indexing matrices:
# same as before, except now we must include a row and column value
data

# are there any missing data points in data$x1
sum(is.na(data$x1))
# what about in the whole data set
sum(is.na(data))

# element row = 2, column = 1
data[2, 1]

# rows in which x1 < 0
data[data$x1 < 0, ]

# rows in which x1 < 0 and only columns 1 to 3
data[data$x1 < 0, 1:3]

attach(data)
data[x1 < 0, 1:3]
detach(data)

# indexing variables
# find all values of y1 for which x1 is also negative
data$y1[data$x1 < 0]


# finding subsets
# note: we have >, <, >=, <=, !=, == as logical operators to use
# we can use & to do and statements and | to do or statements
library(MASS)
data(painters)
names(painters)
rownames(painters)

attach(painters)


painters[School == "A", ]
rownames(painters[School == "A", ])

# the & means that the row must meet both conditions
# putting nothing after the comma means "all columns"
painters[School == "A" & Drawing < 15, ]
subPainters <- painters[School == "A" & Drawing < 15, ]
subPainters

colours <- painters[School == "A" & Drawing >= 15, 3]
colours

painters[School == "A" | School == "B", ]
painters[School == "C" | School == "D", c(1:3)]

# putting nothing before the comma means "all rows"
painters[, 2]

detach(data)



# For Loops
# we can use for loops to iterate through a process
# we index with i, and the for loop iterates through the process from the starting value to
# the last value, in this case starting at 1, incrementing by 1 each time, until we reach 5
for( i in 1:5) {
	print(paste("Hello, world!  I'm on interation", i))
}

# in this case we don't plug in consecutive values for i
for( i in c(3,10,9)) {
	print(paste("Hello, world!  I've got i equal to", i))
}

# making squares using a for loop
squares <- NULL
for( i in 1:5) {
	squares <- c(squares, i^2)	
	print(squares)
	print(paste("The mean is currently", mean(squares)))
}
squares
mean(squares)

# dealing with columns of data
data
for( i in 1:ncol(data)) {
	print(paste("The mean of column", i, "is", mean(data[, i]) ))
}

# find the max for each of the rows of data using a for loop
# note: the object we index by doesn't have to be 'i', that is just convention
for( j in 1:nrow(data)) {
	print(paste("The max of column", j, "is", max(data[j, ]) ))
}




# Apply
# apply is similar to the idea of a for loop, but it is taylored to matrices and data frame
help(apply)
# we must pass in our object, the margin we want to iterate over (1 means rows, 2 means columns), and a function

# find the means of all the columns of data
means <- apply(data, MARGIN = 2, mean)
means

# find the max of all the rows of data
rowMax <- apply(data, 1, max)
rowMax



# Linear Regression:
data(cars)
attach(cars)

help(lm)

# make a new variable, speed^2
speed2 = speed^2

# model 1, just speed on distance with intercept
lm1 = lm(dist ~ speed)
summary(lm1)

# model 2, speed and speed^2 on distance with intercept
lm2 = lm(dist ~ speed + speed2)
summary(lm2)

# model 3, speed and speed^2 no intercept
lm3 = lm(dist ~ speed + speed2 - 1)
summary(lm3)

detach(cars)
