# Databases and code for l<sub>p</sub> functional comparison
This repository contains all databases, taken from UCI repository, and specially developed code used in the paper Curse of dimensionality and metrics comparison (link will be added after publication).
  
## Structure of repository
Folder databases contains all 25 databases used in this study. All databases were dounloaded fro UCI repositories and transformed into matlab format. 

Main folder contains main script "MainTest" and several used functions. Script Main test can be startsed for diffrent purposes which specified by variable <b>what</b>. Some subscripts can be further customised by commetaries (see corresponding fragments, which are started from <b>case </b>.

%what is parameter to control process - use value

% 0 to generate the new dataset and save it

% 1 to load data from file

% 2 to calculate maximal and minimal distances for one dataset

% 3 to calculate table with min, max, mean and std without normalisation.

% 4, 5, 6 to calculate res files for different normalisations. This

%   calculation requires huge time. Code is optimised to use parallel

%   calculation and was tested on usual laptop and computational cluster.

% 7 to convert calculated Res files to MS Excel for readability

% 8 to apply Friedman test and Nomenyi post hoc test.

% 9 to apply Wilcoxon signed rank test to compare metrics

% 10 to apply Wilcoxon signed rank test to compare preprocessing

% 11 Reproduction of Table 2

% 12 Creation figures for table 2 explanation

% 13 Draw figure with unit circles

Main folder also contains several mat files with used data
allNames.mat contains lists of 25 database names and aliases and names of classifier accurasy measures
bdNames.mat contains list 37 tasks
data.mat contains used set of 10,000 200 dimensional points.
dataTab2Fig.mat contains list of 10 sets per 10 2D points for figure 2.   
diffAndRelContr.mat contains results of case 2
distribs.mat contains results of distributionComparison function
metrNames.mat contains list of norms and quasinorms
NomenyiCV.mat contains table of critical values for Nomenyi distribution

For simplicity we also includes xlsx files formed by MainTest script

  
## Acknowledgements

Supported by the University of Leicester (UK), the Ministry of Education and Science of the Russian Federation, project № 14.Y26.31.0022

