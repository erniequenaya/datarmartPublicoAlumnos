# en este R se preparan los csv q llenaran las tablas dimension del datamart
# algunos pasos se icieron editando texto a mano x lo q puede q el codigo R de aqi NO reproduzca perfectamente los .csv
# q estan en el .7z
# estos .csv seran usados por pentaho q los subira a una DB local llamada 'bi2' , el .kjb los sube en orden q respeta 
# las restricciones FK de la DB
setwd("Descargas/forBI/datasets/")
library(data.table)
dat <- fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("RBD","DGV_RBD","NOM_RBD"),header = TRUE)

# fill dim lugar
dat<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("COD_REG_RBD","NOM_REG_RBD_A","COD_PRO_RBD","COD_COM_RBD","NOM_COM_RBD","COD_DEPROV_RBD","NOM_DEPROV_RBD"),header = TRUE)
datLevel<-unique(dat)
datLevel
#unique.matrix(dat$RBD,dat$NOM_RBD)
write.table(datLevel,'rendimiento/dims/lugar2.csv',sep = ";",append = TRUE)
# ------------ end dim lugar------------------------

# fill dim escuela -- MALO
dat<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("RBD","COD_REG_RBD","COD_PRO_RBD","COD_COM_RBD","COD_DEPROV_RBD","DGV_RBD","NOM_RBD","RURAL","ESTADO_ESTAB"),header = TRUE)
datLevel<-unique(dat)
datLevel
write.table(datLevel,'rendimiento/dims/escuela.csv',sep = ",",append = TRUE)
# ------------ end dim escuela------------------------

# fill dim curso
dat<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("LET_CUR","COD_JOR","COD_TIP_CUR"),header = TRUE)
datLevel<-unique(dat)
datLevel
write.table(datLevel,'rendimiento/dims/curso.csv',sep = ",",append = TRUE)
# ------------ end dim curso------------------------

# fill dim ensenanza
dat<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("COD_ENSE","COD_ENSE2"),header = TRUE)
dat<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("COD_ENSE"),header = TRUE)
datLevel<-unique(dat)
datLevel
write.table(datLevel,'rendimiento/dims/curso.csv',sep = ",",append = TRUE)
# ------------ end dim ensenanza------------------------

# fill dim espe 
dat<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("COD_ESPE","COD_SEC","COD_RAMA"),header = TRUE)
datLevel<-unique(dat)
datLevel
write.table(datLevel,'rendimiento/dims/curso.csv',sep = ",",append = TRUE)
# ------------ end dim espe------------------------

# fill sit final R
dat<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("SIT_FIN","SIT_FIN_R"),header = TRUE)
datLevel<-unique(dat)
datLevel
write.table(datLevel,'rendimiento/dims/sitFinal.csv',sep = ";",append = TRUE)
# ------------ end dim sit Fin R------------------------

# fill Escuela
dat<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("RBD","DGV_RBD","COD_DEPROV_RBD","RURAL_RBD","ESTADO_ESTAB","COD_DEPE2"),header = TRUE)
sepDat<-fread("sep/Preferentes_Prioritarios_y_Beneficiarios_2018.csv",select = c("RBD","DGV_RBD","NOM_RBD","COD_COM_RBD","CONVENIO_SEP","AÑO_INGRESO_SEP","CLASIFICACION_SEP","EE_GRATUITO"),sep = ";",header = TRUE)
# algo paso pero aca ta la respuesta
# https://stackoverflow.com/questions/39497675/r-subset-data-frame-column-using-names-in-vector-list
setDF(sepDat)
setDF(dat)
sepDat[c("RBD","DGV_RBD")]
escSEP<-unique(sepDat[c("RBD","DGV_RBD")])
anyDuplicated(escSEP)

sep<-data.frame(sepDat=union(sepDat$RBD,sepDat$DGV_RBD))

mergeRBD18<-merge(x=sep,y=sepDat,by = c("RBD","DGV_RBD"),all.x = TRUE)



# testeando unicidad
sepDat[c("RBD","DGV_RBD")] 
escuelaSEP<-unique(sepDat[c("RBD","DGV_RBD")])
dat[c("RBD","DGV_RBD")]
escuelaRend<-unique(dat[c("RBD","DGV_RBD")])
escuelaRend[duplicated(escuelaRend$RBD)]
escuelaSEP[duplicated(escuelaSEP$RBD)]

# preparando union
library(dplyr)
escRend<-distinct(dat)
escSEP<-distinct(sepDat)
mergeRBD18<-merge(x=escSEP,y=escRend,by = "RBD")
head(mergeRBD18)
# salvando union
write.table(mergeRBD18,'rendimiento/dims/escuela.csv',sep=",",append = FALSE)
# ------------ end dim escuela------------------------

### dim ense3
#made on vim

#dat <- as.factor(dat)
#sapply(dat,levels)

### escuela 2017 y 2016
dat18<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("RBD","DGV_RBD","COD_DEPROV_RBD","RURAL_RBD","ESTADO_ESTAB","COD_DEPE2"),header = TRUE)
sepDat18<-fread("sep/Preferentes_Prioritarios_y_Beneficiarios_2018.csv",select = c("RBD","DGV_RBD","NOM_RBD","COD_COM_RBD","CONVENIO_SEP","AÑO_INGRESO_SEP","CLASIFICACION_SEP","EE_GRATUITO"),sep = ";",header = TRUE)
dat17<-fread("rendimiento/20180213_Rendimiento_2017_20180131_PUBL.csv",select = c("RBD","DGV_RBD","COD_DEPROV_RBD","RURAL_RBD","ESTADO_ESTAB","COD_DEPE2"),header = TRUE)
sepDat17<-fread("sep/Preferentes_Prioritarios_y_Beneficiarios_2017.csv",select = c("RBD","DGV_RBD","NOM_RBD","COD_COM_RBD","CONVENIO_SEP","AÑO_INGRESO_SEP","CLASIFICACION_SEP","EE_GRATUITO"),sep = ";",header = TRUE)
dat16<-fread("rendimiento/20170216_Rendimiento_2016_20170131_PUBL.csv",select = c("RBD","DGV_RBD","COD_DEPROV_RBD","RURAL_RBD","ESTADO_ESTAB","COD_DEPE2"),header = TRUE)
sepDat16<-fread("sep/Preferentes_Prioritarios_y_Beneficiarios_2016.csv",select = c("RBD","DGV_RBD","NOM_RBD","COD_COM_RBD","CONVENIO_SEP","AÑO_INGRESO_SEP","CLASIFICACION_SEP","EE_GRATUITO"),sep = ";",header = TRUE)

setDF(sepDat18)
setDF(dat18)
setDF(sepDat17)
setDF(dat17)
setDF(sepDat16)
setDF(dat16)

sepDat18["RBD"]
sepDat18[c("RBD","DGV_RBD")]
sepDat17["RBD"]
sepDat17[c("RBD","DGV_RBD")]
sepDat16["RBD"]
sepDat16[c("RBD","DGV_RBD")]

library(dplyr)
escRend18<-distinct(dat18)
escSEP18<-distinct(sepDat18)
escRend17<-distinct(dat17)
escSEP17<-distinct(sepDat17)
escRend16<-distinct(dat16)
escSEP16<-distinct(sepDat16)

RBD18<-merge(x=escSEP18,y=escRend18,by = "RBD")
RBD17<-merge(x=escSEP17,y=escRend17,by = "RBD")
RBD16<-merge(x=escSEP16,y=escRend16,by = "RBD")

head(RBD18)
head(RBD17)
head(RBD16)

library(dplyr)
sub_res18 <- anti_join(RBD18,RBD17,by = "MRUN")
RBD17[!(RBD17$RBD %in% RBD18$RBD),]
escuelasDel17peroNoDel18<-RBD17[!(RBD17$RBD %in% RBD18$RBD),]
RBD16[!(RBD16$RBD %in% RBD18$RBD),]
escuelasDel16peroNoDel18<-RBD16[!(RBD16$RBD %in% RBD18$RBD),]

superRBD<-rbind(RBD18, escuelasDel17peroNoDel18)
rbind(superRBD, escuelasDel16peroNoDel18)
superRBD<-rbind(superRBD, escuelasDel16peroNoDel18)
# salvando union
write.table(superRBD,'rendimiento/dims/escuela3Agnos.csv',sep=",",append = FALSE)

superRBD<-read.csv(file = "rendimiento/dims/escuela3Agnos.csv",header=TRUE)
duplicated(superRBD$RBD)
superRBD[duplicated(superRBD$RBD),]
reps<-superRBD[duplicated(superRBD$RBD),]
library("dplyr")
#distinct(mydata,carb, .keep_all= TRUE)
superRBD2 <- distinct(superRBD,RBD,.keep_all = TRUE)
write.table(superRBD2,'rendimiento/dims/escuela3Agnos.csv',sep=",",append = FALSE)
