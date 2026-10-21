### Plot probability of female hunts by speceis and community
m_fm<-readRDS("Results/m_p_female_null.rds")
# Plot results
M2<-rstan::extract(m_fm)
library(rethinking)
# First we plot probability considering individuals from both communities (panel A)
par(bty="n",mar=c(4,4,2,0),las=1)
plot(density(inv_logit(M2$pred_p[,1])),col="steelblue4",lwd=5,
     xlim=c(0,1),ylim=c(0,8),xlab="Probability of female hunting",ylab="Density",main="Both")
lines(density(inv_logit(M2$pred_p[,2])),col="orange3",lwd=5)
lines(density(inv_logit(M2$pred_p[,3])),col="grey70",lwd=5)
abline(v=0.5,lwd=5,lty=2)

# We look at West alone  (panel B)
plot(density(inv_logit(M2$p[,1,2])),col="steelblue4",lwd=5,
     xlim=c(0,1),ylim=c(0,7),xlab="Probability of female hunting",ylab="Density",main="West")
lines(density(inv_logit(M2$p[,2,2])),col="orange3",lwd=5)
lines(density(inv_logit(M2$p[,3,2])),col="grey70",lwd=5)
abline(v=0.5,lwd=5,lty=2)

# And East alone  (panel A)
plot(density(inv_logit(M2$p[,1,1])),col="steelblue4",lwd=5,
     xlim=c(0,1),ylim=c(0,7),xlab="Probability of female hunting",ylab="Density",main="East")
lines(density(inv_logit(M2$p[,2,1])),col="orange3",lwd=5)
lines(density(inv_logit(M2$p[,3,1])),col="grey70",lwd=5)
abline(v=0.5,lwd=5,lty=2)
