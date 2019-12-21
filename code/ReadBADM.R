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
  mutate (Year = substr(LAI_DATE,1,4), Month=substr(LAI_DATE,5,6), Day = substr(LAI_DATE,7,8)) %>%
  mutate(meanLAI=mean(LAI_TOT), N_LAI=n(), maxLAI=max(LAI_TOT))


### ACTION
#Create summary table with 1) number of observations for each site & 2) mean/median interval between observations
#Rank sites by number of observations
library(data.table)
TestCount = LAI%>% count(SITE_ID) 

plot(TestCount$SITE_ID, TestCount$n)

#Summary plot by site
BySite = ggplot(LAI, aes(LAI_TOT, SITE_ID))
BySite + geom_point()



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




