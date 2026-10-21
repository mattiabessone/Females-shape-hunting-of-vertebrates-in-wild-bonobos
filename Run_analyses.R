#*** Females shape hunting of vertebrates in wild bonobos ***#
#*** Hohmann et al., Current Biology (2026) ***#
####** Statistical analysis by M. Bessone **####

#### 1) Import and process data ####
source("R_code/prepare_data.R")

#### 2) Hunting behaviour - general ####
# General
nrow(d_fauna) # Number of cases (n)
table(d_fauna$community) # n by community
table(d_fauna$outcome) # n by prey: 1 = ungulates, 2 = primates, 3 = other (rodents, birds, unidentified)
proportions(table(d_fauna$outcome)) # proportions prey
# Species
table(d_fauna$prey_speci[d_fauna$prey_order=="Primates"])
table(d_fauna$prey_speci[d_fauna$prey_order=="Artiodactyla"])

#### 3) Female hunting ####
#### 3.1) Descriptives ####
nrow(d_hunt) # n of hunts with known hunters
table(d_hunt$sex) # hunts by sex

#### 3.2) MODEL: Effect of party size and composition on probability female hunting by prey ####
# Null
m_fm<-rstan::stan(data=data2,"Stan_code/bernoulli_null.stan",cores=4,chains=4)
saveRDS(m_fm,"Results/m_p_female_null.rds")
# Full
m_fm2<-rstan::stan(data=data2,"Stan_code/bernoulli_full.stan",cores=4,chains=4)
saveRDS(m_fm2,"Results/m_p_female_full.rds")
# Compare models
loo_m0<-loo(m_fm)
loo_m1<-loo(m_fm2)
loo_compare(loo_m0,loo_m1)
# We retain the null model
summary(m_fm,pars=c("p"))$summary[,c(1,3,4,8:10)] 

#### 4) Female status and offspring age ####
#### 4.1) Descriptives ####
mean(d_hunt$age[d_hunt$sex==1]) # average age of hunting females 
sd(d_hunt$age[d_hunt$sex==1]) # standard deviation of age of hunting females

#### 4.1.1) Age by community and prey ####
# Organize in a dataframe (f_age) the average age if hunting females by prey and community
f_age<-as.data.frame(matrix(NA,nrow=3,ncol=3))
f_age[1,1]<-mean(d_fem$age[d_fem$outcome==1],na.rm=T)
f_age[2,1]<-mean(d_fem$age[d_fem$outcome==2],na.rm=T)
f_age[3,1]<-mean(d_fem$age[d_fem$outcome==3],na.rm=T)
f_age[1,2]<-mean(d_fem$age[d_fem$outcome==1 & d_fem$community=="WBp"],na.rm=T)
f_age[2,2]<-mean(d_fem$age[d_fem$outcome==2 & d_fem$community=="WBp"],na.rm=T)
f_age[3,2]<-mean(d_fem$age[d_fem$outcome==3 & d_fem$community=="WBp"],na.rm=T)
f_age[1,3]<-mean(d_fem$age[d_fem$outcome==1 & d_fem$community=="EBp"],na.rm=T)
f_age[2,3]<-mean(d_fem$age[d_fem$outcome==2 & d_fem$community=="EBp"],na.rm=T)
f_age[3,3]<-mean(d_fem$age[d_fem$outcome==3 & d_fem$community=="EBp"],na.rm=T)
colnames(f_age)<-c("All","West","East")
# We then test pairwise differences with Mann-Whitney U test
# Considering both communities
wilcox.test(d_fem$age[d_fem$outcome==1],d_fem$age[d_fem$outcome==2],na.rm=T)
wilcox.test(d_fem$age[d_fem$outcome==1],d_fem$age[d_fem$outcome==3],na.rm=T)
wilcox.test(d_fem$age[d_fem$outcome==2],d_fem$age[d_fem$outcome==3],na.rm=T)
# Only West
wilcox.test(d_fem$age[d_fem$outcome==1 & d_fem$community=="WBp"],d_fem$age[d_fem$outcome==2 & d_fem$community=="WBp"],na.rm=T)
wilcox.test(d_fem$age[d_fem$outcome==1 & d_fem$community=="WBp"],d_fem$age[d_fem$outcome==3 & d_fem$community=="WBp"],na.rm=T)
wilcox.test(d_fem$age[d_fem$outcome==2 & d_fem$community=="WBp"],d_fem$age[d_fem$outcome==3 & d_fem$community=="WBp"],na.rm=T)
# Only East
wilcox.test(d_fem$age[d_fem$outcome==1 & d_fem$community=="EBp"],d_fem$age[d_fem$outcome==2 & d_fem$community=="EBp"],na.rm=T)
wilcox.test(d_fem$age[d_fem$outcome==1 & d_fem$community=="EBp"],d_fem$age[d_fem$outcome==3 & d_fem$community=="EBp"],na.rm=T)
wilcox.test(d_fem$age[d_fem$outcome==2 & d_fem$community=="EBp"],d_fem$age[d_fem$outcome==3 & d_fem$community=="EBp"],na.rm=T)

#### 4.1.2) Age in relation to presence of dependent offspring by community and prey ####
# First we recode as nulliparous, infant (0-4 yrs) and sub-adult (5-9 yrs)
d_fem$class_offspring<-ifelse(d_fem$age_offspring==-1,"nul",
                              ifelse(d_fem$age_offspring>4,"sub","inf"))
# Second we organize in a dataframe (f_Oage2) the number of cases for each combiunation of age of ossfpring and prey
f_Oage<-as.data.frame(matrix(NA,nrow=3,ncol=3))
f_Oage[1,1]<-length(d_fem$class_offspring[d_fem$class_offspring=="inf" & d_fem$outcome==1])
f_Oage[2,1]<-length(d_fem$class_offspring[d_fem$class_offspring=="inf" & d_fem$outcome==2])
f_Oage[3,1]<-length(d_fem$class_offspring[d_fem$class_offspring=="inf" & d_fem$outcome==3])
f_Oage[1,2]<-length(d_fem$class_offspring[d_fem$class_offspring=="sub" & d_fem$outcome==1])
f_Oage[2,2]<-length(d_fem$class_offspring[d_fem$class_offspring=="sub" & d_fem$outcome==2])
f_Oage[3,2]<-length(d_fem$class_offspring[d_fem$class_offspring=="sub" & d_fem$outcome==3])
f_Oage[1,3]<-length(d_fem$class_offspring[d_fem$class_offspring=="nul" & d_fem$outcome==1])
f_Oage[2,3]<-length(d_fem$class_offspring[d_fem$class_offspring=="nul" & d_fem$outcome==2])
f_Oage[3,3]<-length(d_fem$class_offspring[d_fem$class_offspring=="nul" & d_fem$outcome==3])
colnames(f_Oage)<-c("Infant","Sub-adult","Nulliparous")

# Test if females with infants hunts primates less often than nulliparous
binom.test(14,sum(f_Oage[1,]),12/sum(f_Oage[3,]),alternative="less")
# Test if females with juveiles hunts primates less often than nulliparous
binom.test(4,sum(f_Oage[2,]),12/sum(f_Oage[3,]),alternative="less")

#### 4.2) MODEL: Effect of hunter's age on probability female hunting ####
m_fm_age<-rstan::stan(data=data2,"Stan_code/bernoulli_age.stan",cores=4,chains=4)
saveRDS(m_fm_age,"Results/m_p_female_age.rds")
summary(m_fm_age,pars=c("mean_p","a","b1"))$summary[,c(1,3,4,8:10)] 

#### 5) Inter-community differences #####
#### 5.1) MODEL: Intercommunity differences in prey selection ####
# null
comm_null<-rstan::stan(data=data_overl,"Stan_code/multinomial_null.stan",cores=4,chains=4)
saveRDS(comm_null,"Results/intercommunity_null.rds")
# Full
comm_full<-rstan::stan(data=data_overl,"Stan_code/multinomial_full.stan",cores=4,chains=4)
saveRDS(comm_full,"Results/intercommunity_full.rds")

# Compare models
loo_m0<-loo(comm_null)
loo_m1<-loo(comm_full)
loo_compare(loo_m0,loo_m1)
# The difference is slim (=little risk of over-fitting), as we are interested in ecological factors we keep the full model
summary(comm_full,pars=c("a","b1","b2","b3","pred_p_E","pred_p_W","pred_p"))$summary[,c(1,3,4,8:10)]
write.csv(summary(comm_full,pars=c("a","b1","b2","b3","pred_p_E","pred_p_W","pred_p"))$summary[,c(1,3,4,8:10)],
          "Results/results_intercommunity.csv")

#### 6) Figures #####
#### 6.1) Fig.1 ####
# Fig. 1a, 1b, 1c
source("R_code/Fig_1.R")
# Fig. 1d
source("R_code/Fig_1_d.R")
# Fig. 1e
source("R_code/Fig_1_e.R")
#### 6.1) Fig.2 ####
# Fig 2a
source("R_code/Fig_2_a.R")
# Fig. 2b, 2c
source("R_code/Fig_2_b.R")

