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
acc = read.csv("Data/Raw/Accel/RW.csv", header = T)
e05 = read.csv("Data/Raw/Events/RW_5.csv", header = F)
e15 = read.csv("Data/Raw/Events/RW_15.csv", header = F)
e25 = read.csv("Data/Raw/Events/RW_25.csv", header = F)
e35 = read.csv("Data/Raw/Events/RW_35.csv", header = F)
e45 = read.csv("Data/Raw/Events/RW_45.csv", header = F)

#+ Convert acc$Time to elapsed time in seconds from first timestamp
acc$Time = dmy_hms(acc$Time)
acc$Time = round(as.numeric(difftime(acc$Time, acc$Time[1], units = "secs")), 2)

#+ Creating new features
# We want to calculate Jerk and absolute Jerk as additional variables
# Jerk is the time-derivative of acceleration (da/dt), computed per axis.
# Per-axis jerk = diff(acceleration) / diff(Time); first row has no prior, so NA.
acc$jerkV = c(NA, diff(acc$Vertical) / diff(acc$Time))
acc$jerkL = c(NA, diff(acc$Lateral)  / diff(acc$Time))
acc$jerkS = c(NA, diff(acc$Sagittal) / diff(acc$Time))

# Jerk: resultant magnitude of the three per-axis jerks
acc$JerkMag = sqrt(acc$jerkV^2 + acc$jerkL^2 + acc$jerkS^2)

# Absolute Jerk: sum of the absolute per-axis jerks
acc$AbsJerk = abs(acc$jerkV) + abs(acc$jerkL) + abs(acc$jerkS)

#+ Export acc to Data/Raw/Accel
write.csv(acc, file = "Data/Processed/Accel/RW.csv")

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
# Removing duplicate events



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

#+ Graph acceleration axes vs time
p_vert = ggplot(acc, aes(x = Time, y = Vertical)) +
  geom_line(colour = "#2196F3") +
  labs(x = NULL, y = "Vertical") +
  theme_minimal()

p_lat = ggplot(acc, aes(x = Time, y = Lateral)) +
  geom_line(colour = "#4CAF50") +
  labs(x = NULL, y = "Lateral") +
  theme_minimal()

p_sag = ggplot(acc, aes(x = Time, y = Sagittal)) +
  geom_line(colour = "#F44336") +
  labs(x = "Time (s)", y = "Sagittal") +
  theme_minimal()

p_vert / p_lat / p_sag

#+ Graph jerk axes and magnitude vs time
j_sag = ggplot(acc, aes(x = Time, y = jerkS)) +
  geom_line(colour = "#F44336") +
  labs(x = NULL, y = "Jerk Sagittal") +
  theme_minimal()

j_vert = ggplot(acc, aes(x = Time, y = jerkV)) +
  geom_line(colour = "#2196F3") +
  labs(x = NULL, y = "Jerk Vertical") +
  theme_minimal()

j_lat = ggplot(acc, aes(x = Time, y = jerkL)) +
  geom_line(colour = "#4CAF50") +
  labs(x = NULL, y = "Jerk Lateral") +
  theme_minimal()

j_mag = ggplot(acc, aes(x = Time, y = JerkMag)) +
  geom_line(colour = "#9C27B0") +
  labs(x = "Time (s)", y = "Jerk Magnitude") +
  theme_minimal()

j_sag / j_vert / j_lat / j_mag
