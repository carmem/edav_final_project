---
title: "Firearm Homicide and Demography: Do Gun Laws Matter?"
layout: post
output: html_document
---

# Firearm Homicide and Demography: "Do Gun Laws Matter?"
Carmem Domingues, Labib Fawaz, Lauren McCarthy, Michael Bisaha
April 21, 2014

## Introduction
***

Discuss here the data we used and what kind of methods we used to combine it.

[Gun Law Index Data](http://www.bradycampaign.org/2013-state-scorecard)

[Homicide Data](http://www.icpsr.umich.edu/icpsrweb/content/NACJD/guides/ucr.html)

[Census Demography Data](http://www.bls.gov/lau/#cntyaa)

Once we identified the data sources we'd be working with, there was an impressive amount of data munging to do. The data wasn't always clean or complete, and more importantly we had to spend a great deal of time matching up state and county names across separate datasets to piece together a full picture. Some datasets had well-defined county codes that could be applied across multiple fields, but others required matching up text identifiers with with different spellings and encodings.

Here is a sample of some importing/cleaning done in Python - 

```python
#!/usr/bin/python

import sys
sys.path.append('./')

# Input file: race_2010_input
# 
# Input format (codes): 
# 01001|Autauga County, AL
# 01003|Baldwin County, AL
#
# Input format (state_abbreviations):
# Alabama	AL
# Alaska	AK
# 
# Output format: 
# 01001|Autauga County|Alabama
# 01003|Baldwin County|Alabama

def mapper(argv):

	state_dict = {}

	f = open('state_abbreviations', 'r')
	for l in f:
		name, ab = l.strip().split("\t")

		if ab not in state_dict:
			state_dict[ab] = name

	errors = 0
	for line in sys.stdin:
		try:
			data = line.strip().split("|")
			code = data[0]
			data1 = data[1].strip().split(',')
			if len(data1) == 2:
				county = data1[0]
				state = state_dict[data1[1].replace(" ","")]
				print "%s|%s|%s" %(code, county, state)

		except Exception as e:
			errors += 1
			e = sys.exc_info()[0]
			sys.stderr.write("\nERROR Mapper:  %s **** %s" % (line,e))
			continue

	# print "errors %d" %(errors)

if __name__ == '__main__':
   mapper(sys.argv)
```

Still more cleaning/importing in R...

```R
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
```

Full R code [here](https://github.com/mbisaha/edav_final_project/blob/master/Data_munging.R).

And finally, we aggregated final data into SQL...

```
Select 
STATE = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend))),
Pop2011 = SUM(CAST(Population2010 as bigint)) ,
Pop2013 = SUM(CAST(Population2013 as bigint))
from [dbo].[Modeldata_Clean]
GROUP BY 
Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))
Order by 1

Select i.[Index],State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend))) ,*

from ModelData_Clean C 
INNER JOIN [dbo].[2011_gun_index]  i ON i.State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))
Order by 2 ASC

Select 
	i.[Index],
	Density,
	FH,
	H,
	Population2010,
	PopU182013,
	PopO652013,
	PopulationU1864 = 1 - CAST(PopU182013 as float) - CAST(PopO652013 as float),
	FemalePercent,
	WhiteAlonePercent,
	BlackAlonePercent,
	NativeAmAlonePercent,
	AsianAlongPercent,
	PacIslandPercent,
	MultipleRacesPercent,
	LessThanHighSchool = 1 - Cast(HighSchoolPlusPercent as float),
	BachelorsPlusPercent,
	HighSchoolOnly = Cast(HighSchoolPlusPercent as float) - Cast(BachelorsPlusPercent as float),
	BelowPovertyPercent,
	Employement = Cast(NonfarmEmployment2012 as float)/Cast(Population2013 as float),
	H,
	FH
Into XY1Y2
From ModelData_Clean C 
INNER JOIN [dbo].[2011_gun_index]  i ON i.State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))
```

Full SQL code [here](https://github.com/mbisaha/edav_final_project/blob/master/DataManipulation.sql).


## Exploring the potential variables with choropleth maps

After pulling the variety of variables we considered building into our model, we wanted to better visualize the county-by-county trends across the US. For this, we turned to building choropleth maps for each data point. Taken together, these charts helped us understand each individual variable in greater detail, as well identify which variables may be conveying similar information in terms of our final model.

__Choropleth Maps__


LINKS TO MAPS, SHORT EXPLANATION, AND CODE CHUNK

## Exploring the potential variables further with parallel coordinates

Now that we better understand many of the variables in play, we want to explore the relationships each 

LAUREN'S GRAPH GOES HERE

[Slickgrid](https://github.com/mleibman/SlickGrid)
[Parallel Coordinates](https://github.com/syntagmatic/parallel-coordinates)

## Developing the Model

CODE BLOCK CLUSTERING THE DATA W/K-MEANS GOES HERE


CODE BLOCK ON RUNNING THE MODEL GOES HERE


## Model Results

[Model Results for Firearm Homicides](http://htmlpreview.github.com/?https://github.com/carmem/edav_final_project/blob/master/D3/gun_homicides.html)

[Model Results for Homicides](http://htmlpreview.github.com/?https://github.com/carmem/edav_final_project/blob/master/D3/homicides.html)




## Gun Homicides and Gun Index changes over time

LABIB's GRAPH GOES HERE



