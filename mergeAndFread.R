# en este R simplemente de preparan los datos pa rellenar HECHOALUMNOS con tal de q calzen en esa tabla
# un solo año, 2018
# me tome artas libertades bien negligentes como bajar las tablas de "residencia", "grado" y la PK MRUN para hechoalumnos
# lo ideal es q esto se deba arreglar en el powerDesigner
# tmbn elimine MRUNs duplicados con promedio 0 y alumnos nivel parvulo (provenientes del SEP.csv) q no tienen promedio
# esto si se qiere se arregla desde la linea 40 de este archivo

# join sep and rend pre-upload
setwd("Descargas/forBI/datasets/")
### Correr para comparar columnas
rend18 <- read.csv(file = "rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv", header = TRUE, sep = ";",nrows = 1)
sep18 <- read.csv(file = "sep/Preferentes_Prioritarios_y_Beneficiarios_2018.csv",header = TRUE, sep= ";",nrows = 1)
library(arsenal)
comparedf(rend18,sep18)
summary(comparedf(rend18,sep18))
colnames(rend18)
### intento left join, mucho parvulos ~800k no presentan promedios x lo q seran eliminados
library(data.table)
r18<-fread("rendimient o/20190220_Rendimiento_2018_20190131_PUBL.csv",select = c("MRUN","RBD","COD_REG_RBD","COD_COM_RBD","SIT_FIN_R","PROM_GRAL"),header = TRUE)
s18<-fread("sep/Preferentes_Prioritarios_y_Beneficiarios_2018.csv",select = c("MRUN","RBD","COD_REG_RBD","COD_COM_RBD"),header = TRUE)
anyDuplicated(r18$MRUN)
# sep tiene la particularidad de no tener MRUNs duplicados, puede usarse como base
anyDuplicated(s18$MRUN)
s18[anyDuplicated(s18$MRUN)]
# intento de prune alumnos trasladados
r18<-r18[!(r18$SIT_FIN_R=="T")]
merge18<-merge(x=s18,y=r18,by = "MRUN",all.x = TRUE)
merge18[duplicated(merge18$MRUN)]
write.csv(merge18,'rendimiento/join2018v2.csv',append = FALSE)
join18<-read.csv(file = "rendimiento/join2018v2.csv",header = TRUE)
head(join18)
anyDuplicated(join18$MRUN)

### oficial
# atributos tabla hechoAlumno
#"RBD","DIGITOVERIFRBD","CODJORNADA","CODENSE","CODENSE3","CODESPE","AGNO","GENERO","FECHANACIMIENTO","EDAD","FECHAINGRESO",
# "LETRACURSO","PROMEDIO","ASISTENCIA","SITFINALR","CRITERIOSEP","PRIORITARIO","PREFERENTE","BENEFICIARIO","MRUN"
# de csv rendimiento
# "MRUN","COD_JOR","COD_ENSE","COD_ESPE","EDAD_ALU","FEC_ING_ALU","PROM_GRAL","ASISTENCIA","SIT_FIN_R","COD_COM_ALU"
# de csv sep
# "MRUN","RBD","DGV_RBD","GEN_ALU","FEC_NAC_ALU","COD_ENSE3","AGNO","CRITERIO_SEP","PRIORITARIO_ALU","PREFERENTE_ALU","BEN_SEP"
r18<-fread("rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv",select = 
             c("MRUN","COD_JOR","COD_ENSE","COD_ESPE","EDAD_ALU","PROM_GRAL","ASISTENCIA","SIT_FIN_R","COD_COM_ALU"),header = TRUE)
# fread es una funcion q permite leer solo CIERTAS columnas de un .csv
# con el proposito de q el futuro merge(sep,rendimiento) no tenga columnas repetidas es q hago esto
s18<-fread("sep/Preferentes_Prioritarios_y_Beneficiarios_2018.csv",select = 
             c("MRUN","RBD","DGV_RBD","GEN_ALU","FEC_NAC_ALU","COD_ENSE3","AGNO","CRITERIO_SEP","PRIORITARIO_ALU","PREFERENTE_ALU","BEN_SEP"),header = TRUE)
anyDuplicated(r18$MRUN)
anyDuplicated(s18$MRUN)
# merge
alumno18<-merge(x=s18,y=r18,by = "MRUN")
# grabado temporal para no volver a leer 6 palos de registros de r18 y s18
write.csv(alumno18,'rendimiento/dims/hechoAlu',append = FALSE)
# prune alumnos trasladados con promedio 0 que causan repeticiones inutiles al dataset
alu18<-alumno18[duplicated(alumno18$MRUN) | duplicated(alumno18$MRUN,fromLast = TRUE)]
alu18<-alu18[alu18$SIT_FIN_R=="T" & alu18$PROM_GRAL<1]
#alu18<-alumno18[!(alumno18$SIT_FIN_R=="T" & alumno18$PROM_GRAL==0 & duplicated(alumno18$MRUN) | duplicated(alumno18$MRUN,fromLast = TRUE))]
final18<-alumno18[!(alumno18$MRUN %in% alu18$MRUN),]

# esto de aca abajo ace lo mismo que el %in% pero es mucho mas entendible, no es necesario correrlo
library(dplyr)
anti18<-anti_join(alumno18, alu18, by = "MRUN")
# --------------- fin anti-join-------------------


final18[duplicated(final18$MRUN) | duplicated(final18$MRUN,fromLast = TRUE)]
# quedan 50 duplicados de igual modo no se xq, voy bajar la PK a MRUN al fin y al cabo "agno" ara q se repitan los MRUN
# 3 veces de todos modos
# listo para pentaho
head(final18)
write.csv(final18,'rendimiento/dims/hechoAlu2.csv',append = FALSE)
# dato curioso, mi pentaho sube alrededor de 8000 filas x minuto a la DB, x lo q 2 palos de filas me tomo sobre las 3 horas



### trash

# prune alumnos trasladados
#r18[r18$SIT_FIN_R=="T" & r18$PROM_GRAL>1]
#r18<-r18[!(r18$SIT_FIN_R=="T")]
#readMerge<-fread("rendimiento/join2018v2.csv",select = c("MRUN","RBD.x","RBD.y"),header = TRUE)
#join18<-read.csv("rendimiento/join2018v3.csv")
#head(join18[c(3,7)])
#unique(join18[c(3,7)])
#------------------------------
# lo mismo q antes pero pa 2017
r17<-fread("rendimiento/20180213_Rendimiento_2017_20180131_PUBL.csv",select = 
             c("MRUN","COD_JOR","COD_ENSE","COD_ESPE","EDAD_ALU","PROM_GRAL","ASISTENCIA","SIT_FIN_R","COD_COM_ALU"),header = TRUE)
s17<-fread("sep/Preferentes_Prioritarios_y_Beneficiarios_2017.csv",select = 
             c("MRUN","RBD","DGV_RBD","GEN_ALU","FEC_NAC_ALU","COD_ENSE3","AGNO","CRITERIO_SEP","PRIORITARIO_ALU","PREFERENTE_ALU","BEN_SEP"),header = TRUE)
anyDuplicated(r17$MRUN)
anyDuplicated(s17$MRUN)
# merge
alumno17<-merge(x=s17,y=r17,by = "MRUN")
# grabado temporal para no volver a leer 6 palos de registros de r18 y s18
#write.csv(alumno17,'rendimiento/dims/hechoAlu',append = FALSE)
# prune alumnos trasladados con promedio 0 que causan repeticiones inutiles al dataset
alu17<-alumno17[duplicated(alumno17$MRUN) | duplicated(alumno17$MRUN,fromLast = TRUE)]
alu17<-alu17[alu17$SIT_FIN_R=="T" & alu17$PROM_GRAL<1]
final17<-alumno17[!(alumno17$MRUN %in% alu17$MRUN),]

final17[duplicated(final17$MRUN) | duplicated(final17$MRUN,fromLast = TRUE)]
head(final17)
write.csv(final17,'rendimiento/dims/hechoAlu2017.csv',append = FALSE)


# lo mismo q antes pero pa 2016 
r16<-fread("rendimiento/20170216_Rendimiento_2016_20170131_PUBL.csv",select = 
             c("MRUN","COD_JOR","COD_ENSE","COD_ESPE","EDAD_ALU","PROM_GRAL","ASISTENCIA","SIT_FIN_R","COD_COM_ALU"),header = TRUE)
s16<-fread("sep/Preferentes_Prioritarios_y_Beneficiarios_2016.csv",select = 
             c("MRUN","RBD","DGV_RBD","GEN_ALU","FEC_NAC_ALU","COD_ENSE3","AGNO","CRITERIO_SEP","PRIORITARIO_ALU","PREFERENTE_ALU","BEN_SEP"),header = TRUE)
anyDuplicated(r16$MRUN)
anyDuplicated(s16$MRUN)
# merge
alumno16<-merge(x=s16,y=r16,by = "MRUN")
# grabado temporal para no volver a leer 6 palos de registros de r18 y s18
#write.csv(alumno17,'rendimiento/dims/hechoAlu',append = FALSE)
# prune alumnos trasladados con promedio 0 que causan repeticiones inutiles al dataset
alu16<-alumno16[duplicated(alumno16$MRUN) | duplicated(alumno16$MRUN,fromLast = TRUE)]
alu16<-alu16[alu16$SIT_FIN_R=="T" & alu16$PROM_GRAL<1]
final16<-alumno16[!(alumno16$MRUN %in% alu16$MRUN),]

final16[duplicated(final16$MRUN) | duplicated(final16$MRUN,fromLast = TRUE)]
head(final16)
write.csv(final16,'rendimiento/dims/hechoAlu2016.csv',append = FALSE)

# hay alrededor de 400 alumnos repetidos, resalta el 2017 con 170 duplicados y 2016 con 52

### fix NAs and string promedios
# no need to fix promedios

### explanation of 1kk registries lost
alum18<-r18[!(r18$MRUN %in% s18$MRUN),]
alum18<-alum18[alum18$PROM_GRAL>0]
alum2018<-as.factor(alum18$PROM_GRAL)
summary(alum18)
alumno18<-merge(x=s18,y=r18,by = "MRUN")
alum18[duplicated(alum18)]

alu16<-alu16[alu16$SIT_FIN_R=="T" & alu16$PROM_GRAL<1]
final18<-alumno18[!(alumno18$MRUN %in% alu18$MRUN),]
write.csv(alum18,'rendimiento/dims/losOlvidados18.csv',append = FALSE)

### aa
rend18 <- read.csv(file = "rendimiento/dims/hechoAlu18.csv", header = TRUE, sep = ",")
r18<-fread("rendimiento/dims/hechoAlu18.csv",header = TRUE)
r18$DGV_RBD<-NULL
head(r18)
write.csv(r18,'rendimiento/dims/hechoAlu18.csv',append = FALSE,row.names = FALSE)

