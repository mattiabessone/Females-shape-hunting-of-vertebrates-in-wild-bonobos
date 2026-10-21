# Plot age relations with prey
m_fm_age<-readRDS("Results/m_p_female_age.rds")
M<-extract((m_fm_age))
library(rethinking)
pred_age<-seq(7,49,0.5)

p_pred<-matrix(NA,nrow=length(pred_age),ncol=3)
p_pred_HPDI<-array(NA,dim=c(length(pred_age),3,2))

for(n in 1:length(pred_age)){
  for(k in 1:3){
    
    p_pred[n,k]<-inv_logit(mean(M$a[,k]) + mean(M$b1[,k]) * pred_age[n])
    p_pred_HPDI[n,k,1]<-inv_logit(HPDI(M$a[,k],prob=0.8)[1] + HPDI(M$b1[,k],prob=0.8)[1] * pred_age[n])
    p_pred_HPDI[n,k,2]<-inv_logit(HPDI(M$a[,k],prob=0.8)[2] + HPDI(M$b1[,k],prob=0.8)[2] * pred_age[n])

     }
}

par(mar=c(5,5,1,1))
plot(x=pred_age,y=p_pred[,1],type="n",xlim=c(7,49),ylim=c(0,1),las=1,xaxt="n",bty="n",xlab="Age (years)",ylab="Probability of female huting",cex.axis=1.2,cex.lab=1.5)
polygon(x=c(pred_age,rev(pred_age)),y=c(p_pred_HPDI[,3,1],rev(p_pred_HPDI[,3,2])),col=adjustcolor("grey70",0.2),border="grey50",lty=2)
polygon(x=c(pred_age,rev(pred_age)),y=c(p_pred_HPDI[,2,1],rev(p_pred_HPDI[,2,2])),col=adjustcolor("orange3",0.2),,border="orange3",lty=2)
polygon(x=c(pred_age,rev(pred_age)),y=c(p_pred_HPDI[,1,1],rev(p_pred_HPDI[,1,2])),col=adjustcolor("steelblue4",0.2),border="steelblue4",lty=2)

lines(x=pred_age,y=p_pred[,3],col="black",lwd=3)
lines(x=pred_age,y=p_pred[,2],col="brown4",lwd=3)
lines(x=pred_age,y=p_pred[,1],col="navyblue",lwd=3)

axis(side=1,at=seq(7,49,7),labels=seq(7,49,7),cex.axis=1.2)