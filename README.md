# Females shape hunting of vertebrates in wild bonobos
Hohmann, G., Bessone, M., Balduccio, N., Decina, F., Deville, T., Pashchevskaya, S., Soliday, V., Stewart, K., & Fruth, B.
### _Current Biology_ (2026)

## Abstract
Hunting and meat consumption are widely considered key drivers of human evolution, and hypotheses about their origins draw on comparisons with our closest living relatives, chimpanzees and bonobos. These comparisons typically set up a behavioral dichotomy in which chimpanzees are characterized by cooperative hunting of arboreal
primates by male-dominated parties whereas bonobo hunts are thought to involve the opportunistic targeting of terrestrial ungulates, primarily by individual females. Observations from two habituated bonobo communities at LuiKotale covering ten years challenge this dichotomy. LuiKotale bonobos hunted both terrestrial ungulates (42%)
and arboreal primates (43% of vertebrate prey) with red colobus monkeys comprising the majority of primate prey (77%). Males and females hunted arboreal primates at similar rates and females accounted for most non-primate captures. Female age affected hunting frequency of primates and ungulates, the former being biased to
younger and the latter to older females. The prominent role of female bonobos in hunting supports predictions that relate hunting activity to inter-sexual dominance relations rather than risk aversion, with the dominant sex being more active. Comparing data from neighboring communities revealed differences and suggests that
social and environmental parameters affect prey choice by each community in different ways. Together, these findings challenge the assumption that chimpanzee-like, male biased hunting represents the ancestral condition. They highlight the contribution of females to obtaining vertebrate prey, call for a reassessment of the role of females in
hunting and meat sharing, and, by extension, the framing of models of early hominin subsistence and social organization.

## 1) Content
This repository includes the data and code needed to replicate the results and figures described in the manuscript:.
The repository includes 13 files organised in 4 subfolders (Table 1).

*Table 1. Folder structure and description of files needed to reproduce the results presented in the manuscript*

Folder name| Subfolder name | File name | Description |
| ----------- | ----------- | --------- | ----------- |
|~|~             |Run_analyses.R|R code to run all analyses and draw plots |
|~|Data          |hunting_data.csv| File containing data used in the analyses |
|~|R_code        |prepare_data.R| Pre-process and orfanize data for analyses |
|~|R_code        |Fig_1.R| Draws panels A, B and C in Fig, 1 |
|~|R_code        |Fig_1_d.R| Draws panel D in Fig. 1 |
|~|R_code        |Fig_1_e.R| Draws panel E in Fig. 1 |
|~|R_code        |Fig_2_a.R| Draws panels A in Fig. 2 |
|~|R_code        |Fig_2_b.R| Draws panels B and C in Fig. 2 |
|~|Stan_code     |bernoulli_null.stan| Stan model (null) investigating probability of female hunting  |
|~|Stan_code     |bernoulli_full.stan| Stan model (full) investigating probability of female hunting  |
|~|Stan_code     |bernoulli_age.stan| Stan model investigating the effect of age on the probability of female hunting  |
|~|Stan_code     |multinomial_null.stan| Stan model (null) investigating inter-community differences in hunting |
|~|Stan_code     |multinomial_full.stan| Stan model (full) investigating inter-community differences in hunting |
|~|Results       |~| Empty forlder to store model results |

## 2) Instructions
- The code runs in R (ver. 4.3.1) and requires the R packages rstan (ver. 2.32.7) and loo (ver. 2.5.1). A detailed description of the steps needed to install rstan can be found here : https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started. 
- To run the analyses, open the script “Run_analyses.R” in R, making sure to i) set up the correct working directory ii) replicate the same folder structure provided in this repository. 
- The script “Run_analyses.R” provides code for 1) Import and process the data, 2) run analyses on bonobo hunting behaviuor, 3) run analyses on bonobo female hunting, 4) run analyses on female status and offspring age in relation to hunting, 5) run analyses on inter-community differences, 6) draw plots presented in Fig. 1 and 2 (depends on running previous codes).
