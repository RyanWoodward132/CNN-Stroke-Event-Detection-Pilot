# RW.R
# This file contains the R code used to process the RAW accelerometer data of RW
# This file contains the R code used to process the Event data of RW

#+ Load Libraries
library(readr)
library(lubridate)
library(tidyverse)
library(ggplot2)
library(patchwork)
library(stringr)

#+ Import data
acc = read.csv("Data/Temp/Accel/RW.csv", header = T)
e05 = read.csv("Data/Temp/Events/RW_5.csv", header = F)
e15 = read.csv("Data/Temp/Events/RW_15.csv", header = F)
e25 = read.csv("Data/Temp/Events/RW_25.csv", header = F)
e35 = read.csv("Data/Temp/Events/RW_35.csv", header = F)
e45 = read.csv("Data/Temp/Events/RW_45.csv", header = F)

#+ Convert acc$Time to elapsed time in seconds from first timestamp
acc$Time = dmy_hms(acc$Time)
acc$Time = round(as.numeric(difftime(acc$Time, acc$Time[1], units = "secs")), 2)

#+ Export acc to Data/Raw/Accel
write.csv(acc, file = "Data/Raw/Accel/RW.csv")

#+ Remove [0x0 double] and sync and coerce V4 to numeric
e05 = e05[e05$V1 != "[0x0 double]", ]
e15 = e15[e15$V1 != "[0x0 double]", ]
e25 = e25[e25$V1 != "[0x0 double]", ]
e35 = e35[e35$V1 != "[0x0 double]", ]
e45 = e45[e45$V1 != "[0x0 double]", ]

#Save Start point before removing
start = e05$V4[e05$V2 == "Start"]

e05 = e05[e05$V1 != "Sync",]
e15 = e15[e15$V1 != "Sync",]
e25 = e25[e25$V1 != "Sync",]
e35 = e35[e35$V1 != "Sync",]
e45 = e45[e45$V1 != "Sync",]

e05$V4 = as.numeric(e05$V4)
e15$V4 = as.numeric(e15$V4)
e25$V4 = as.numeric(e25$V4)
e35$V4 = as.numeric(e35$V4)
e45$V4 = as.numeric(e45$V4)

#+ Adjust timecode of events to match and combine into one event df
# Each section is unique and will need to be handled manually
# Find matching events in each file using the videos and sync them
# Then remove duplicate events from files

# e05 - e15
# e05[2,] and e15[1,] are the same event 
e15$V4 = e15$V4 + 38.34
# Removing duplicate files


# e15 - e25
# From the videos we can see that e15[27] and e25[1] are the same event
e25$V4 = e25$V4 - 48.98

# e25 - e35 
# From the videos we can see that 


# Remove duplicate events

e05 = e05[-c(6:10),]
e15 = e15[-c(1,2),]

e15 = e15[-c(27:32), ]
e25 = e25[-c(71:81), ]