####
#### Read in GPP estimates for Ameriflux sites 
#### Data prepped by Matt Roby 
####
library(tidyverse)

GPPSites=read.csv(file='./data/Avg_GPP.csv', header = T )

headers = read.csv(file='./data/annualfluxes.csv', skip = 0, header = F, nrows = 1, as.is = T)
Site_fluxes = read.csv(file='./data/annualfluxes.csv', skip = 2, header = F)
colnames(Site_fluxes)= headers

#
op<-par(no.readonly=TRUE) #this is done to save the default settings 
par(cex.lab=2.5,cex.axis=2.5, tcl=0.4)
#change the sizes of the axis labels and axis title
plot (SF_fluxes_aov$CodeKoppen_Geiger, SF_fluxes_aov$GPPdayPartition_gCm2y1,
      xlab="Koppen Geiger", ylab="GPP  gC/year")
#if we want big axis titles and labels we need to set more space for them
par(mar=c(6,8,3,3),cex.axis=3,cex.lab=3)

op<-par(no.readonly=TRUE) #this is done to save the default settings 
par(cex.lab=2.5,cex.axis=2.5, tcl=0.4)
#change the sizes of the axis labels and axis title
axis(side=1, at = labels, labels=labels )
plot (SF_fluxes_red$RockType, SF_fluxes_red$GPPdayPartition_gCm2y1,
      xlab="", ylab="GPP  gC/year")
#if we want big axis titles and labels we need to set more space for them
par(mar=c(6,8,3,3),cex.axis=3,cex.lab=3)

op<-par(no.readonly=TRUE) #this is done to save the default settings 
par( cex.lab=2.5,cex.axis=2.5, tcl=0.4, pch=19)
#change the sizes of the axis labels and axis title
axis(side=1, at = labels, labels=labels )
plot (SF_fluxes_red$Elevation,SF_fluxes_red$GPPdayPartition_gCm2y1, 
      xlab="", ylab="GPP  gC/year")
#if we want big axis titles and labels we need to set more space for them
par(mar=c(6,8,3,3),cex.axis=3,cex.lab=3)



# 
# library(readxl)
# sites <- read_excel("./data/AmerifluxDataAvailability.xlsx")
# 
plot(sites$`Elevation (m)`)

StateFactors = read.csv(file = './data/statefactors.csv')
StateFactors = rename(StateFactors,site = names )

sites = sites %>%
  rename(site = 'Site ID' ) %>%
  mutate (site = as.factor(site))

hist (Site_fluxes$ET_mm_year)
hist (Site_fluxes$GPPdayPartition_gCm2y1)

#plot(sites$RockType, sites$`Mean Average Precipitation (mm)`)

SF_Fluxes = left_join(sites, Site_fluxes, by="site")
SF_Fluxes = full_join(SF_Fluxes, StateFactors, by="site") 

SF_fluxes_red =SF_Fluxes %>%
  filter(!is.na(RockType)) %>%
  filter(!is.na(GPPdayPartition_gCm2y1)) %>%
  filter(GPPdayPartition_gCm2y1>0) %>%
  mutate (Koppen_Geiger = as.factor(Koppen_Geiger)) %>%
  mutate (Elevation = `Elevation (m)`) %>%
  mutate (CodeKoppen_Geiger = as.factor(`Climate Class Abbreviation (Koeppen)`))

SF_fluxes_aov = SF_fluxes_red %>%
  top_n(n() * .85)

#  filter(CodeKoppen_Geiger!="Cwa")

# Two Way Factorial Design
fit_Three <- aov(GPPnightPartition_gCm2y1 ~ 
                   Koppen_Geiger + 
                   RockType + 
                   Koppen_Geiger:RockType +
                   Elevation,
                 data=SF_fluxes_aov)
resFit3_GPPNight = residuals(fit_Three)
Output_fitThree=proj(fit_Three)
write.csv(Output_fitThree, "Output_Fit3_GPPNight.csv")
#Summary Statistics
summary(fit_Three)
#Residual Plots
plot(SF_fluxes_aov$GPPnightPartition_gCm2y1,resFit3_GPPNight)
plot(SF_fluxes_aov$Topsoil_Organic_Carbon,resFit3_GPPNight)

ResAnova = aov(resFit3_GPPNight~SF_fluxes_aov$`Vegetation Abbreviation (IGBP)`)

summary(ResAnova)

#####
fit_Three_ET <- aov(ET_mm_year ~ 
                   Koppen_Geiger + 
                   RockType + 
                   Koppen_Geiger:RockType +
                   Elevation,
                 data=SF_fluxes_aov)

resFit3_ET = residuals(fit_Three_ET)
Output_fitThree=proj(fit_Three_ET)


write.csv(Output_fitThree, "Output_Fit3_ET.csv")
######
summary(fit_Three_ET)

#Residual Plots
plot(SF_fluxes_aov$ET_mm_year,resFit3_ET)
plot(SF_fluxes_aov$Topsoil_Organic_Carbon,resFit3_ET)

boxplot(resFit3_ET,x = SF_fluxes_aov$`Vegetation Abbreviation (IGBP)`)


SF_fluxes_aovPOST = SF_fluxes_aov

SF_fluxes_aovPOST['resFit3_ET'] <- resFit3_ET
SF_fluxes_aovPOST['resFit3_GPPNight'] <- resFit3_GPPNight

SF_fluxes_aovPOST  %>%
  mutate (PFT = as.factor('Vegetation Abbreviation (IGBP)'))




%>%
  group_by(PFT) %>%
  summarise_at(vars(-resFit3_GPPNight), funs(sum(., na.rm=FALSE)))

plot(SF_fluxes_aovPOST$)

write.csv(SF_fluxes_aovPOST, "SF_fluxes_aovPOST.csv")

RES_PFT=read.csv(file='./data/Residuals_PFT.csv', header = T )
x1  = factor(RES_PFT$PFT, levels=c("CSH", "DBF", "WET", "GRA", "WSA", "ENF", "MF", "OSH","CRO"))

op<-par(no.readonly=TRUE) #this is done to save the default settings 
par(cex.lab=1.5,cex.axis=1.3, tcl=0.4)
#change the sizes of the axis labels and axis title
plot(x1,RES_PFT$resFit3_GPPNight,
xlab="Plant Functional Type", ylab="GPP Residuals gC/year", ylim=c(-500, 500))
#if we want big axis titles and labels we need to set more space for them
par(mar=c(6,6,3,3),cex.axis=1.5,cex.lab=1.5)

# plot (SF_fluxes_red$CodeKoppen_Geiger, SF_fluxes_red$ET_mm_year)
# plot (SF_fluxes_aov$CodeKoppen_Geiger, SF_fluxes_aov$GPPdayPartition_gCm2y1)


op<-par(no.readonly=TRUE) #this is done to save the default settings 
par(cex.lab=1.5,cex.axis=1.3, tcl=0.4)
#change the sizes of the axis labels and axis title
plot(SF_fluxes_aovPOST$Subsoil_Organic_Carbon,RES_PFT$resFit3_GPPNight,
     xlab="Sub Soil Organic C", ylab="GPP Residuals gC/year", ylim=c(-500, 500))
#if we want big axis titles and labels we need to set more space for them
par(mar=c(6,6,3,3),cex.axis=1.5,cex.lab=1.5)



plot(x1, SF_fluxes_aovPOST$Subsoil_Organic_Carbon)
     
     
op<-par(no.readonly=TRUE) #this is done to save the default settings 
par(cex.lab=1.5,cex.axis=1.3, tcl=0.4)
#change the sizes of the axis labels and axis title
plot(SF_fluxes_aovPOST$Topsoil_Organic_Carbon,RES_PFT$resFit3_GPPNight,
     xlab="Top Soil Organic C", ylab="GPP Residuals gC/year", ylim=c(-500, 500))
#if we want big axis titles and labels we need to set more space for them
par(mar=c(6,6,3,3),cex.axis=1.5,cex.lab=1.5)




plot (SF_Fluxes$Koppen_Geiger, SF_Fluxes$Topsoil_Organic_Carbon)

SF_Fluxes$`Elevation (m)`


fit_KOP <- aov(ET_mm_year ~ Koppen_Geiger, data=SF_Fluxes)
summary(fit_KOP)

fit_Rock <- aov(ET_mm_year ~ RockType, data=SF_Fluxes)
summary(fit_Rock)


fit <- aov(y ~ A*B, data=mydataframe) # same thing




