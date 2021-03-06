# Get the data from the text file
library(dplyr)

message("loading data....")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")    
message("data loaded !")     

#preparing data to plots
##identify coal combustion-related sources 
scc_index <- grep("Mobile", SCC$EI.Sector) 

##extract SCC codes
scc_codes <- SCC[scc_index, 1]

##subset the data based on relevant SCC codes and appropriate fips
nei_mobile <- NEI[NEI$SCC %in% scc_codes, ]
nei_mobile_balt <- nei_mobile[nei_mobile$fips == "24510",]
nei_mobile_lac <- nei_mobile[nei_mobile$fips == "06037",]

#transforming data
##Baltimore Data
nei_mobile_balt <- mutate(nei_mobile_balt,year=factor(year))
nei_mobile_balt <- group_by(nei_mobile_balt,year)
nei_mobile_balt <- summarize(nei_mobile_balt,pm25=sum(Emissions))

##Los Angeles Data
nei_mobile_lac <- mutate(nei_mobile_lac,year=factor(year))
nei_mobile_lac <- group_by(nei_mobile_lac,year)
nei_mobile_lac <- summarize(nei_mobile_lac,pm25=sum(Emissions))

# Initiate the png file (device)
png("plot6.png", height=900, width=900)
message("device open")

par(pch=19)
par(mfrow = c(1, 2))

# Baltimore Plot
plot(nei_mobile_balt$year,
     nei_mobile_balt$pm25,
     type="n",
     xlab="Year",
     ylab="Amount of PM2.5 emitted (Tons)",
     main="Emissions from motor vehicle sources in Baltimore"
)
lines(nei_mobile_balt$year
      ,nei_mobile_balt$pm25
      ,type="b"
      ,lwd=2
      ,lty=2
      ,col="blue"
    )
text(nei_mobile_balt$year, nei_mobile_balt$pm25, as.integer(nei_mobile_balt$pm25)
     ,pos=3
     ,offset = 0.6
     ,col="black"
)

# Los Angeles Plot
plot(nei_mobile_lac$year,
     nei_mobile_lac$pm25,
     type="n",
     xlab="Year",
     ylab="Amount of PM2.5 emitted (Tons)",
     main="Emissions from motor vehicle sources in Los Angeles"
)

# Los Angles Plot
lines(nei_mobile_lac$year
      ,nei_mobile_lac$pm25
      ,type="b"
      ,lwd=2
      ,lty=2
      ,col="green"
    )
text(nei_mobile_lac$year, nei_mobile_lac$pm25, as.integer(nei_mobile_lac$pm25)
     ,pos=3
     ,offset = 0.6
     ,col="black"
    )

# Close the device
dev.off()
message("device closed")

#free the memory
rm(NEI);rm(SCC);
rm(scc_index);rm(scc_codes)
rm(nei_mobile);rm(nei_mobile_balt)