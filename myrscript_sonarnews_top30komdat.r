#!/usr/bin/Rscript

cat("Hello")

library(lsa)
data(stopwords_nl)
mySonarmatrix_d = textmatrix("/vol/tensusers/ihendrickx/Data/LSA/R_Sonar/Sonar10K1line/NewsFilt_top30K", language="dutch")
spaceSonar = lsa( mySonarmatrix_d, 300)

mydirlist = list.dirs("/vol/tensusers/ihendrickx/Data/LSA/R_Sonar/sonar_10knews/vocab_top30K/omdatQP/")
for (i in 2:length(mydirlist)){ 
 wantmatrix = textmatrix(mydirlist[i],vocabulary=rownames(mySonarmatrix_d))
 myfoldmatrix = fold_in(wantmatrix ,spaceSonar)
 mycos = cosine(myfoldmatrix[,1],myfoldmatrix[,2])
 setwd(mydirlist[i])
 write(mycos, file="computed_cosine.txt") 
}


