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
  int N;                                    // data points (n=173) - areas of home range overalp only
  int K;                                    // number of outcomes: 1=duiker; 2=primate; 3=other hunted fauna; 4=collected fauna
  array[N] int outcome;                     // prey type = response
  array[N] int community;                   // community
  
  int<lower=0> N_missing_party;
  array[N_missing_party] int party_missing; // position of missing AME value in the AME vector

}

parameters{

  vector[K-1] a_raw;  // intercept
  array[K,2] real b1; // random intercept, varying by prey and community

}

transformed parameters{
  vector[K] a; // intercepts, transformed

  a = append_row(-sum(a_raw), a_raw); // sum-to-zero constaint on intercept 
 
}

model{
  vector[K] p; // probability of each outcome (softmax link)
  vector[K] s; // untransformed probability of outcome
  
// priors
  a  ~ normal(0,3);
  for (k in 1:K){
    b1[k,] ~ normal(0,3);
  }


  for(i in 1:N){
    for (k in 1:K){
      s[k] = a[k] + b1[k,community[i]] ;
    }
    
    p = softmax(s);
      
    outcome[i] ~ categorical(p);
  }
}

generated quantities{
  vector [K] pred_s_E; // predicted untransformed probabilities
  vector [K] pred_p_E; // predicted probabilities
  vector [K] pred_s_W; // predicted untransformed probabilities
  vector [K] pred_p_W; // predicted probabilities
  vector [K] pred_s;
  vector [K] pred_p;
  vector [N] log_lik;
  
  for(i in 1:N){
    for (k in 1:K){
      pred_s_E[k] = a[k] + b1[k,1] ;
      pred_s_W[k] = a[k] + b1[k,2] ;
      pred_s[k]   = a[k] + b1[k,community[i]]; 
    }
  }
  
  
  pred_p   = softmax(pred_s);
  pred_p_E = softmax(pred_s_E);
  pred_p_W = softmax(pred_s_W);
  
  for (i in 1:N){
    log_lik[i] = categorical_lpmf(outcome[i] | pred_p);
  }

}

