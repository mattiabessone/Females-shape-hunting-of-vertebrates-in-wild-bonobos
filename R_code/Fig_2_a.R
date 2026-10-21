### Plot difference in faunivory frequency East vs West
library(rstan)
m1<-readRDS("Results/intercommunity_full.rds")
# Extract result of m1 and plot (panel A)
M<-rstan::extract(m1)

temp<-cbind(rbind(M$pred_p_W[,1],M$pred_p_E[,1]),
            rbind(M$pred_p_W[,2],M$pred_p_E[,2]),
            rbind(M$pred_p_W[,3],M$pred_p_E[,3]))
temp1<-cbind(M$pred_p_W[,1],M$pred_p_E[,1],
            M$pred_p_W[,2],M$pred_p_E[,2],
            M$pred_p_W[,3],M$pred_p_E[,3])

par(bty="n",mar=c(4,4,2,0),las=1)
stripchart(as.data.frame(temp1),xlim=c(0,4),ylim=c(0,1),at=c(0.25,0.75,1.75,2.25,3.25,3.75),
           vertical=T,method="jitter",jitter=0.1,pch=1,cex=0.3,tck=-0.01,
           col=rep(c("grey50","pink3"),3),group.names=rep("",6),
           ylab="Probability hunting",xlab="Prey",xaxt="n",main="")
axis(side=1,at=c(0.5,2,3.5),labels=c("Ungulates","Primates","Other vertebrates"),tck=0.01)
boxplot(as.data.frame(temp1),xlim=c(0,4),at=c(0.25,0.75,1.75,2.25,3.25,3.75),
        col="transparent",border=rep(c("grey20","purple4"),3),
        boxwex=0.1,lwd=2,outline=F,xaxt="n",add=T)

