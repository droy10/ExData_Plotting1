# First we download and unzip the (full) data set, in the working directory:
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "household_power_consumption.zip", method = "curl")
unzip("household_power_consumption.zip", exdir = ".")

# We create a data frame with the full dataset:
hpc_full <- read.table("household_power_consumption.txt", header = TRUE, sep = ";")

# We create a subset with only the 2 dates that interest us:
hpc_subset <- subset(hpc_full, Date == "1/2/2007" | Date == "2/2/2007")

# We create a new DateTime variable, to be the x-axis of the graph:
hpc_subset$DateTime <- as.POSIXct(paste(hpc_subset$Date, hpc_subset$Time), format = "%d/%m/%Y %H:%M:%S")

# We open a new device, to write to the png file:
png("plot2.png", width = 480, height = 480)

# We use the "stringi" library to easily trim spaces in the "Global Active Power" field:
library(stringi)

# We can now create the plot:
plot(hpc_subset$DateTime, as.numeric(stri_trim_both(hpc_subset[, 3])),
     main = NULL,
     ylab = "Global Active Power (kilowatts)",
     xlab = "",
     type = "l")

dev.off()
