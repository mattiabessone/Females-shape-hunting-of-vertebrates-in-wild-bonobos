functions{
  // Function for imputation of missing data
  vector impute_missing(array[] int indexes, vector observed, vector missing){
    int N = dims(observed)[1];
    int N_missing = dims(missing)[1];
    vector[N] imputed;
    imputed = observed;
    for (i in 1:N_missing)
      imputed[indexes[i]] = missing[i];
    return imputed;
  }
}

data{
  int N;                  // data points
  int K;                  // number of outcomes: 1=duiker; 2=primate; 3=other hunted fauna
  array[N] int outcome;   // prey
  array[N] int sex;       // sex of hunter
  array[N] int community; // community of hunter
  array[N] real age;      // age of hunter
  
}

parameters{
  array[K] real a;        // random intercept for prey type 
  array[K] real b1;       // random slope for hunter age by prey type 
}

transformed parameters{
  vector[N] p;
  
  for (i in 1:N){
    p[i] = a[outcome[i]] + b1[outcome[i]] * age[i];
  }
}

model{
// priors
  a  ~ normal(0,1.2);
  b1 ~ normal(0,0.5);

  for(i in 1:N){
    
    sex[i] ~ bernoulli_logit(p[i]);
    
  }
}

generated quantities{
  vector [N] pred_p;
  vector [K] mean_p;
  vector [N] log_lik;
  
  
  for(i in 1:N){
   
    pred_p[i] = a[outcome[i]] + b1[outcome[i]] * age[i];;

  }
  
  for(k in 1:K){
   
    mean_p[1]   = mean(pred_p[1:67]);
    mean_p[2]   = mean(pred_p[68:123]);
    mean_p[3]   = mean(pred_p[124:N]);
  
  }

  
  for (i in 1:N){
    for(k in 1:K){
      log_lik[i] = bernoulli_logit_lpmf(sex[i] | p[outcome[i]]);
    }
  }

}

