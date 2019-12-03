####
#### Read in GPP estimates for Ameriflux sites 
#### Data prepped by Matt Roby 
####

library(dplyr)

GPPSites=read.csv(file='./data/Avg_GPP.csv', header = T )


headers = read.csv(file='./data/Avg_GPP.csv', skip = 0, header = F, nrows = 1, as.is = T)
GPPSites = read.csv(file, skip = 2, header = F)
colnames(GPPSites)= headers

StateFactors = read.csv(file = './data/statefactors.csv')

hist (GPPSites$GPPday)