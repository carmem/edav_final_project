library("plyr")
library("maptools")
library("hydroGOF")
library("rCharts")
library("reshape")
library("leafletR")

countydata <- readShapeSpatial("~/Desktop/US_County_Shapefiles/cb_2013_us_county_20m/cb_2013_us_county_20m.shp")
countydata$proj4string <- "+proj=longlat +ellps=clrk66"

state_table <- matrix(data=NA, nrow=50, ncol=2)
state_IDs <- levels(sort(unique(countydata$STATEFP)))

## state IDs in rows 9 & 52 are DC and PR
state_table[1:8,1] <- state_IDs[1:8]
state_table[9:50,1] <- state_IDs[10:51]

state_table[1:8,2] <- state.name[1:8]
state_table[9:50,2] <- state.name[9:50]

## read in UrbanDensity
Density <- read.csv(path.expand("~/Desktop/density_2010.csv"), header=FALSE, sep=",", col.names = c("CountyName|State", "Density"))

countyAppend <- mat.or.vec(nrow(countydata),1)
for (i in 1:nrow(countydata)) {
	if(countydata$STATEFP[i]==22) {
		countyAppend[i] <- paste(countydata$NAME[i]," Parish|",state_table[which(state_table[,1]==countydata$STATEFP[i]),2],sep="")} else {
	countyAppend[i] <- paste(countydata$NAME[i]," County|",state_table[which(state_table[,1]==countydata$STATEFP[i]),2],sep="")
	}
}

countydata$nameAppend <- countyAppend
countydata <- merge(countydata,Density, by.x="nameAppend", by.y="CountyName.State")

## read in homicides
homicide <- read.csv(path.expand("~/Desktop/CRIME_HOMOCIDE_BY_COUNTY.csv"),header=TRUE,sep=",")
homicide2010 <- subset(homicide, YEAR==2010)

homicide2010$nameAppend <- paste(homicide2010$COUNTY," County|",homicide2010$STATE, sep="")
which(homicide2010$STATE=="Louisiana")
homicide2010$nameAppend[1011:1074] <- paste(homicide2010$COUNTY[1011:1074]," Parish|",homicide2010$STATE[1011:1074],sep="")

homicide2010[,1] <- NULL
homicide2010[,1] <- NULL
homicide2010[,1] <- NULL
homicide2010[,1] <- NULL
homicide2010[,1] <- NULL

countydata <- merge(countydata,homicide2010, by.x="nameAppend", by.y="nameAppend")

##read in census data 
CensusDemo <- read.csv(path.expand("~/Desktop/dataset.txt"), header=TRUE, sep=",")
fipsIDs <- read.csv(path.expand("~/Desktop/FIPS_CountyName.txt"),header=FALSE,sep=">")
CensusCols <- read.csv(path.expand("~/Desktop/tables_to_keep_just_nums.txt"),header=FALSE,sep=",")

CensusDemo <- CensusDemo[-which(CensusDemo$fips %in% c(1:56*1000)),]
CensusDemo <- CensusDemo[-1,]

MyCensusData <- CensusDemo[,c(1,which(colnames(CensusDemo) %in% as.character(CensusCols[,1])))]

colnames(MyCensusData) <- c("CountyID","Population2013", "Population2010", "PopU52013", "PopU182013", "PopO652013", "FemalePercent", "WhiteAlonePercent", "BlackAlonePercent","NativeAmAlonePercent", "AsianAlongPercent", "PacIslandPercent", "MultipleRacesPercent", "HispanicPercent", "WhiteNonHispanicPercent", "HighSchoolPlusPercent", "BachelorsPlusPercent", "BelowPovertyPercent", "NonfarmEmployment2012", "PopPerSqMile2010")

for (i in 1:1835) {
    fipsIDs$Name[i] <- substr(fipsIDs[i,1],7,nchar(as.character(fipsIDs[i,1])))
    }

fipsIDs$Name[1836] <- NULL

for (i in 1837:3195) {
    fipsIDs$Name[i] <- substr(fipsIDs[i,1],7,nchar(as.character(fipsIDs[i,1])))
    }

fipsIDs$Name <- sub(", ","|",fipsIDs$Name)

fipsNames <- read.csv(path.expand("~/Desktop/codes_w_statenames.txt"),header=FALSE,sep="|")

MyCensusData <- merge(MyCensusData, fipsNames, by.x="CountyID", by.y="V1")
MyCensusData$nameAppend <- paste(MyCensusData$V2,"|",MyCensusData$V3, sep="")

countydata <- merge(countydata, MyCensusData, by.x="nameAppend", by.y="nameAppend")

countydata <- countydata[-c(which(countydata$STATEFP==72)),]
countydata <- countydata[-1763,]
names(countydata)[36] <- "County"
names(countydata)[37] <- "State"