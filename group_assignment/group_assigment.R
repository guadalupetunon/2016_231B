###############################################
# Group assignment - PolSci 231B (2016)
###############################################

library(foreign)
setwd("~/Dropbox/231B_Spring2016/group_assignment")
students <- as.vector(read.csv("student_list.csv", header = FALSE)[,1])[1:17]
#students <- students[students$Credit==1,]

# setting seed so that we can reproduce the sampling with the same results
set.seed(532)

# there will be 3 groups of 4 and 1 of 5
groups <- c(rep(1:4, 4), 4)
students <- as.data.frame(cbind(students, sample(groups, length(students), replace=F)))
names(students) <- c("student", "group")

# creating a list to print students by group
groups <- list(NA)
for (i in 1:4){groups[[i]] <- students[students$group==i,1:2]}

names(groups) <-   paste0("GROUP ", 1:4)

groups

save(groups, file="groups.Rda")




