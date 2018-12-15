# Databases and code for l<sub>p</sub> functional comparison
This repository contains all databases, taken from UCI repository, and specially developed code used in the paper Curse of dimensionality and metrics comparison (link will be added after publication).
  
## Structure of repository
Folder databases contains all 25 databases used in this study. All databases were dounloaded fro UCI repositories and transformed into matlab format. 

Main folder contains main script "MainTest" and several used functions. Script Main test can be startsed for diffrent purposes which specified by variable <b>what</b>. Some subscripts can be further customised by commetaries (see corresponding fragments, which are started from <b>case </b>.

%what is parameter to control process - use value <br>
% 0 to generate the new dataset and save it<br>
% 1 to load data from file<br>
% 2 to calculate maximal and minimal distances for one dataset<br>
% 3 to calculate table with min, max, mean and std without normalisation.<br>
% 4, 5, 6 to calculate res files for different normalisations. This<br>
%   calculation requires huge time. Code is optimised to use parallel<br>
%   calculation and was tested on usual laptop and computational cluster.<br>
% 7 to convert calculated Res files to MS Excel for readability<br>
% 8 to apply Friedman test and Nomenyi post hoc test.<br>
% 9 to apply Wilcoxon signed rank test to compare metrics<br>
% 10 to apply Wilcoxon signed rank test to compare preprocessing<br>
% 11 Reproduction of Table 2<br>
% 12 Creation figures for table 2 explanation<br>
% 13 Draw figure with unit circles<br>

Main folder also contains several mat files with used data

allNames.mat contains lists of 25 database names and aliases and names of classifier accurasy measures<br>
bdNames.mat contains list 37 tasks<br>
data.mat contains used set of 10,000 200 dimensional points.<br>
dataTab2Fig.mat contains list of 10 sets per 10 2D points for figure 2.<br>
diffAndRelContr.mat contains results of case 2<br>
distribs.mat contains results of distributionComparison function<br>
metrNames.mat contains list of norms and quasinorms<br>
NomenyiCV.mat contains table of critical values for Nomenyi distribution<br>

For simplicity we also includes xlsx files formed by MainTest script

  
## Acknowledgements

Supported by the University of Leicester (UK), the Ministry of Education and Science of the Russian Federation, project № 14.Y26.31.0022

