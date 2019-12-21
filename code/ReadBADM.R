#########################################################################################
##### Read BADM data from Danielle and You-Wei                                      #####
##### Author: Dave Moore                                                            #####
##### Date: 12/16/2019                                                              #####
#####                                                                               #####
#########################################################################################
library(tidyverse)
library(readr)
library(data.table)

#get list of all files in folder
files <- list.files(path = "data/BADM/", pattern = "*.csv", full.names = T)
Name1= sub('.*GRP_', '',files)
NameDFs = sub("\\..*", "", Name1)
# tbl <- sapply(files, read_csv, simplify=FALSE) %>% 
#   bind_rows(.id = "id")
for (i in 1:length(files)) assign(NameDFs[i], read.csv(files[i]))

LAI = LAI %>%
  group_by(SITE_ID) %>%
  mutate (Year = substr(LAI_DATE,1,4), Month=substr(LAI_DATE,5,6), Day = substr(LAI_DATE,7,8)) %>%
  mutate(meanLAI=mean(LAI_TOT), N_LAI=n(), maxLAI=max(LAI_TOT))

plot(AG_BIOMASS_CROP$SITE_ID)

### ACTION
#Create summary table with 1) number of observations for each site & 2) mean/median interval between observations
#Rank sites by number of observations

LAI_count = LAI%>% count(SITE_ID) %>% filter(n>1) 
AG_BIOMASS_CROP_count = AG_BIOMASS_CROP %>% count(SITE_ID) %>% filter(n>1) 
AG_BIOMASS_GRASS_count = AG_BIOMASS_GRASS %>% count(SITE_ID) %>% filter(n>1) 
AG_BIOMASS_OTHER_count = AG_BIOMASS_OTHER %>% count(SITE_ID) %>% filter(n>1) 
AG_BIOMASS_SHRUB_count = AG_BIOMASS_SHRUB %>% count(SITE_ID) %>% filter(n>1) 
AG_BIOMASS_TREE_count = AG_BIOMASS_TREE %>% count(SITE_ID) %>% filter(n>1) 
AG_LIT_BIOMASS_count = AG_LIT_BIOMASS %>% count(SITE_ID) %>% filter(n>1) 


#LAI TESTS
LAI_count = LAI %>%
  filter(!is.na(LAI_TOT)) %>%
  group_by(SITE_ID) %>%
  summarize(N_LAI = n(), 
            mean_LAI = mean(LAI_TOT),
            std_dev = sd(LAI_TOT),
            max_LAI = max(LAI_TOT)) 

#AB_Biomass
#CROP
AG_BIOMASS_CROP_count = AG_BIOMASS_CROP  %>%
  filter(!is.na(AG_BIOMASS_CROP)) %>%
  group_by(SITE_ID) %>%
  summarize(N_AGB_CROP = n(), 
            mean_AGB_crop = mean(AG_BIOMASS_CROP),
            std_dev_AGB_crop = sd(AG_BIOMASS_CROP),
            max_AGB_crop = max(AG_BIOMASS_CROP)) 


#GRASS
AG_BIOMASS_GRASS_count = AG_BIOMASS_GRASS  %>%
  filter(!is.na(AG_BIOMASS_GRASS)) %>%
  group_by(SITE_ID) %>%
  summarize(N_AGB_GRASS = n(), 
            mean_AGB_GRASS = mean(AG_BIOMASS_GRASS),
            std_dev_AGB_GRASS = sd(AG_BIOMASS_GRASS),
            max_AGB_GRASS = max(AG_BIOMASS_GRASS)) 

#OTHER
AG_BIOMASS_OTHER_count = AG_BIOMASS_OTHER  %>%
  filter(!is.na(AG_BIOMASS_OTHER)) %>%
  group_by(SITE_ID) %>%
  summarize(N_AGB_OTHER = n(), 
            mean_AGB_OTHER = mean(AG_BIOMASS_OTHER),
            std_dev_AGB_OTHER = sd(AG_BIOMASS_OTHER),
            max_AGB_OTHER = max(AG_BIOMASS_OTHER)) 




#SHRUB
AG_BIOMASS_SHRUB_count = AG_BIOMASS_SHRUB  %>%
  filter(!is.na(AG_BIOMASS_SHRUB)) %>%
  group_by(SITE_ID) %>%
  summarize(N_AGB_SHRUB = n(), 
            mean_AGB_SHRUB = mean(AG_BIOMASS_SHRUB),
            std_dev_AGB_SHRUB = sd(AG_BIOMASS_SHRUB),
            max_AGB_SHRUB = max(AG_BIOMASS_SHRUB)) 



#TREE
AG_BIOMASS_TREE_count = AG_BIOMASS_TREE  %>%
  filter(!is.na(AG_BIOMASS_TREE)) %>%
  group_by(SITE_ID) %>%
  summarize(N_AGB_TREE = n(), 
            mean_AGB_TREE = mean(AG_BIOMASS_TREE),
            std_dev_AGB_TREE = sd(AG_BIOMASS_TREE),
            max_AGB_TREE = max(AG_BIOMASS_TREE)) 

#LITTER
AG_LIT_BIOMASS_count = AG_LIT_BIOMASS  %>%
  filter(!is.na(AG_LIT_BIOMASS)) %>%
  group_by(SITE_ID) %>%
  summarize(N_LIT_BIOMASS = n(), 
            mean_LIT_BIOMASS = mean(AG_LIT_BIOMASS),
            std_dev_LIT_BIOMASS = sd(AG_LIT_BIOMASS),
            max_LIT_BIOMASS = max(AG_LIT_BIOMASS)) 

AG_LIT_CHEM_count = AG_LIT_CHEM  %>%
  filter(!is.na(AG_LIT_N)) %>%
  group_by(SITE_ID) %>%
  summarize(N_LIT_C = n(), 
            mean_LIT_C = mean(AG_LIT_C),
            mean_LIT_N = mean(AG_LIT_N),
            std_dev_LIT_C = sd(AG_LIT_C),
            std_dev_LIT_N = sd(AG_LIT_N),
            max_LIT_C = max(AG_LIT_C),
            max_LIT_N = max(AG_LIT_N),
            max_LIT_CN_RATIO = max(AG_LIT_CN_RATIO)) 



#Summary plot by site
BySite = ggplot(AG_LIT_CHEM_count, aes(mean_LIT_C, SITE_ID))
BySite + geom_point(size=2, shape=1, fill="black", colour="black", stroke=1.2) + theme_bw()

plot(LAI_count$SITE_ID, LAI_count$mean_LAI)



#Summary plot by month (climatology)
LAI_Ctology = ggplot(LAI, aes(Month,LAI_TOT))
LAI_Ctology +  geom_point(size=2, shape=1, fill="black", colour="black", stroke=1.2) +
  theme_bw() + # eliminate default background 
  theme(panel.grid.major = element_blank(), # eliminate major grids
        panel.grid.minor = element_blank(), # eliminate minor grids
        # set font family for all text within the plot ("serif" should work as "Times New Roman")
        # note that this can be overridden with other adjustment functions below
        text = element_text(family="serif"),
        # adjust X-axis title
        axis.title.x = element_text(size = 12),
        # adjust X-axis labels; also adjust their position using margin (acts like a bounding box)
        # using margin was needed because of the inwards placement of ticks
        # http://stackoverflow.com/questions/26367296/how-do-i-make-my-axis-ticks-face-inwards-in-ggplot2
        axis.text.x = element_text(size = 10, margin = unit(c(t = 2.5, r = 0, b = 0, l = 0), "mm")),
        # adjust Y-axis title
        axis.title.y = element_text(size = 10, face = "bold"),
        # adjust Y-axis labels
        axis.text.y = element_text(size = 8, margin = unit(c(t = 0, r = 2.5, b = 0, l = 0), "mm")),
        # length of tick marks - negative sign places ticks inwards
        axis.ticks.length = unit(-1.4, "mm"),
        # width of tick marks in mm
        axis.ticks = element_line(size = .3)
  )




