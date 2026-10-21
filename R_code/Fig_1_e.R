f_Oage_prop<-proportions(as.matrix(f_Oage),margin=2)
f_Oage_prop

# Fig. 3E new?
f_Oage_plot<-barplot(f_Oage_prop,beside=TRUE,col=c("steelblue4","orange3","grey70"),border="grey30",
                     names.arg = c("Infant","Juvenile","No offspring"),las=1,ylab="Proportion of hunting females",
                     ylim=c(0,0.7),xlab="Offspring",cex.lab=1.5,cex.axis=1.2,cex.names=1.2)
