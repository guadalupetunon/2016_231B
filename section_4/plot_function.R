# Plot smoothed histograms showing the distribution of estimated coefficients
plotfunc <- function(maintitle="", coefs, omitted=FALSE, betas){
  plot.new()
  par(usr=c(-2,6.5,0,3))
  axis(1,at=seq(-2,6.5,1))
  axis(2,at=seq(0,3,1))
  title(ylab="Density", main=maintitle)
  
  # colors
  cols <- c("#66C2A5", "#8DA0CB", "#FC8D62")
  
  # Plot estimatted coefficients
  coefs <- coefs[-1,] #eliminating row for intercept
  betas <- betas[-1] # and estimated intercept
  for (i in 1:nrow(coefs)){
    
    # Add polygon with distribution implied by mean(beta) and sd(beta)
    xs <- seq(-3,10,by=0.01)
    polygon(xs, dnorm(xs, mean=mean(coefs[i,]), sd=sd(coefs[i,])),
            col=lighten(cols[i]), border=NA)
    
    # Add smoothed histograms of the estimated betas
    lines(density(coefs[i,])$x,
          density(coefs[i,])$y,
          col=cols[i], lwd=2)
    
  }
  
  # Line with the location of the true values of the parameters
  for (i in 1:nrow(coefs)){
    lines(x=c(betas[i], betas[i]), y=c(0,1), col = cols[i], lwd=2)
  }
  
  # Labels (need to do this outside the loop because expression() requires the number)
  # Label the smoothed histograms of estimated betas and labels 
  # of the true values below the X axis
  # x1
  text(x=mean(coefs[1,]), y=max(density(coefs[1,])$y)+0.3,
       label=expression(hat(beta)[1]), col=cols[1])
  mtext(side=1, line=2, at=betas[1], col=cols[1],
        text=expression(paste("True",beta[1],sep=" ")))
  # x2
  text(x=mean(coefs[2,]), y=max(density(coefs[2,])$y)+0.3,
       label=expression(hat(beta)[2]), col=cols[2])
  mtext(side=1, line=2, at=betas[2], col=cols[2],
        text=expression(paste("True",beta[2],sep=" ")))
  # x3, only if not omitted
  if (omitted==FALSE){
    text(x=mean(coefs[3,]), y=max(density(coefs[3,])$y)+0.3,
         label=expression(hat(beta)[3]), col=cols[3])
    mtext(side=1, line=2, at=betas[3], col=cols[3],
          text=expression(paste("True",beta[3],sep=" ")))
  }
  
}

# Function to lighten colors
lighten <- function (col, pct = 0.75, alpha = 1) 
{
  if (abs(pct) > 1) {
    print("Warning:  Error in Lighten; invalid pct")
    pcol <- col2rgb(col)/255
  }
  else {
    col <- col2rgb(col)/255
    if (pct > 0) {
      pcol <- col + pct * (1 - col)
    }
    else {
      pcol <- col * pct
    }
  }
  pcol <- rgb(pcol[1], pcol[2], pcol[3], alpha)
  pcol
}

