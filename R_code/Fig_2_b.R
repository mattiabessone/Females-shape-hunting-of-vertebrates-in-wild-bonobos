m1<-readRDS("Results/intercommunity_full.rds")
# Extract result of m1 and plot
M<-rstan::extract(m1)
par(mfrow=c(1,2),bty="n",mar=c(2,2,2,0),las=1)
# West community (panel B)
stripchart(as.data.frame(cbind(-M$b3[,,2],M$b2[,,2],M$b1[,,2])),
           vertical=F,method="jitter",jitter=0.2,pch=16,cex=0.3,tck=-0.01,
           col=c("steelblue4","orange3","grey70"),group.names=rep("",3),,xlim=c(-4,4),
           ylab="",xlab="",yaxt="n",main="West community")
boxplot(as.data.frame(cbind(-M$b3[,,2],M$b2[,,2],M$b1[,,2])),
        horizontal=T,col="transparent",border=c("navyblue","brown4","black"),
        boxwex=0.25,staplewex=1.2,lwd=1.5,outline=F,add=TRUE,names = rep("",9),yaxt="n")
axis(side=2,at=c(2,5,8),labels=rep("",3),tck=-0.01)
segments(x0=rep(-4.5,5),x1=rep(4.5,5),y0=c(3.5,6.5),y1=c(3.5,6.5),lwd=0.5,col="grey80")
abline(v=0,lwd=1.5)
# East community (panel C)
stripchart(as.data.frame(cbind(-M$b3[,,1],M$b2[,,1],M$b1[,,1])),
           vertical=F,method="jitter",jitter=0.2,pch=16,cex=0.3,tck=-0.01,
           col=c("steelblue4","orange3","grey70"),group.names=rep("",3),xlim=c(-4,4),
           ylab="",xlab="",yaxt="n",main="East community")
boxplot(as.data.frame(cbind(M$b5[,,1],M$b4[,,1],-M$b3[,,1],M$b2[,,1],M$b1[,,1])),
        horizontal=T,col="transparent",border=c("navyblue","brown4","black"),
        boxwex=0.25,staplewex=1.2,lwd=1.5,outline=F,add=TRUE,names = rep("",9),yaxt="n")
axis(side=2,at=c(2,5,8),labels=rep("",3),tck=-0.01)
segments(x0=rep(-4.5,5),x1=rep(4.5,5),y0=c(3.5,6.5),y1=c(3.5,6.5),lwd=0.5,col="grey80")
abline(v=0,lwd=1.5)

