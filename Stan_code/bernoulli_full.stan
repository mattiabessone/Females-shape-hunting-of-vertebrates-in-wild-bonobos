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
  int N; // data points
  int K; // number of outcomes: 1=duiker; 2=primate; 3=other hunted fauna
  array[N] int outcome;   // prey
  array[N] int sex;       // sex of hunter
  array[N] int community; // community of hunter
  vector<upper=1> [N] p_males; // Variable 1, e.g. proportion males
  vector [N] p_size; // Variable 2, e.g. party size - adults only
  vector [N] p_juven;
  
  int<lower=0> N_missing_party;
  array[N_missing_party] int party_missing;
}

parameters{
  array[K,2] real a; // probability  hunt by females by prey and community
  array[K,2] real b1; // probability  hunt by females by prey and community
  array[K,2] real b2; // probability  hunt by females by prey and community
  array[K,2] real b3; // probability  hunt by females by prey and community
  
  vector<lower=0> [N_missing_party] p_size_i; // AME imputation - vector of imputed values
  vector<lower=0> [N_missing_party] p_males_i;// AME imputation - vector of imputed values
  vector<lower=0> [N_missing_party] p_juven_i;// AME imputation - vector of imputed values
  array[3] real nu;                                // AME imputation - mean of imputed values
  array[3] real<lower=0> psi;                      // AME imputation - standard deviation of imputed values
}

transformed parameters{
  vector[N] p;
  vector [N] p_size_imputed;
  vector [N] p_males_imputed;
  vector [N] p_juven_imputed;
 
  p_size_imputed  = impute_missing(party_missing,to_vector(p_size),p_size_i);
  p_males_imputed = impute_missing(party_missing,to_vector(p_males),p_males_i);
  p_juven_imputed = impute_missing(party_missing,to_vector(p_juven),p_juven_i);

  
  for (i in 1:N){
    p[i] = a[outcome[i],community[i]] + b1[outcome[i],community[i]] * p_males_imputed[i] + b2[outcome[i],community[i]] * p_size_imputed[i] + b3[outcome[i],community[i]] * p_juven_imputed[i];
  }
}

model{
// priors
  for (k in 1:K){
    a[k,] ~ normal(0,1.2);
    b1[k,] ~ normal(0,0.5);
    b2[k,] ~ normal(0,0.5);
    b3[k,] ~ normal(0,0.5);
   }

  nu ~ normal(0,1);
  psi ~ exponential(1);
  p_size_imputed ~ normal(nu[1], psi[1]);
  p_males_imputed ~ normal(nu[2], psi[2]);
  p_juven_imputed ~ normal(nu[3], psi[3]);
  
  for(i in 1:N){
    
    sex[i] ~ bernoulli_logit(p[i]);
    
  }
}

generated quantities{
  matrix [N,2] pred_p;
  vector [K] mean_p;
  vector [N] log_lik;
  
  
  for(i in 1:N){
   
    pred_p[i,1] = a[outcome[i],1] + b1[outcome[i],1] * p_males_imputed[i] + b2[outcome[i],1] * p_size_imputed[i] + b3[outcome[i],1] * p_juven_imputed[i];;
    pred_p[i,2] = a[outcome[i],2] + b1[outcome[i],2] * p_males_imputed[i] + b2[outcome[i],2] * p_size_imputed[i] + b3[outcome[i],2] * p_juven_imputed[i];;
  
  }
  
  for(k in 1:K){
   
    mean_p[1]   = mean(pred_p[1:67,]);
    mean_p[2]   = mean(pred_p[68:124,]);
    mean_p[3]   = mean(pred_p[125:N,]);
  
  }
  
  for (i in 1:N){
    for(k in 1:K){
      log_lik[i] = bernoulli_logit_lpmf(sex[i] | pred_p[outcome[i],community[i]]);
    }
  }

}

