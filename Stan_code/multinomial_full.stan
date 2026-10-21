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
  int N;                       // data points (n=173) - areas of home range overalp only
  int K;                       // number of outcomes: 1=duiker; 2=primate; 3=other hunted fauna; 4=collected fauna
  array[N] int outcome;        // prey type = response
  vector<upper=1> [N] p_males; // Variable 1, proportion males
  vector [N] p_size;           // Variable 2, party size - adults only
  vector<upper=1> [N] f_cover; // Varaible 3, forest cover
  array[N] int community;
  
  int<lower=0> N_missing_party; // number of data-points with missing information on party compositon
  array[N_missing_party] int party_missing; // position of of data-points with missing information on party compositon

}

parameters{
  vector[K-1] a_raw;    // intercepts, varying by community
// slopes  
  array[K,2] real b1; // slope varying by prey and community: Variable 1
  array[K,2] real b2; // slope varying by prey and community: Variable 2
  array[K,2] real b3; // slope varying by prey and community: Variable 3
  
  vector<lower=0> [N_missing_party] p_size_i;  // Imputation - vector of imputed values
  vector<lower=0> [N_missing_party] p_males_i; // Imputation - vector of imputed values

  array[3] real nu;                            // Imputation - mean of imputed values
  array[3] real<lower=0> psi;                  // Imputation - standard deviation of imputed values
}

transformed parameters{
  vector[K] a; // intercepts, transformed
  vector [N] p_size_imputed;
  vector [N] p_males_imputed;
  
  p_size_imputed  = impute_missing(party_missing,to_vector(p_size),p_size_i);
  p_males_imputed = impute_missing(party_missing,to_vector(p_males),p_males_i); 
 
  a = append_row(-sum(a_raw), a_raw); // sum-to-zero constaint on intercept 
 
}

model{
  vector[K] p; // probability of each outcome (softmax link)
  vector[K] s; // untronsoformed probaiblity of outcome
  
// priors
  a  ~ normal(0,3);
  for (k in 1:K){
    b1[k,] ~ normal(0,1);
    b2[k,] ~ normal(0,1);
    b3[k,] ~ normal(0,1);
  }
  
  
  nu ~ normal(0,1);
  psi ~ exponential(1);
  p_size_imputed ~ normal(nu[1], psi[1]);
  p_males_imputed ~ normal(nu[2], psi[2]);
 
  for(i in 1:N){
    for (k in 1:K){
      s[k] = a[k] + b1[k,community[i]] * p_males_imputed[i] + b2[k,community[i]] * p_size_imputed[i] + b3[k,community[i]] * f_cover[i] ;
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
      pred_s_E[k] = a[k] + b1[k,1] * p_males_imputed[i] + b2[k,1] * p_size_imputed[i] + b3[k,1] * f_cover[i] ;
      pred_s_W[k] = a[k] + b1[k,2] * p_males_imputed[i] + b2[k,2] * p_size_imputed[i] + b3[k,2] * f_cover[i] ;
      pred_s[k]   = a[k] + b1[k,community[i]] * p_males_imputed[i] + b2[k,community[i]] * p_size_imputed[i] + b3[k,community[i]] * f_cover[i] ;
    }
  }
  
  
  pred_p   = softmax(pred_s);
  pred_p_E = softmax(pred_s_E);
  pred_p_W = softmax(pred_s_W);
  
  for (i in 1:N){
    log_lik[i] = categorical_lpmf(outcome[i] | pred_p);
  }

}

