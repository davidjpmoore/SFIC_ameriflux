#########################################################################################
##### Read BADM data from Danielle and You-Wei                                      #####
##### Author: Dave Moore                                                            #####
##### Date: 12/16/2019                                                              #####
#####                                                                               #####
#########################################################################################
library(tidyverse)
library(readr)
#get list of all files in folder
files <- list.files(path = "data/BADM/", pattern = "*.csv", full.names = T)
Name1= sub('.*GRP_', '',files)
NameDFs = sub("\\..*", "", Name1)
# tbl <- sapply(files, read_csv, simplify=FALSE) %>% 
#   bind_rows(.id = "id")
for (i in 1:length(files)) assign(NameDFs[i], read.csv(files[i]))


LAI = LAI %>%
  group_by(SITE_ID) %>%
  mutate (GoodDate = as.Date(LAI_DATE, format="%Y%m%d")) %>%
  mutate(meanLAI=mean(LAI_TOT), N_LAI=n(), maxLAI=max(LAI_TOT))
ggplot(data =LAI)+
geom_point(mapping= aes( LAI_TOT, SITE_ID))


ggplot(data =LAI)+
  geom_point(mapping= aes(as.Date(LAI_DATE), LAI_TOT))
