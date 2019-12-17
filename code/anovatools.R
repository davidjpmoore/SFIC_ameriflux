#ANOVA tools

devtools::install_github("singmann/afex@master")
packageVersion("afex")

library(afex)

(fit_mixed <- mixed(value~treatment*phase+(phase|id),data=obk.long))

fit_mixed <- mixed(ET_mm_year~Koppen_Geiger*RockType+(RockType|Elevation), data=SF_Fluxes)

(fit_mixed <- mixed(ET_mm_year~Koppen_Geiger*RockType+(RockType|Elevation),data=SF_Fluxes))

library(lsmeans)
fit_Three <- aov(ET_mm_year ~ Koppen_Geiger + RockType + Elevation + Koppen_Geiger:RockType, data=SF_fluxes_red)
summary(fit_Three)

lsmeans_all <- lsmeans(fit_Three, specs = c("Koppen_Geiger","RockType" ))

length(residuals(fit_Three))

plot(TukeyHSD(fit_Three, conf.level = 0.99),las=1, col = "red")


