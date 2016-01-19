
################################################## ################################
# INTRODUCTION TO R
# by Rocio Titiunik
# Sept 4th, 2007
################################################## ################################

# 1) How to use the help
help.start()          # Gives the html version of the help
help(sum)             # Gives help about 'var'
?sum                  # Gives help about 'var'



# 2) How to install packages and libraries

## Installing Sekhon's functions
# Remember to disable Firewall (or similar program) before
# installing these packages
install.packages("Matching", dependencies=TRUE)
install.packages("rgenoud")


# After installing, you must load the libraries, otherwise:
         # you won't be able to use the functions
         # you won't find the help


library(MASS)         # Loads the library "MASS"
library(Matching)

# 3) How to import and export files

# Read data from a file: Stata type, csv, etc

# A useful package to read in data: foreign
install.packages("foreign")
library(foreign)      # Loads the read.*** and write.*** commands

help(read.dta)        # You won't find the help unless the library is loaded

# If you are in Windows: set the working directory to simplify your life

# for example:
setwd("C:/Documents and Settings/Rocio Titiunik/My Documents/__Papers/Gertler-Tucasa/PisoFirme/_PaperPisoFirme/Tables")

# Careful !! ==> use "\" and NOT "/"

# If you don't want to set the working directory, just give the entire path

data.1<-read.dta(file="PF_households_labels_short.dta")
# Note that we have created an **object** called data.1 that contains our dataset

### The assingment can be done with "<-" or "=", your choice
x<-1
x
y=3
y

## How to see inside a dataset

dim(data.1)
names(data.1) # Shows the variables we have
data.1$educ.hh  # We can access each variable using hte $ sign
                # Or we can attach the data and acess the variables directly ==>put variables in the search path
                # Attach ==> Makes the columns of the data frame available by name
attach(data.1)
data.1
educ.hh
detach(data.1)
# If I detach, I don't find N.treat anymore
educ.hh

# 4) How to load data sets available in libraries

data() # Lists the available data sets.
data(nameofdataset) # Loads specified data set

data(package = .packages(all.available = TRUE)) # Lists the data sets in
# all *available* packages.

###################### Introductory Commands ################################

# 1) OBJECTS
seq1<-0:5         # Sequence of integers from 0 to 5
powers.of.2<-2^(1:4)
powers.of.2
class(powers.of.2)
print(powers.of.2)
powers.of.2
summary(powers.of.2)
rm(powers.of.2) # Removes the sequence "powers.of.pi"

# Give names to the elements
powers.of.2<-2^(1:4)
names(powers.of.2)<- c("To the 1st","To the 2nd","To the 3rd","To the 4th")
powers.of.2
powers.of.2 ["To the 3rd"] #Gives the same as powers.of.2 [5]
class(powers.of.2)
# Remove names
names(powers.of.2)<-NULL
powers.of.2

# 2)DATA FRAMES

### A data frame is a list of variables of the same length with unique row names, given class "data.frame".
### When you work with data, you want to group your data in a data frame. The "read" command automatically coerces
### your data into a data frame
library(MASS)
data(painters)
painters
row.names(painters)
summary(painters)
names(painters) # When you have a data frame, names gives you the names of hte columns
attach(painters) # Makes the columns of the data frame available by name
detach()          # Always detach at the end

# We can create a dataframe with the function "data.frame"
x<-seq(1,20,by=1)
y<-rnorm(20,mean=10,sd=1)
# Do they have same length?
length(x)
length(y)
plot (x,y,main="Name of title")
# Let's combine them in a data frame

mydat<-data.frame(x, y)
mydat

mymatrix<-matrix(data=1:30,ncol=3,nrow=10,byrow=TRUE)     # Puts the sequence 1 to 30 in a 3row by 10 column matrix
mymatrix
mymatrix<-matrix(1:30,3,10,byrow=FALSE)     # Puts the sequence 1 to 30 in a 3row by 10 column matrix
mymatrix
class(mymatrix)
dim(mymatrix) # Dimension
# Missing values appear as "NA"
z<-c(pi,4,5) # Command "c()" concatenates
z
z[2]<-NA     # I make this a missing element
z
class(z)
is.na(z)

# INDEXING: THE SINGLE MOST IMPORTANT THING

x<-seq(1:15,by=1)
x
x[13:15]<-NA
x
is.na(x)                  # Gives you a logical vector ==> True if elements of x is missing
!is.na(x)                 # Gives you the negation ==>True if element of x is not missing
x[!is.na(x)]              # **Shows** all elements of x that are NOT NA
y<-x[!is.na(x)]           # Keeps all elements of x that are NOT NA in another variable
y
part.x<-x[1:10]
part.x
x[1:4]
letters
letters[1:3]
letters[c(1:3,3:1)]       # The function c concatenates
y<-x[-(1:5)]              # Drops the first five elements of x
x
y
x
x[is.na(x)]<-0           # Replaces NA values in x by zero
x
## Indexing Matrices
# mymatrix is a 3x10 matrix
# see element 3,1
mymatrix[3,1]
# keep only rows 1 and two but all columns
mymatrix.short<-mymatrix[1:2,]
mymatrix.short

# Indexing variables of a data frame
data.1 # never do this with very big datasets
names(data.1)
data.1$educ.sp
z<-data.1$educ.sp[data.1$educ.sp>9]
dim(z)
class(z)
length(z)

## Linear regression
data(ToothGrowth) # Effect of vitamin C on toogh growth in Guinea Pigs
ToothGrowth
attach(ToothGrowth)
dose2<-dose^2
lm(len~dose+dose2)
summary(lm(len~dose+dose2,data=ToothGrowth))
summary1<-lm(len~dose+dose2)
summary1

## Apply
means1<-apply(mymatrix,2,mean)      # 2 col, 1 row
means1
# Fantastic trick to extract tables
install.packages("R2HTML")
install.packages("xtable")
library(R2HTML)
library(xtable)
library(foreign)      # Loads the read.*** and write.*** commands

summary1
xtable(summary1)
print.xtable(xtable(summary1), type="html",file="table1.xls") # This syntax does not work anymore
print(xtable(summary1), type="html",file="table1.xls")
print(xtable(summary1), type="html",file="table1.txt")

# Selectiing subsets
attach(painters)
painters
painters[Colour>=17,]
painters[Colour>=15 & School!="D",]
painters[Colour>=15 & Composition>10,2]
painters[is.element(School, c("A", "B", "C")),c(1,4,5)]  # The comma means "all columns"

# Recode missing values for a vecotr z where 9, 99, and 999 represent missing
z<-1:25
z[is.element(z,c(9,10,15))]<-NA

# Or
z<-1:25
z
z[z==9 | z==10 | z==15]<-NA
z

