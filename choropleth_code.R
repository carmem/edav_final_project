library("reshape")
library("leafletR")

## set color palettes
##red-blue (low-high) color palette
set_map_color_rdbl <- colorRampPalette(c('red', 'blue'))

## white-red (low-high) color palette
set_map_color_wtrd <- colorRampPalette(c('white', 'red'))

##white-black (low-high) color palette
set_map_color_wtbk <- colorRampPalette(c('white', 'black'))

## white-yellow (low-high) color palette
set_map_color_wtyl <- colorRampPalette(c('white', 'yellow'))

## white-green (low-high) color palette
set_map_color_wtgr <- colorRampPalette(c('white', 'green'))

## white-blue (low-high) color palette
set_map_color_wtbl <- colorRampPalette(c('white', 'blue'))

## black-green (low-high) color palette
set_map_color_bkgr <- colorRampPalette(c('black', 'green'))

## green-red (low-high) color palette
set_map_color_grrd <- colorRampPalette(c('green', 'white','red'))

##test map color distribution
plot(rep(1,10),col=set_map_color_wtrd(10),pch=19,cex=3)

map_county <- toGeoJSON(countydata, dest="/Users/mbisaha/Desktop/US_County_Shapefiles")

## map Urban Density
sty.Density <- styleGrad(	prop="Density",
							breaks= seq(min(countydata$Density,na.rm=TRUE),max(countydata$Density,na.rm=TRUE),by=(max(countydata$Density,na.rm=TRUE)-min(countydata$Density,na.rm=TRUE))/10),
							style.par="col",
							style.val=set_map_color_wtbk(10),
							leg="Urban Population Percentage",
							fill.alpha=0.8,
							col="white",
							lwd=0.2,
							marker=NULL)

map <- leaflet(	data=map_county, 
				dest="/Users/mbisaha/Desktop/US_County_Shapefiles/ChoroplethMaps", 
				title="Urban Population Density",
				base.map="positron",
				style=sty.Density,
				popup=c("County","State","Density"),
				controls="all",
				incl.data=TRUE)

## map Firearm Homicides							
sty.GunHomicide <- styleGrad(	prop="FH",
								breaks= c(0,10,25,50,100,150,200,250,300,400,500),
								style.par="col",
								style.val=set_map_color_wtrd(10),
								leg="Firearm Homicides",
								fill.alpha=0.8,
								col="black",
								lwd=0.2,
								marker=NULL)

map <- leaflet(	data=map_county, 
				dest="/Users/mbisaha/Desktop/US_County_Shapefiles/ChoroplethMaps", 
				title="Firearm Homicides",
				base.map="positron",
				style=sty.GunHomicide,
				popup=c("County","State","FH"),
				controls="all",
				incl.data=TRUE)


## map normal Homicides							
sty.Homicide <- styleGrad(	prop="H",
								breaks= c(0,10,25,50,100,200,300,400,500,600,700),
								style.par="col",
								style.val=set_map_color_wtrd(10),
								leg="Homicides",
								fill.alpha=0.8,
								col="black",
								lwd=0.2,
								marker=NULL)

map <- leaflet(	data=map_county, 
				dest="/Users/mbisaha/Desktop/US_County_Shapefiles/ChoroplethMaps", 
				title="Homicides",
				base.map="positron",
				style=sty.Homicide,
				popup=c("County","State","H"),
				controls="all",
				incl.data=TRUE)


## map Population							
sty.Population <- styleGrad(	prop="Population2010",
								breaks= c(0,10000,25000,50000,100000,250000,500000,1000000,2500000,5000000,10000000),
								style.par="col",
								style.val=set_map_color_wtbl(10),
								leg="Population",
								fill.alpha=0.8,
								col="black",
								lwd=0.2,
								marker=NULL)

map <- leaflet(	data=map_county, 
				dest="/Users/mbisaha/Desktop/US_County_Shapefiles/ChoroplethMaps", 
				title="Population",
				base.map="positron",
				style=sty.Population,
				popup=c("County","State","Population2010"),
				controls="all",
				incl.data=TRUE)
							
## map Under18Population							
sty.PopU18 <- styleGrad(	prop="PopU182013",
								breaks= c(0,5,10,15,20,25,30,35,40,45,50),
								style.par="col",
								style.val=set_map_color_bkgr(10),
								leg="Percent Population < 18 Yrs Old",
								fill.alpha=0.8,
								col="white",
								lwd=0.2,
								marker=NULL)

map <- leaflet(	data=map_county, 
				dest="/Users/mbisaha/Desktop/US_County_Shapefiles/ChoroplethMaps", 
				title="Population Under 18",
				base.map="positron",
				style=sty.PopU18,
				popup=c("County","State","PopU182013"),
				controls="all",
				incl.data=TRUE)


## map UnderPovertyLine							
sty.PopUPoverty <- styleGrad(	prop="BelowPovertyPercent",
								breaks= c(0,2,5,10,15,20,25,30,40,50,60),
								style.par="col",
								style.val=set_map_color_grrd(10),
								leg="Percent Population Below Poverty Line",
								fill.alpha=0.8,
								col="black",
								lwd=0.2,
								marker=NULL)

map <- leaflet(	data=map_county, 
				dest="/Users/mbisaha/Desktop/US_County_Shapefiles/ChoroplethMaps", 
				title="Population Under Poverty Line",
				base.map="positron",
				style=sty.PopUPoverty,
				popup=c("County","State","BelowPovertyPercent"),
				controls="all",
				incl.data=TRUE)


## map HighSchoolPlus							
sty.OverHighSch <- styleGrad(	prop="HighSchoolPlusPercent",
								breaks= c(40,50,60,70,75,80,85,90,95,98,100),
								style.par="col",
								style.val=set_map_color_bkyl(10),
								leg="Percent Population w/High School Education",
								fill.alpha=0.8,
								col="black",
								lwd=0.2,
								marker=NULL)

map <- leaflet(	data=map_county, 
				dest="/Users/mbisaha/Desktop/US_County_Shapefiles/ChoroplethMaps", 
				title="Population High School Graduate",
				base.map="positron",
				style=sty.OverHighSch,
				popup=c("County","State","HighSchoolPlusPercent"),
				controls="all",
				incl.data=TRUE)


## map Population Density							
sty.PopDensity <- styleGrad(	prop="PopPerSqMile2010",
								breaks= c(0,5,10,50,100,500,1000,5000,10000,50000,100000),
								style.par="col",
								style.val=set_map_color_bkyl(10),
								leg="Population per Square Mile",
								fill.alpha=0.8,
								col="white",
								lwd=0.2,
								marker=NULL)

map <- leaflet(	data=map_county, 
				dest="/Users/mbisaha/Desktop/US_County_Shapefiles/ChoroplethMaps", 
				title="Population Density",
				base.map="darkmatter",
				style=sty.PopDensity,
				popup=c("County","State","PopPerSqMile2010"),
				controls="all",
				incl.data=FALSE)