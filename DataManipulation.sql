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

Select
	[state] = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend))), 
	NameAppend,
	i.[Index],
	Density,
	Population2013,
	FemalePercent,
	MinortiyPercent = 100- CAST(WhiteAlonePercent as float),
	LessThanHighSchool = 100 - Cast(HighSchoolPlusPercent as float),
	BelowPovertyPercent,
	UnEmployement = CAST(SUBSTRING(E.Unemployment,CHARINDEX(',',E.Unemployment)+1,7) as float),
	PopPerSqMile2010,
	H,
	FH
into Par_Coor
From 
	ModelData_Clean C 
	INNER JOIN [dbo].[Unemployement2012] E ON E.CountyID = C.CountyID
	INNER JOIN [dbo].[2011_gun_index]  i ON i.State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))
Order by CASt(H AS INT) DESC


Select * from Par_Coor



Select
	[State] = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend))), 
	i.[Index],
	PopulationPerThousand = SUM(CAST(H as float))/(SUM(CAST(Population2013 as float))/1000),
	Population2013 = SUM(CAST(Population2013 as float)),
	Population2010  = SUM(CAST(Population2010 as float)),
	Homocides= SUM(CAST(H as float)),
	FireArm_Homocides = SUM(CAST(FH as float))
Into pop
From 
	ModelData_Clean C 
	INNER JOIN [dbo].[Unemployement2012] E ON E.CountyID = C.CountyID
	INNER JOIN [dbo].[2011_gun_index]  i ON i.State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))
Group by
	Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend))), 
	i.[Index]
Order by 1


Select 
	C.nameAppend,
	i.[Index],
	Density,
	Population2013,
	Population2010,
	PopU182013,
	FemalePercent,
	WhiteAlonePercent,
	LessThanHighSchool = 100 - Cast(HighSchoolPlusPercent as float),
	BelowPovertyPercent,
	UnEmployement = CAST(SUBSTRING(E.Unemployment,CHARINDEX(',',E.Unemployment)+1,7) as float),
	PopPerSqMile2010,
	H,
	FH
	
--Into Small_Cities_Model
From 
	ModelData_Clean C 
	INNER JOIN [dbo].[Unemployement2012] E ON E.CountyID = C.CountyID
	INNER JOIN [dbo].[2011_gun_index]  i ON i.State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))
Where Cast(Population2013 as float) > 1000000
Order by CAST(Population2013 as float) DESC

--Drop table X

Select 

	FH

--Into Y1
From 
	ModelData_Clean C 
	INNER JOIN [dbo].[2011_gun_index]  i ON i.State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))
Order by id


Select 

	H

--Into Y2
From 
	ModelData_Clean C 
	INNER JOIN [dbo].[2011_gun_index]  i ON i.State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))
Order by id


USE [Crime_data]
GO

SELECT  
	   Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend))) AS STATE
	  ,C.[Index]
      ,C.[H]
      ,C.[FH]
	  ,coeff
	  ,Index0 = XYY.FH+ (0 - C.[Index])*coeff
	  ,Index25 = XYY.FH + (25 - C.[Index])*coeff
	  ,Index50 = XYY.FH+ (50 - C.[Index])*coeff
	  ,Index75 = XYY.FH+ (75 - C.[Index])*coeff
	  ,Index100 = XYY.FH+ (100 - C.[Index])*coeff
  FROM  [dbo].[XYCluster] XYY

INNER JOIN 
( 
SELECT 
	C1.nameAppend,
	i.[Index],
	Density,
	Population2013,
	Population2010,
	PopU182013,
	FemalePercent,
	WhiteAlonePercent,
	LessThanHighSchool = 100 - Cast(HighSchoolPlusPercent as float),
	BelowPovertyPercent,
	UnEmployement = CAST(SUBSTRING(E.Unemployment,CHARINDEX(',',E.Unemployment)+1,7) as float),
	PopPerSqMile2010,
	H,
	FH

FROM Modeldata_Clean C1
INNER JOIN [dbo].[Unemployement2012] E ON E.CountyID = C1.CountyID
INNER JOIN [dbo].[2011_gun_index]  i ON i.State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))

) AS C ON 
	  XYY.[Index] = C.[Index]
 AND     XYY.[Density] = C.[Density]
  AND    XYY.[PopU182013] = C.[PopU182013]
  AND    XYY.[FemalePercent] = C.[FemalePercent]
   AND   XYY.[WhiteAlonePercent] = C.[WhiteAlonePercent]
 --  AND   XYY.[LessThanHighSchool] = C.[LessThanHighSchool]
 -- AND    XYY.[BelowPovertyPercent] = C.[BelowPovertyPercent]
  AND    XYY.[UnEmployement] = C.[UnEmployement]
  AND    XYY.[PopPerSqMile2010] = C.[PopPerSqMile2010]
  AND    XYY.[H] = C.[H]
   AND   XYY.[FH] = C.[FH]

Where Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend))) = 'NEW YORK'




	  ,Index0 = SUM(CASE WHEN XYY.FH + (0 - C.[Index])*coeff < 0 then 0 Else XYY.FH + (0 - C.[Index])*coeff End)
	  ,Index25 = SUM(CASE WHEN XYY.FH + (25 - C.[Index])*coeff < 0 then 0 Else XYY.FH + (0 - C.[Index])*coeff End)
	  ,Index50 = SUM(CASE WHEN XYY.FH + (50 - C.[Index])*coeff < 0 then 0 Else XYY.FH + (0 - C.[Index])*coeff End)
	  ,Index75 = SUM(CASE WHEN XYY.FH + (75 - C.[Index])*coeff < 0 then 0 Else XYY.FH + (0 - C.[Index])*coeff End)
	  ,Index100 = SUM(CASE When XYY.FH + (100 - C.[Index])*coeff < 0 then 0 Else XYY.FH + (0 - C.[Index])*coeff End)


Select 

*,
Var100 = (GH - Index100), 
Var75 = (GH - Index75), 
Var50 = (GH - Index50), 
Var25 = (GH - Index25), 
Var0 = (GH - Index0)
Into withVar
From Predictions_By_County



Select * from withVar
Where Var100 > 0 or Var75 > 0 or Var25 > 0 or Var0 > 0

USE [Crime_data]
GO

SELECT  DISTINCT
	   Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend))) AS STATE
	   ,NAME
	  ,C.[Index]
      ,H = CAST(C.[H] as int)
      ,GH = CAST(C.[FH] as int)
	  --,coeff
	  ,Index0 = ROUND(XYY.FH+ (0 - C.[Index])*coeff,0)
	  ,Index25 = ROUND(XYY.FH + (25 - C.[Index])*coeff,0)
	  ,Index50 = ROUND(XYY.FH+ (50 - C.[Index])*coeff,0)
	  ,Index75 = ROUND(XYY.FH+ (75 - C.[Index])*coeff,0)
	  ,Index100 = ROUND(XYY.FH+ (100 - C.[Index])*coeff,0)
	  ,coeff
INTO Predictions_By_County	  
  FROM  [dbo].[XYCluster] XYY

INNER JOIN 
( 
SELECT 
	C1.nameAppend,
	i.[Index],
	Density,
	Population2013,
	Population2010,
	PopU182013,
	FemalePercent,
	WhiteAlonePercent,
	LessThanHighSchool = 100 - Cast(HighSchoolPlusPercent as float),
	BelowPovertyPercent,
	UnEmployement = CAST(SUBSTRING(E.Unemployment,CHARINDEX(',',E.Unemployment)+1,7) as float),
	PopPerSqMile2010,
	H,
	FH,
	C1.NAME

FROM Modeldata_Clean C1
INNER JOIN [dbo].[Unemployement2012] E ON E.CountyID = C1.CountyID
INNER JOIN [dbo].[2011_gun_index]  i ON i.State = Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend)))

) AS C ON 
	  XYY.[Index] = C.[Index]
 AND     XYY.[Density] = C.[Density]
  AND    XYY.[PopU182013] = C.[PopU182013]
  AND    XYY.[FemalePercent] = C.[FemalePercent]
   AND   XYY.[WhiteAlonePercent] = C.[WhiteAlonePercent]
 --  AND   XYY.[LessThanHighSchool] = C.[LessThanHighSchool]
 -- AND    XYY.[BelowPovertyPercent] = C.[BelowPovertyPercent]
  AND    XYY.[UnEmployement] = C.[UnEmployement]
  AND    XYY.[PopPerSqMile2010] = C.[PopPerSqMile2010]
  AND    XYY.[H] = C.[H]
   AND   XYY.[FH] = C.[FH]

--Where Substring(nameAppend,charIndex('|',nameAppend)+1,CharIndex('|',Reverse(nameAppend))) = 'Idaho'



Insert into [HOMOCIDE_BY_COUNTY_2]
Select H.* from [dbo].[HOMOCIDE_BY_COUNTY] H
Left Outer JOIN [dbo].[HOMOCIDE_BY_COUNTY_2] H1
ON H.STATE_NAME = H1.STATE_NAME AND H.COUNTY = H1.COUNTY AND H.Year = H1.Year
Where H1.STATE_NAME IS NULL

SELECT SUM(TOTAL_HOMOCIDES) 
FROM [dbo].[HOMOCIDE_BY_COUNTY_2]
WHERE STATE_NAME = 'NEW YORK'
Group by [Year]

Select STATE_NAME,COUNTY,[Year],Total_FireArm_homocides,Total_Homocides
INTO [dbo].[HOMOCIDE_BY_COUNTY_2]
FROM
(
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2012 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]
UNION
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2011 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]
UNION
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2010 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]
UNION
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2009 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]
UNION
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2008 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]

) AS A
Order by 1,2,3



SELECT
[STATE],
[YEAR],
[COUNTY],
[STNAME],
[MONTH],
COUNT(*)
FROM CRIME_2008
Group by [STATE],
[YEAR],
[COUNTY],
[STNAME],
[MONTH]

/*
SELECT
DISTINCT B.[STATE NAME]
FROM CRIME_2012 A
INNER JOIN STATE_TO_ABBR B ON A.STNAME = B.STATABR
INNER JOIN CCP C ON A.COUNTY = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
WHERE STNAME = 'ALASKA'


SELECT DISTINCT STNAME FROM CRIME_2012
where STNAME = 'ALASKA'

union all

SELECT [STATE NAME] FROM STATE_TO_ABBR
WHERE [STATE NAME] = 'ALASKA'

Update CCP
SET COUNTY = 'Yukon-Koyukuk (CA)'
WHERE FSTATE = 'ALASKA'

SELECT * FROM CCP
WHERE FSTATE = 'ALASKA'
DROP TABLE CRIME_BY_COUNTY
*/

Select * 
Into CRIME_BY_COUNTY
from
(

SELECT

[YEAR],
C.[COUNTY],
B.[STATE NAME],
Total_CRIME = COUNT(*)
FROM CRIME_2012 A
INNER JOIN STATE_TO_ABBR B ON A.STNAME = B.STATABR
INNER JOIN CCP C ON A.COUNTY = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by [STATE],
[YEAR],
C.[COUNTY],
B.[STATE NAME]

UNION

SELECT

[YEAR],
C.[COUNTY],
B.[STATE NAME],
Total_CRIME = COUNT(*)
FROM CRIME_2011 A
INNER JOIN STATE_TO_ABBR B ON A.STNAME = B.STATABR
INNER JOIN CCP C ON A.COUNTY = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by [STATE],
[YEAR],
C.[COUNTY],
B.[STATE NAME]

UNION

SELECT

[YEAR],
C.[COUNTY],
B.[STATE NAME],
Total_CRIME = COUNT(*)
FROM CRIME_2010 A
INNER JOIN STATE_TO_ABBR B ON A.STNAME = B.STATABR
INNER JOIN CCP C ON A.COUNTY = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by [STATE],
[YEAR],
C.[COUNTY],
B.[STATE NAME]


UNION

SELECT

[YEAR],
C.[COUNTY],
B.[STATE NAME],
Total_CRIME = COUNT(*)
FROM CRIME_2009 A
INNER JOIN STATE_TO_ABBR B ON A.STNAME = B.STATABR
INNER JOIN CCP C ON A.COUNTY = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by [STATE],
[YEAR],
C.[COUNTY],
B.[STATE NAME]

UNION

SELECT

[YEAR],
C.[COUNTY],
B.[STATE NAME],
Total_CRIME = COUNT(*)
FROM CRIME_2008 A
INNER JOIN STATE_TO_ABBR B ON A.STNAME = B.STATABR
INNER JOIN CCP C ON A.COUNTY = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by [STATE],
[YEAR],
C.[COUNTY],
B.[STATE NAME]

) AS A

--DROP TABLE CH_BY_COUNTY
/*
Select 
C.YEAR,
COUNTY_ID = DENSE_RANK() OVER (ORDER BY C.[STATE NAME],C.COUNTY),
C.COUNTY,
STATE_ID = DENSE_RANK() OVER (ORDER BY C.[STATE NAME]),
STATE = C.[STATE NAME],
C = C.Total_CRIME,
TFH = ISNULL(H.Total_FireArm_homocides,0),
H= ISNULL(H.Total_homocides ,0)

INTO CH_BY_COUNTY
From CRIME_BY_COUNTY C
LEFT OUTER JOIN HOMOCIDE_BY_COUNTY H ON C.COUNTY = H.COUNTY AND C.YEAR = H.Year AND C.[STATE NAME] = H.STATE_NAME


SELECT [STATE NAME] from [dbo].[STATE_TO_ABBR]
Except
SELECT DISTINCT STATE FrOm CH_BY_COUNTY
*/

SELECT *,STATE_ID = DENSE_RANK() OVER (ORDER BY STATE),COUNTY_ID = DENSE_RANK() OVER (ORDER BY STATE,COUNTY) FROM CH_BY_COUNTY
ORDER BY 2,3

SELECT * FROM HOMOCIDE_BY_COUNTY
WHERE STATE_NAME = 'ALASKA'


SELECT * FROM CH_BY_COUNTY



Select STATE_NAME,COUNTY,[Year],Total_FireArm_homocides,Total_Homocides
INTO
HOMOCIDE_BY_COUNTY
FROM
(
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_Homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2012 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]
UNION
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2011 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]
UNION
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2010 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]
UNION
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2009 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]
UNION
SELECT 
[Year] = V6,
[COUNTY] = C.COUNTY,
STATE_NAME = B.[STATE NAME],
Total_FireArm_homocides = Sum(Case
								When V27 between 1 and 15 then 1
								ELSE 0
						END),
Total_Homocides = Count(*)

FROM HOMOCIDE_2008 A
INNER JOIN STATE_TO_ABBR B ON A.V12 = B.STATABR
INNER JOIN CCP C ON A.V8 = C.UCNTY1 AND B.[STATE NAME] = C.FSTATE 
Group by V6,C.COUNTY,B.[STATE NAME]

) AS A
Order by 1,2,3
