#load packages
library(tidyverse)
library(knitr)
library(crayon)
library(tinytex)
library(ggplot2)
library(rmarkdown)
library(tibble)
library(readxl)
library(dplyr)

#Load data. Then, Move variable names from row one into column headers.
FIW = read_xlsx("All_data_FIW_2013-2023.xlsx", sheet = 2)
colnames(FIW) <- as.character(FIW[1, ])
FIW <- FIW[-1, ]

#Create a new data set that only focuses on the columns relating to country name, year, and political rights (along with political rights related questions.)
FIW.pol = subset(FIW, select = c(1,2,4,5,8,9,10,12,13,14,15,17,18,19,21,22,23))

#Create a new data set that uses the above columns, but only includes data from states from Former Soviet Union from 2019 to 2023.
FIW.FSU = FIW.pol |>
  filter(`Country/Territory`%in% c("Armenia", "Azerbaijan", "Belarus", "Estonia", "Georgia",
                                   "Kazakhstan", "Kyrgyzstan", "Latvia", "Lithuania", "Moldova", 
                                   "Russia", "Tajikistan", "Turkmenistan", "Ukraine", "Uzbekistan"), 
         Edition %in% c("2019","2020", "2021", "2022", "2023"))

#Rename columns. Rename values in "Status" column to provide more clarity. Rename values in Extra Q2 to reflect that they are missing.
new_column_names = c("Country", "Region", "Year", "Status", "HOG.Free", "Leg.Free",
                     "Legal.Framework", "Assembly", "Opposition.Chance", "Ext.Pol.Pressure",
                     "Equal.Vote", "Policy", "Corruption", "Transparency", "Extra.Q", "Extra.Q2", "Political.Rating")
colnames(FIW.FSU) = new_column_names

FIW.FSU <- FIW.FSU |>
  mutate(Status = case_when(
    Status == "PF" ~ "Partly Free",
    Status == "NF" ~ "Not Free",
    Status == "F" ~ "Free"))


FIW.FSU[FIW.FSU == "N/A"] <- NA

#Export data as csv file
write.csv(FIW.FSU, file = "FIW.FSU.2019-2023.csv", row.names = FALSE)

#Save data as Rdata file
save(FIW.FSU, file = "FIW.FSU.2019-2023.RData")
