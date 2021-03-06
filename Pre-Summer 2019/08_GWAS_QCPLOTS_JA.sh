7/26/17

library(dplyr)
library("dplyr", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.4")
library(tidyr)
library("tidyr", lib.loc="/usr/local/lib/R/site-library")
library(ggplot2)
library("ggplot2", lib.loc="/usr/local/lib/R/site-library")
library(sas7bdat)
"%&%" = function(a,b) paste(a,b,sep="")
my.dir= "/home/mohammed/px_prostate_cancer_JA/"
lmiss <- read.table(my.dir %&% "QC.lmiss" ,header=T)
hist(lmiss$F_MISS) #Saved as hist1
dim(lmiss)[1]
    [1] 657366
table(lmiss$F_MISS<0.01)
     FALSE   TRUE 
    116239 541127 
imiss <- read.table(my.dir %&% "QC3.imiss",header=T )
hist(imiss$F_MISS) #Saved as hist2

newlmiss <- read.table(my.dir %&% "QC3.lmiss",header=T)
hist(newlmiss$F_MISS) #histnewlmiss

dim(newlmiss)[1]
[1] 541127
> dim(imiss)[1]
[1] 1934

ibd <- read.table(my.dir %&% "QC5b2.genome",header = T)
ggplot(data=ibd,aes(x=Z0,y=Z1))+geom_point(alpha=1/4)+theme_bw()+coord_cartesian(xlim = c(0,1), ylim = c(0,1))

hapmap <- filter(ibd,grepl("NA",IID1))
hapmap
 [1] FID1   IID1   FID2   IID2   RT     EZ     Z0     Z1     Z2    
[10] PI_HAT PHE    DST    PPC    RATIO 
  <0 rows> (or 0-length row.names)
toExclude <- c(as.character(dups$IID1),as.character(hapmap$IID1))
a <- as.character(ibd$IID1) %in% toExclude
others <- ibd[a==FALSE,]
dim(others)
  [1] 1560261      14
  
pihat0.5<-filter(ibd,ibd$PI_HAT>=0.05)
hist(pihat0.5$PI_HAT)  #pihat0.5
dim(pihat0.5)
[1] 1478338      14


7/31/17

#Going to redo everything after taking out sex chromosomes
#I'm not going to delete the other graphs, but I'm going to have more specific names in the future. 

library(dplyr)
library(tidyr)
library(ggplot2)
library(sas7bdat)
"%&%" = function(a,b) paste(a,b,sep="")
my.dir= "/home/mohammed/px_prostate_cancer_JA/"
lmiss <- read.table(my.dir %&% "QC.lmiss" ,header=T)
hist(lmiss$F_MISS) #Saved as lmisshistogram.png in /home/mohammed/QC_plots_JA
dim(lmiss)[1]
    [1] 657366
table(lmiss$F_MISS<0.01)

     FALSE   TRUE 
    116239 541127 
imiss <- read.table(my.dir %&% "QC3.imiss",header=T )
hist(imiss$F_MISS) #Saved as imisshistogram.png 
newlmiss <- read.table(my.dir %&% "QC3.lmiss",header=T)
hist(newlmiss$F_MISS) #Saved as newlmisshistogram.png
dim(newlmiss)[1]
    [1] 528136
dim(imiss)[1]
    [1] 1934
ibd <- read.table(my.dir %&% "QC5b.genome",header = T)
ggplot(data=ibd,aes(x=Z0,y=Z1))+geom_point(alpha=1/4)+theme_bw()+coord_cartesian(xlim = c(0,1), ylim = c(0,1))  #Saved as ggplotprerelcutoff.png
ibd <- read.table(my.dir %&% "QC5b2.genome",header = T)
ggplot(data=ibd,aes(x=Z0,y=Z1))+geom_point(alpha=1/4)+theme_bw()+coord_cartesian(xlim = c(0,1), ylim = c(0,1))  #Saved as ggplotpostrelcutoff.png

toExclude <- c(as.character(dups$IID1),as.character(hapmap$IID1))
a <- as.character(ibd$IID1) %in% toExclude
others <- ibd[a==FALSE,]
dim(others)
    [1] 1560261      14
sortOthers<-others[order(others$PI_HAT,decreasing=TRUE),]
> filter(others,PI_HAT>=0.2)
     [1] FID1   IID1   FID2   IID2   RT     EZ     Z0     Z1    
     [9] Z2     PI_HAT PHE    DST    PPC    RATIO 
      <0 rows> (or 0-length row.names)
      

hapmap <- filter(ibd,grepl("NA",IID1))
hapmap
     [1] FID1   IID1   FID2   IID2   RT     EZ     Z0     Z1    
     [9] Z2     PI_HAT PHE    DST    PPC    RATIO 
    <0 rows> (or 0-length row.names)
pihat0.5<-filter(ibd,ibd$PI_HAT>=0.05) 
hist(pihat0.5$PI_HAT)  #saved as pihat0.5histogram
dim(pihat0.5)  
    [1] 1478336      14


hetfile <- "QC5c.het"
> HET <- read.table(my.dir %&% hetfile,header = T,as.is = T)
> H = (HET$N.NM.-HET$O.HOM.)/HET$N.NM.
> oldpar=par(mfrow=c(1,2))
> hist(H,50) #Saved as histogramH.png
> hist(HET$F,50) #Saved as histogramHET$F.png

summary(HET$F)
         Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
    -0.145000 -0.001775  0.002525  0.006623  0.007885  0.214400
    
 par(oldpar)
> sortHET<-HET[order(HET$F),]
> outliers<-data.frame()
> for(i in 1:length(sortHET$F)){
+     if(sortHET[i,6] > (mean(sortHET$F)+3*sd(sortHET$F))){
+         outliers <- rbind(outliers,sortHET[i,]) 
+     }
+     if(sortHET[i,6] < (mean(sortHET$F)-3*sd(sortHET$F))){
+         outliers <- rbind(outliers,sortHET[i,])
+     }
+ }
> hetoutliers <- select(outliers,FID,IID)
> dim(hetoutliers)
    [1] 46  2

allexclude2 <- hetoutliers 
> write.table(allexclude2,file = "/home/mohammed/px_prostate_cancer_JA/QC5.txt", quote = F, col.names = F, row.names = F)

imissnew <- read.table(my.dir %&% "QC5b3.imiss", header=T)
> dim(imissnew)
    [1] 1767    6
> dim(imissnew)[1]-dim(hetoutliers)[1]
    [1] 1721

#   LIFTOVER DONE

pca.dir = "/home/mohammed/px_prostate_cancer_JA/"
> hapmappopinfo <- read.table("/home/wheelerlab1/Data/HAPMAP3_hg19/pop_HM3_hg19_forPCA.txt") %>% select (V1,V3)
> colnames(hapmappopinfo) <- c("pop","IID")
> fam <- read.table("/home/mohammed/px_prostate_cancer_JA/QC6e1.fam") %>% select (V1,V2)
> colnames(fam) <- c("FID","IID")
> popinfo <- left_join(fam,hapmappopinfo,by="IID")
    Warning message:
    Column `IID` joining factors with different levels, coercing to character vector 
popinfo <- mutate(popinfo, pop=ifelse(is.na(pop),'GWAS', as.character(pop)))
> table(popinfo$pop)
     ASN  CEU GWAS  YRI 
     170  111 1767  110 
> pcs <- read.table("/home/mohammed/px_prostate_cancer_JA/QC6e1.evec",skip=1)
> pcdf <- data.frame(popinfo, pcs[,2:11]) %>% rename (PC1=V2,PC2=V3,PC3=V4,PC4=V5,PC5=V6,PC6=V7,PC7=V8,PC8=V9,PC9=V10,PC10=V11)
> gwas <- filter(pcdf,pop=='GWAS')
> hm3 <- filter(pcdf, grepl('NA',IID))
> eval <- scan('/home/mohammed/px_prostate_cancer_JA/QC6e1.eval')[1:10]
    Read 2158 items
round(eval/sum(eval),3)
     [1] 0.702 0.206 0.031 0.014 0.008 0.008 0.008 0.008 0.008
    [10] 0.008
ggplot() + geom_point(data=gwas,aes(x=PC1,y=PC2,col=pop,shape=pop))+geom_point(data = hm3,aes(x=PC1,y=PC2,col=pop,shape=pop))+theme_bw() +scale_colour_brewer(palette ="Set1")
    #Saved as PC1vsPC2
> ggplot() + geom_point(data=gwas,aes(x=PC1,y=PC3,col=pop,shape=pop))+geom_point(data=hm3,aes(x=PC1,y=PC3,col=pop,shape=pop))+theme_bw() + scale_colour_brewer(palette = "Set1")
    #Saved as PC1vsPC3
> ggplot()+geom_point(data=gwas,aes(x=PC2,y=PC3,col=pop,shape=pop))+geom_point(data=hm3,aes(x=PC2,y=PC3,col=pop,shape=pop))+theme_bw()+scale_colour_brewer(palette = "Set1")
    #Saved as PC2vsPC3
  
#So pcaplot1 looks good, Japanese cluster tightly with Asian population, as expected. However, there is one outlier (green dot) that needs to be removed, probably will do with dplyr on R
#pcaplot2 looks a little off but probably because hapmap population is of Japanese in Tokyo. Our data may have Japanese that are from different cities or nearby islands (theory). 
#Same for pcaplot3 as for pcaplot2
#Next potential steps are to go back to all three populations and run smartpca with the gwas NOT merged with hapmap 
    #It'll look more like a cloud cluster
#Then we can move on to prepping for imputation and getting Hispanic data ready for using a Native American reference population to get a right pca. 

#To remove that one outlier on ggplot graphs, view the file and find the person with the outlier value. 
#Make a new file with that one outlier taken out. 
    gwasnew <- gwas[-c(1047), ]
#Switch out "data=gwas" for "data=gwasnew"
    gplot() + geom_point(data = gwasnew,aes(x=PC1,y=PC2,col=pop,shape=pop))+geom_point(data = hm3,aes(x=PC1,y=PC2,col=pop,shape=pop))+theme_bw() +scale_colour_brewer(palette ="Set1")
        #Saved as PC1vsPC2new
    ggplot() + geom_point(data=gwasnew,aes(x=PC1,y=PC3,col=pop,shape=pop))+geom_point(data=hm3,aes(x=PC1,y=PC3,col=pop,shape=pop))+theme_bw() + scale_colour_brewer(palette = "Set1")
        #PC1vsPC3new
    ggplot()+geom_point(data=gwasnew,aes(x=PC2,y=PC3,col=pop,shape=pop))+geom_point(data=hm3,aes(x=PC2,y=PC3,col=pop,shape=pop))+theme_bw()+scale_colour_brewer(palette = "Set1")
        #PC3vsPC2new

    
    




Do hapmap with only GWAS populations



