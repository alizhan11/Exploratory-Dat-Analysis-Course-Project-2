library(data.table)
library(ggplot2)

# Load the NEI & SCC data frames.
NEI <- data.table::as.data.table(x = readRDS("summarySCC_PM25.rds"))
SCC <- data.table::as.data.table(x = readRDS("Source_Classification_Code.rds"))

# Gather the subset of the NEI data which corresponds to vehicles
vehiclesSCC <- SCC %>%
        filter(grepl('[Vv]ehicle', SCC.Level.Two)) %>%
        select(SCC, SCC.Level.Two)

totalEmissionBaltimore <- NEI %>%
        filter(fips == "24510") %>%
        select(SCC, fips, Emissions, year) %>%
        inner_join(vehiclesSCC, by = "SCC") %>%
        group_by(year) %>%
        summarise(Total_Emissions = sum(Emissions, na.rm = TRUE)) %>%
        select(Total_Emissions, year)

BaltimoreVehiclesPlot <- ggplot(totalEmissionBaltimore, aes(factor(year), Total_Emissions)) +
        geom_bar(stat = "identity", fill = "sienna3", width = 0.5) +
        labs(x = "Year", y = "Emissions (Tons)", title = "Total Motor Vehicle Related Emissions In Baltimore City From 1999 - 2008") +
        theme(plot.title = element_text(size = 14),
              axis.title.x = element_text(size = 12),
              axis.title.y = element_text(size = 12))

print(Baltimore_Vehicles_Plot)

ggsave("plot5.png", width = 30, height = 30, units = "cm")

dev.off()
