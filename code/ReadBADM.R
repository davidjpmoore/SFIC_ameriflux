#########################################################################################
##### Read BADM data from Danielle and You-Wei                                      #####
##### Author: Dave Moore                                                            #####
##### Date: 12/16/2019                                                              #####
#####                                                                               #####
#########################################################################################
library(tidyverse)

REFBADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_REFERENCE_PAPER.csv', header = T )
SITE_DESC_BADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_SITE_DESC.csv', header = T )
SITE_TEAM_BADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_TEAM_MEMBER.csv', header = T )
RES_Top_BADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_RESEARCH_TOPIC.csv', header = T )

FLUX_Meas_BADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_FLUX_MEASUREMENTS.csv', header = T )

LAIBADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_LAI.csv', header = T )
SWCBADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_SWC.csv', header = T )
HEIGHTC_BADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_HEIGHTC.csv', header = T )
BIOMASS_CHEM_BADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_BIOMASS_CHEM.csv', header = T )
AG_BIOMASS_TREE_BADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_AG_BIOMASS_TREE.csv', header = T )

SOIL_CHEM_BADM=read.csv(file='./data/BADM/2019-12-12-09-35-54-GRP_SOIL_CHEM.csv', header = T )



plot(AG_BIOMASS_TREE_BADM$SITE_ID, AG_BIOMASS_TREE_BADM$AG_BIOMASS_COMMENT)

library(readr)
 
#get list of all files in folder
files <- list.files(path = "data/BADM/", pattern = "*.csv", full.names = T)
tbl <- sapply(files, read_csv, simplify=FALSE) %>% 
  bind_rows(.id = "id")

for (i in 1:length(files)) assign(files[i], read.csv(files[i]))

