# Open libraries
library(rstan)
library(loo)
#### 1) Bring in data and organize for analysis ####
d_fauna<-read.csv("Data/hunting_data.csv")
# Create a column with different outcomes for multinomial model
d_fauna$outcome<-3 # other hunted fauna outcome = 3
d_fauna$prey_order[is.na(d_fauna$prey_order)] <- "Other" # Avoids issues with NAs
d_fauna$outcome<-ifelse(d_fauna$prey_order=="Artiodactyla",1,d_fauna$outcome) # duikers = 1
d_fauna$outcome<-ifelse(d_fauna$prey_order=="Primates",2,d_fauna$outcome) #primates = 2
table(d_fauna$outcome)
# Categorize years as factors
d_fauna$year<-as.factor(d_fauna$year)
#### Wrap data for multinomial model ####
# create proportion of adult males
d_fauna$prop_males<-d_fauna$no_adult_M/d_fauna$adult_part
# and proportion of females with infants
d_fauna$prop_infant<-d_fauna$no_infants/d_fauna$no_adult_F
# We assume all prop > 1 are = 1
d_fauna$prop_infant<-ifelse(d_fauna$prop_infant>1,1,d_fauna$prop_infant)

#### 2) Subset data ####
d_hunt<-subset(d_fauna,d_fauna$ID_for_age!="UNK")
d_fem<-subset(d_fauna,d_fauna$age>0 & d_fauna$sex==1)

#### 3) Wrap data for Stan models ####
d_fauna1<-d_fauna
# Define location of missing part information
party_missing<-which(is.na(d_fauna1$prop_males))
# And number of missing data points
N_missing_party<-nlevels(as.factor(party_missing))
# Scale adult party size
d_fauna1$adult_partS<-scale(d_fauna1$adult_part)
d_fauna1$no_adult_M<-scale(d_fauna1$no_adult_M)
d_fauna1$no_adult_F<-scale(d_fauna1$no_adult_F)
# Assign a dummy (negative) value to missing party size and proportion of males
d_fauna1$adult_partS[is.na(d_fauna1$adult_part)] <- -10
d_fauna1$prop_males[is.na(d_fauna1$prop_males)] <- -10
d_fauna1$no_adult_M [is.na(d_fauna1$no_adult_M)] <- -10
d_fauna1$no_adult_F [is.na(d_fauna1$no_adult_F)] <- -10
d_fauna1$prop_infant [is.na(d_fauna1$prop_infant)] <- -10

data<-list(N=nrow(d_fauna1),K=nlevels(as.factor(d_fauna1$outcome)),N_missing_party=N_missing_party,
           outcome=d_fauna1$outcome,community=as.integer(as.factor(d_fauna1$community)),
           p_males=d_fauna1$prop_males,p_size=as.vector(d_fauna1$adult_partS),year=as.integer(d_fauna$year),
           f_cover=d_fauna1$cover_mean,duiker_a=as.vector(scale(d_fauna1$duikers_ER)), primate_a=as.vector(scale(d_fauna1$primates_E)),
           party_missing=party_missing, n_males=as.vector(d_fauna1$no_adult_M), n_females=as.vector(d_fauna1$no_adult_F), p_juvenil=d_fauna1$prop_infant)

#### Model proportion female hunting 
d_fauna2<-subset(d_fauna,d_fauna$sex>-1 & d_fauna$age>0)
# Define location of missing part information
party_missing<-which(is.na(d_fauna2$prop_males))
# And number of missing data points
N_missing_party<-nlevels(as.factor(party_missing))
# Scale adult party size
d_fauna2$adult_partS<-as.vector(scale(d_fauna2$adult_part))
# Scale age
#d_fauna2$age<-as.vector(scale(d_fauna2$age))
# Assign a dummy (negative) value to missing party size and proportion of males
d_fauna2$prop_males[is.na(d_fauna2$prop_males)] <- -10
d_fauna2$adult_partS[is.na(d_fauna2$adult_part)] <- -10
d_fauna2$prop_infant[is.na(d_fauna2$prop_infant)] <- -10

d_fauna2<-d_fauna2[order(d_fauna2$outcome),]

data2<-list(N=nrow(d_fauna2),K=3,sex=d_fauna2$sex,age=d_fauna2$age,risk=d_fauna2$risk,year=as.integer(d_fauna$year),
            outcome=d_fauna2$outcome,community=as.integer(as.factor(d_fauna2$community)),
            p_males=d_fauna2$prop_males,p_size=d_fauna2$adult_partS,p_juven=d_fauna2$prop_infant,
            N_missing_party=N_missing_party,party_missing=party_missing)

#### Subset data - areas of overlap ####
d_fauna1_overl<-d_fauna1[d_fauna1$overlap==1,]
# Define location of missing part information
party_missing<-which(d_fauna1_overl$prop_males==-10)
# And number of missing data points
N_missing_party<-nlevels(as.factor(party_missing))

data_overl<-list(N=nrow(d_fauna1_overl),K=nlevels(as.factor(d_fauna1_overl$outcome)),N_missing_party=N_missing_party,year=as.integer(d_fauna$year),
               outcome=d_fauna1_overl$outcome,community=as.integer(as.factor(d_fauna1_overl$community)),
               p_males=d_fauna1_overl$prop_males,p_size=as.vector(d_fauna1_overl$adult_partS),
               f_cover=d_fauna1_overl$cover_mean,duiker_a=as.vector(scale(d_fauna1_overl$duikers_ER)), primate_a=as.vector(scale(d_fauna1_overl$primates_E)),
               party_missing=party_missing, n_males=as.vector(d_fauna1_overl$no_adult_M), n_females=as.vector(d_fauna1_overl$no_adult_F), p_juvenil=d_fauna1_overl$prop_infant)

# Model female hunting
d_fauna2_overl<-d_fauna2[d_fauna2$overlap==1,]
# Define location of missing part information
party_missing<-which(d_fauna2_overl$prop_males==-10)
# And number of missing data points
N_missing_party<-nlevels(as.factor(party_missing))

data2_overl<-list(N=nrow(d_fauna2_overl),K=3,sex=d_fauna2_overl$sex,age=d_fauna2_overl$age,risk=d_fauna2_overl$risk,year=as.integer(d_fauna$year),
                outcome=d_fauna2_overl$outcome,community=as.integer(as.factor(d_fauna2_overl$community)),
                p_males=d_fauna2_overl$prop_males,p_size=d_fauna2_overl$adult_partS,p_juven=d_fauna2_overl$prop_infant,
                N_missing_party=N_missing_party,party_missing=party_missing)



#### Remove dataframe (except for d_fauna - needed for descriptives) - only lists are needed ##
rm(d_fauna1,d_fauna2,d_fauna1_overl,d_fauna2_overl)

