library('hydroGOF')


Y1 <- read.csv(path.expand("~/Desktop/Y1.csv"),header=TRUE,sep=",")
Y2 <- read.csv(path.expand("~/Desktop/Y2.csv"),header=TRUE,sep=",")
X1Y1Y2 <- read.csv(path.expand("~/Desktop/X1Y1Y2.csv"),header=TRUE,sep=",")

X <- as.data.frame(X1Y1Y2[,1:9])
Ys <- as.data.frame(X1Y1Y2[,10:11])
scaledX <- scale(X)

clusterIDs <- kmeans(X[,-c(1)],4, iter.max=1000)$cluster
cluster1IDs <- which(clusterIDs==1)
cluster2IDs <- which(clusterIDs==2)
cluster3IDs <- which(clusterIDs==3)
cluster4IDs <- which(clusterIDs==4)
urbanIDs <- c(cluster2IDs,cluster3IDs,cluster4IDs)

ruralX <- X[cluster1IDs,]
urbanX <- X[urbanIDs,]
scaled_ruralX <- scale(ruralX)
scaled_urbanX <- scale(urbanX)

ruralYs <- Ys[cluster1IDs,]
urbanYs <- Ys[urbanIDs,]


ws <- mat.or.vec(10,8)
colnames(ws) <- c("scaled_gun_rural","scaled_gun_urban","scaled_homicide_rural","scaled_homicide_urban","unscaled_gun_rural","unscaled_gun_urban","unscaled_homicide_rural","unscaled_homicide_urban")
rownames(ws) <- c("Intercept","GunIndex","UrbanDensity","PopU18","FemalePercent","WhiteAlonePercent","LessThanHighSchool","BelowPovertyPercent","Unemployment","PopPerSqMile")

## full sample
## scaled gunhomicides
AllData <- cbind(scaled_ruralX, ruralYs)

linRegres = lm(FH ~ Index + Density + PopU182013 + FemalePercent + WhiteAlonePercent + LessThanHighSchool + BelowPovertyPercent + UnEmployement + PopPerSqMile2010, data = AllData)
linRegres

ws[,1] <- linRegres$coefficients

AllData <- cbind(scaled_urbanX, urbanYs)

linRegres = lm(FH ~ Index + Density + PopU182013 + FemalePercent + WhiteAlonePercent + LessThanHighSchool + BelowPovertyPercent + UnEmployement + PopPerSqMile2010, data = AllData)
linRegres

ws[,2] <- linRegres$coefficients

## scaled homicides
AllData <- cbind(scaled_ruralX, ruralYs)

linRegres = lm(H ~ Index + Density + PopU182013 + FemalePercent + WhiteAlonePercent + LessThanHighSchool + BelowPovertyPercent + UnEmployement + PopPerSqMile2010, data = AllData)
linRegres

ws[,3] <- linRegres$coefficients

AllData <- cbind(scaled_urbanX, urbanYs)

linRegres = lm(H ~ Index + Density + PopU182013 + FemalePercent + WhiteAlonePercent + LessThanHighSchool + BelowPovertyPercent + UnEmployement + PopPerSqMile2010, data = AllData)
linRegres

ws[,4] <- linRegres$coefficients

## unscaled gunhomicides
AllData <- cbind(ruralX, ruralYs)

linRegres = lm(FH ~ Index + Density + PopU182013 + FemalePercent + WhiteAlonePercent + LessThanHighSchool + BelowPovertyPercent + UnEmployement + PopPerSqMile2010, data = AllData)
linRegres

ws[,5] <- linRegres$coefficients

AllData <- cbind(urbanX, urbanYs)

linRegres = lm(FH ~ Index + Density + PopU182013 + FemalePercent + WhiteAlonePercent + LessThanHighSchool + BelowPovertyPercent + UnEmployement + PopPerSqMile2010, data = AllData)
linRegres

ws[,6] <- linRegres$coefficients

## unscaled homicides
AllData <- cbind(ruralX, ruralYs)

linRegres = lm(H ~ Index + Density + PopU182013 + FemalePercent + WhiteAlonePercent + LessThanHighSchool + BelowPovertyPercent + UnEmployement + PopPerSqMile2010, data = AllData)
linRegres

ws[,7] <- linRegres$coefficients

AllData <- cbind(urbanX, urbanYs)

linRegres = lm(H ~ Index + Density + PopU182013 + FemalePercent + WhiteAlonePercent + LessThanHighSchool + BelowPovertyPercent + UnEmployement + PopPerSqMile2010, data = AllData)
linRegres

ws[,8] <- linRegres$coefficients

write.csv(ws,file="/Users/mbisaha/Desktop/finalmodel_coefficients.csv")
