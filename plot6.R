library(data.table)
library(dplyr)
library(ggplot2)

# Load the NEI & SCC data frames.
NEI <- data.table::as.data.table(x = readRDS("summarySCC_PM25.rds"))
SCC <- data.table::as.data.table(x = readRDS("Source_Classification_Code.rds"))

# Gather the subset of the NEI data which corresponds to vehicles
vehiclesSCC <- SCC %>%
        filter(grepl('[Vv]ehicle', SCC.Level.Two)) %>%
        select(SCC, SCC.Level.Two)
totalEmissions2Locations <- NEI %>%
        filter(fips == '24510' | fips == '06037') %>%
        select(fips, SCC, Emissions, year) %>%
        inner_join(vehiclesSCC, by = 'SCC') %>%
        group_by(fips, year) %>%
        summarise(totalEmission =  sum(Emissions, na.rm = TRUE)) %>%
        select(totalEmission, fips, year)

totalEmissions2Locations$fips <- gsub('24510', 'Baltimore City', totalEmissions2Locations$fips)
totalEmissions2Locations$fips <- gsub('06037', 'Los Angeles County', totalEmissions2Locations$fips)

# Create the plot

TwoLocationsPlot <- ggplot(totalEmissions2Locations, aes(x = factor(year), y = totalEmission, fill = fips)) +
        geom_bar(stat = "identity", width = 0.7) +
        facet_grid(.~fips) + 
        labs(x = "Year", y = "Emissions (Tons)", title = "Comparison of Motor Vehicle Related Emissions Between Baltimore City and Los Angeles From 1999 - 2008") +
        theme(plot.title = element_text(size = 14),
              axis.title.x = element_text(size = 12),
              axis.title.y = element_text(size = 12),
              strip.text.x = element_text(size = 12)) +
        theme_dark() 
ggsave("plot6.png", height = 30, width = 30, units = 'cm')

print(TwoLocationsPlot)
