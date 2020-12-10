unzip(zipfile = 'exdata_data_ NEI_data.zip')


SCC <- data.table::data.table(readRDS('Source_Classification_Code.rds'))
NEI <- data.table::data.table(readRDS('summarySCC_PM25.rds'))

# 
NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalNEI <- NEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

barplot(totalNEI$Emissions
        , names = totalNEI$year
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions over the Years")

#Save the plot
dev.copy(png, 'plot1.png')
dev.off()