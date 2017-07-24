7/12/17

Objective: We have files with Japanese and Latino cohort combined. By using "less -S" on said file (3 of them which are phenotype files), there is a column which indicates J or L. 
    Create bed, bim, fam files (for each ethnicity) and separate each cohort by ethnicity. 
   
7/17/17

awk '$10 == L' /home/wheelerlab1/Data/dbGaP_Prostate_prj_13579/phs000306.v4.pht001911.v1.p1.c1.MEC_Prostate_Cancer_JALA_Subject_Phenotypes.DS-CA-PUB-MDS.txt > /home/mohammed/JA_pheno.txt

#We need to use R to separate the rows. UPDATE: messing up, using just UNIX to cut and paste the data into one big file. 

Idea: Take out the first 11 lines, copy rest to a file. Then from there copy whose file has L in 4th column. 
exclude first 11 lines out of 1066 lines

sed -n -e '12,1066p' /home/wheelerlab1/Data/dbGaP_Prostate_prj_13579/phs000306.v4.pht001911.v1.p1.c1.MEC_Prostate_Cancer_JALA_Subject_Phenotypes.DS-CA-PUB-MDS.txt > /home/mohammed/test
sed -n -e '12,1725p' /home/wheelerlab1/Data/dbGaP_Prostate_prj_13579/phs000306.v4.pht001911.v1.p1.c2.MEC_Prostate_Cancer_JALA_Subject_Phenotypes.GRU-MDS.txt > /home/mohammed/test1
sed -n -e '12,1711p' /home/wheelerlab1/Data/dbGaP_Prostate_prj_13579/phs000306.v4.pht001911.v1.p1.c5.MEC_Prostate_Cancer_JALA_Subject_Phenotypes.HMB-PUB-MDS.txt > /home/mohammed/test2
#So from the 3 phenotype files, everything is copied into those 3 files and now combine

cat test test1 test2 >> test3
    #Check file lengths individually to make sure it adds up, 4469 lines

mkdir px_prostate_cancer_JA
mkdir px_prostate_cancer_LA

7/19/17

column -t test3 > test4
    #This takes data in test3 and makes it into columns 
awk '{print NF}' test4 | sort -nu | tail -n 1
    #We have 20 columns in test4, as expected.

awk '{print > $4".txt"}' test4
    #This makes 2 files, J.txt and L.txt, in which J.txt has all rows with J in column 4
    #So we can see we have 2263 Japanese and 2206 Latino people in our cohort. 
mv /home/mohammed/J.txt /home/mohammed/px_prostate_cancer_JA/
mv /home/mohammed/L.txt /home/mohammed/px_prostate_cancer_LA/

#Now we have to make the files into bed/bim/fam files. 
#Dr. Wheeler said to use dplyr in r or rstudio to essentially create a file with FID and IID (2 column file) in which I can then create the bed/bim/fam files.

#Problem is that the rows in L.txt and J.txt have different number of columns, so copy the first 4 columns (important ones) to another file. 
awk '{print $1,$2,$3,$4}' L.txt > LA.txt
awk '{print $1,$2,$3,$4}' J.txt > JA.txt
    #So the 2 new files have the important first 4 columns from the original 2 files. 
    
#In Rstudio now
#For latino pop
install.packages("dplyr")
library(dplyr)
data <- read.table("/home/mohammed/px_prostate_cancer_LA/LA.txt")
latino <- filter(data, V4 == "L")
latino_plink <- select(latino, V2)
latino_plink <- mutate (latino_plink, FID=0)
latino_final <- select(latino_plink, FID, V2)
write.table(latino_final, file = "latino.list.txt", quote = F, row.names = F, col.names = F)

#For Japanese pop
datainstall.packages("dplyr")
library(dplyr)
data1 <- read.table("/home/mohammed/px_prostate_cancer_JA/JA.txt")
japanese <- filter(data1, V4 == "J")
japense_plink <- select(japanese, V2)
japense_plink <- mutate(japense_plink, FID = 0)
japense_final <- select(japense_plink, FID, V2)
write.table(japense_final, file = "japanese.list.txt", quote = F, row.names = F, col.names = F)

#In terminal
#Now have to put plink command to make the bed/bim/fam file.
 
