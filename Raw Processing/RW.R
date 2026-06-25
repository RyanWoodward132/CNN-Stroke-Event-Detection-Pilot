# RW.R
# This file contains the R code used to process the RAW accelerometer data of RW
# This file contains the R code used to process the Event data of RW

### AccelAnalysisV2.R
### Exploratory Data Analysis for accelerometer data and events
### Building dataframe for use with model

#+ Load Libraries
library(readr)
library(lubridate)
library(tidyverse)
library(ggplot2)
library(patchwork)
library(stringr)

#+ Import data
acc = read.csv("Data/Raw/Temp/Accel/RW.csv", header = T)
e05 = read.csv("Data/Raw/Temp/Events/RW_5.csv", header = F)
e15 = read.csv("Data/Raw/Temp/Events/RW_15.csv", header = F)
e25 = read.csv("Data/Raw/Temp/Events/RW_25.csv", header = F)
e35 = read.csv("Data/Raw/Temp/Events/RW_35.csv", header = F)
e45 = read.csv("Data/Raw/Temp/Events/RW_45.csv", header = F)

#+ Convert acc$Time to elapsed time in seconds from first timestamp
acc$Time <- dmy_hms(acc$Time)
acc$Time <- round(as.numeric(difftime(acc$Time, acc$Time[1], units = "secs")), 2)

#+ Export acc to Data/Raw/Accel
write.csv(acc, file = "Data/Raw/Accel/RW.csv")

#+ Remove [0x0 double] and coerce V4 to numeric
e05 = e05[e05$V1 != "[0x0 double]", ]
e15 = e15[e15$V1 != "[0x0 double]", ]
e25 = e25[e25$V1 != "[0x0 double]", ]
e35 = e35[e35$V1 != "[0x0 double]", ]
e45 = e45[e45$V1 != "[0x0 double]", ]

e05$V4 = as.numeric(e05$V4)
e15$V4 = as.numeric(e15$V4)
e25$V4 = as.numeric(e25$V4)
e35$V4 = as.numeric(e35$V4)
e45$V4 = as.numeric(e45$V4)

#+ Adjust timecode of events to match and combine into one event df
# Each section is unique and will need to be handled manually
  # e05 - e15
  # From the videos we can see that e05[6,] and e15[77,] are the same event
  # take the time difference of these to sync them
e15$V4 = e15$V4 + 38.42
  # They are now synced, we can now remove duplicate events
e05 = e05[-c(6:10),]
e15 = e15[-c(1,2),]
