# read in excel file for site names and lat lon coordinates
library(readxl)
sites <- read_excel("./data/AmerifluxDataAvailability.xlsx")
# subset Ameriflux sites with 8 or more years
# subset site name, lat, lon
sites_name_lat_lon <- sites[which(sites$Years>=8),1:3] 
colnames(sites_name_lat_lon) <- c("name","lat","lon")

sites_name_lat_lon_sf <- data.frame(matrix(NA,nrow = 100, ncol = 8))
sites_name_lat_lon_sf[,1:3] <- sites_name_lat_lon
colnames(sites_name_lat_lon_sf) <- c("names","lat","lon","Koppen_Geiger","Topsoil_Organic_Carbon","Subsoil_Organic_Carbon", "RockType", "MinAge")

#####################################################################################################################################################################################################################################################################

# load in state factors: Koppen Geiger Climate Classification, Topsoil Organic Carbon (% weight), Subsoil Organic Carbon (% weight), Rocktype, 

# Climate
# Koppen-Geiger 0.0083 resolution
library(raster)
sf <- raster("./data/Beck_KG_V1_present_0p0083.tif")
extent(sf)
crs(sf)

png("./plots/statefactors_climate.png",13,8,
    units = "in",res = 600, pointsize=20, family= "helvetica")
plot(sf)
points(sites_name_lat_lon$lon,sites_name_lat_lon$lat, pch = 19, cex = 0.5) #pch = 19: solid circle
dev.off()

xy <- cbind(sites_name_lat_lon$lon,sites_name_lat_lon$lat)
sf_xy <- extract(sf,SpatialPoints(xy))

sf_xy #Koppen Geiger climate information is already in sites excel file, these are the numbers attributed to the classifications. 
sites_name_lat_lon_sf[,4] <- sf_xy

#consider cropping to americas or 5 degrees beyond max/min lat/lons
#x = lon
#y = lat

#####################################################################################################################################################################################################################################################################

# soil organic carbon:
sf <- raster("./data/NACP_MSTMIP_UNIFIED_NA_SOIL_MA_1242/data/Unified_NA_Soil_Map_Topsoil_Organic_Carbon.tif")

xy <- cbind(sites_name_lat_lon$lon,sites_name_lat_lon$lat)
sf_xy <- extract(sf,SpatialPoints(xy))
sites_name_lat_lon_sf[,5] <- sf_xy


png("./plots/statefactors_soil_topsoil_organic_carbon).png",13,8,
    units = "in",res = 600, pointsize=20, family= "helvetica")
plot(sf,legend = F)
points(sites_name_lat_lon$lon,sites_name_lat_lon$lat, pch = 19, cex = 0.5) #pch = 19: solid circle

plot(sf, legend.only = T, legend.width=1, legend.shrink=1, legend.args=list(text='% weight', side=3, line=2, cex=1), axis.args = list(cex.axis = 1),horiz=F)
# %weight
dev.off()

sf <- raster("./data/NACP_MSTMIP_UNIFIED_NA_SOIL_MA_1242/data/Unified_NA_Soil_Map_Subsoil_Organic_Carbon.tif")

xy <- cbind(sites_name_lat_lon$lon,sites_name_lat_lon$lat)
sf_xy <- extract(sf,SpatialPoints(xy))
sites_name_lat_lon_sf[,6] <- sf_xy

png("./plots/statefactors_soil_subsoil_organic_carbon).png",13,8,
    units = "in",res = 600, pointsize=20, family= "helvetica")
plot(sf,legend = F)
points(sites_name_lat_lon$lon,sites_name_lat_lon$lat, pch = 19, cex = 0.5) #pch = 19: solid circle

plot(sf, legend.only = T, legend.width=1, legend.shrink=1, legend.args=list(text='% weight', side=3, line=2, cex=1), axis.args = list(cex.axis = 1),horiz=F)
# %weight
dev.off()


#####################################################################################################################################################################################################################################################################

# geological substrate
# Only for North America

# checked here to validate with another data set (not sure where source data is for this site: http://portal.onegeology.org/OnegeologyGlobal/)
library(rgdal)
library(rgeos)
library(raster)
sf <- readOGR("./data/GMNA_SHAPES/", layer = 'Geologic_units') #Large SpatialPolygonsDataFrame
summary(sf)
class(sf)
head(sf@data)
crs(sf)

#spplot(sf,'ROCKTYPE')

sf_lonlat <- spTransform(sf, CRS("+proj=longlat +datum=WGS84"))
extent(sf_lonlat)
sf_xy <- extract(sf_lonlat,SpatialPoints(xy))
head(sf_xy)
#sf_xy[sf_xy$ROCKTYPE == 'Plutonic', ]

#a couple rows are duplicate because of the resolution of the two datasets?
#remove the duplicates
sf_mod <- 
sites_name_lat_lon_sf[,7] <- sf_xy[unique(sf_xy$point.ID),]$ROCKTYPE
sites_name_lat_lon_sf[,8] <- sf_xy[unique(sf_xy$point.ID),]$MIN_AGE


#or reproject lat lon into  >>> same as above 
# mydf <- structure(list(longitude = xy[,1], latitude = xy[,2]), .Names = c("longitude", "latitude"), class = "data.frame", row.names = c(NA, -100L))
# 
# ### Get long and lat from your data.frame. Make sure that the order is in lon/lat.
# 
# xy <- mydf[,c(1,2)]
# 
# spdf <- SpatialPointsDataFrame(coords = xy, data = mydf,proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
# 
# spdf_tmerc <- spTransform(spdf, CRS("+proj=tmerc +lat_0=0 +lon_0=-100 +k=0.926 +x_0=0 +y_0=0 +a=6371204 +b=6371204 +units=m +no_defs"))
# 
# sf_xy <- extract(sf,SpatialPoints(spdf_tmerc))
# sites_name_lat_lon_sf[,6] <- sf_xy

sites[1:100,20:24] <- sites_name_lat_lon_sf[,4:8]

write.csv(sites_name_lat_lon_sf, "statefactors.csv")
#####################################################################################################################################################################################################################################################################



library(ggplot)
map <- ggplot() + geom_polygon(data = sf, aes(x = long, y = lat, group = group), colour = "black", fill = NA)



library(sf)

st_layers("./data/GMNA_SHAPES/")

sf <- st_read("./data/GMNA_SHAPES/",layer = 'Geologic_units')

sf_gcs <- st_transform(sf, "+proj=longlat +datum=WGS84")
st_crs(sf_gcs)

sf_xy <- extract(sf_gcs, SpatialPoints(xy))



sf <- sf$LITHOLOGY
#sf <- raster(as.matrix(sf$ROCKTYPE))
#sf <- raster("GMNA_SHAPES/", layer = 'Geologic_units')

library(ggplot2)
ggplot() + 
  geom_sf(data = sf) + 
  ggtitle("Geologic_units") + 
  coord_sf()

# elevation is already in site ID
# Slope, Aspect? 

