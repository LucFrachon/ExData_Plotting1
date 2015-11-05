library(lubridate)  # We will use lubridate to easily convert strings into date/time

if (!file.exists("data")) dir.create("data")  # Create directory to store data if not present
if (!file.exists("figure")) dir.create("figure")  # Create directory to store figures if not present

if (!file.exists("./data/household_power_consumption.txt")) {  # Download and extract data file if
                                                               # required only        
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, "./data/household_power_consumption.zip")
        unzip("./data/household_power_consumption.zip", exdir = "data")
        }

classes <- sapply(read.table("./data/household_power_consumption.txt", sep = ";",  # Get col.classes
                             header = TRUE, nrows = 10), class)        # from limited sample of rows
selectedSet <- read.table("./data/household_power_consumption.txt", sep = ";",  # Read the required
                         skip = 66637, nrows = 2880, na.strings = "?",  # rows from the data file
                         col.names = c("date", 
                                      "time",
                                      "globalActivePower",
                                      "globalReactivePower",
                                      "voltage",
                                      "globalIntensity",
                                      "subMetering1",
                                      "subMetering2",
                                      "subMetering3"),
                         colClasses = classes)

dateTime <- dmy_hms(mapply(paste, selectedSet$date, selectedSet$time))  # Concatenate date and time,
selectedSet <- cbind(dateTime, selectedSet[, 3:9])  # convert to date/time and replace first two 
                                                    # columns

with(selectedSet, hist(globalActivePower, main = "Global Active Power", col = "red", 
                       xlab = "Global Active Power (kilowatts)"))  # Build histogram
dev.copy(png, filename = "./figure/plot1.png")  # Copy to png file
dev.off()  # Close device
     
