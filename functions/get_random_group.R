########################################
# Function to get a random group 
########################################

random_group <- function(){
  
  # load list with groups
  load("~/Dropbox/231B_Spring2015/groups.Rda")
  
  # print group number and members
  print(groups[[sample(1:6, 1)]])
  
}



