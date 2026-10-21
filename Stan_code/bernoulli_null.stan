data{
  int N; // data points
  int K; // number of outcomes: 1=duiker; 2=primate; 3=other hunted fauna
  array[N] int outcome; // prey
  array[N] int sex; // sex of hunter
  array[N] int community; // community of hunter
}

parameters{
 array[K,2] real p; // probability  hunt by females by prey and community
}

model{
// priors
  for (k in 1:K){
    p[k,] ~ normal(0,1.2);
   }

  
  for(i in 1:N){
    
    sex[i] ~ bernoulli_logit(p[outcome[i],community[i]]);
    
  }
}

generated quantities{
  vector [K] pred_p;
  vector [N] log_lik;
  
  
  for(k in 1:K){
   
    pred_p[k]   = mean(p[k,]);
  
  }
  
  for (i in 1:N){
    for(k in 1:K){
      log_lik[i] = bernoulli_logit_lpmf(sex[i] | p[outcome[i],community[i]]);
    }
  }

}

