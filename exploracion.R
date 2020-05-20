#EXPLORATORIO MINEDUC
setwd("Descargas/forBI/datasets/")
##### CORRER SOLO PARA COMPARAR COLUMNAS
rend18 <- read.csv(file = "rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv", header = TRUE, nrows=3, sep = ";")
#### CARGA REND
rend17 <- read.csv(file="rendimiento/20180213_Rendimiento_2017_20180131_PUBL.csv", header = TRUE, nrows=500000, sep = ";")
write.csv(rend17,"rend17subset500k.csv", row.names = TRUE)
rend17 <- read.csv(file="rendimiento/20180213_Rendimiento_2017_20180131_PUBL.csv", header = TRUE, sep = ";")
### subset for test saving
rend17Test <- rend17[sample(nrow(rend17), 10000), ]
write.table(rend17Test,'rend17.csv',sep = ";")
rend17T<-read.csv2(file = "rend17.csv",header = TRUE,nrows = 20,sep = ";")
rend16 <- read.csv(file="rendimiento/20170216_Rendimiento_2016_20170131_PUBL.csv", header = TRUE, sep = ";")
rend16Test <- rend16[sample(nrow(rend16), 10000), ]
write.table(rend16Test,'rend16.csv',sep = ";")
rend16T<-read.csv2(file = "rend16.csv",header = TRUE,nrows = 20,sep = ";")
rend18 <- read.csv(file="rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv", header = TRUE, sep = ";")
head(rend18)
rend18Test <- rend18[sample(nrow(rend18), 10000), ]
write.table(rend18Test,'rend18.csv',sep = ";")
rend18T<-read.csv2(file = "rend18.csv",header = TRUE,nrows = 20,sep = ";")

#### CORRER PARA COMPARAR COLUMNAS
sep18 <- read.csv(file = "sep/Preferentes_Prioritarios_y_Beneficiarios_2018.csv", header = TRUE, nrows=3, sep = ";")
#################### sep
sep18 <- read.csv(file="sep/Preferentes_Prioritarios_y_Beneficiarios_2018.csv", header = TRUE, sep = ";")
sep18Test <- sep18[sample(nrow(sep18), 10000), ]
write.table(sep18Test,'sep18.csv',sep = ";")
sep18T<-read.csv2(file = "sep18.csv",header = TRUE,nrows = 20,sep = ";")
head(sep18T)
sep17 <- read.csv(file="sep/Preferentes_Prioritarios_y_Beneficiarios_2017.csv", header = TRUE, sep = ";")
sep17Test <- sep17[sample(nrow(sep17), 10000), ]
write.table(sep17Test,'sep17.csv',sep = ";")
sep17T<-read.csv2(file = "sep17.csv",header = TRUE,nrows = 20,sep = ";")
head(sep17T)
sep16 <- read.csv(file="sep/Preferentes_Prioritarios_y_Beneficiarios_2016.csv", header = TRUE, sep = ";")
sep16Test <- sep16[sample(nrow(sep16), 10000), ]
write.table(sep16Test,'sep16.csv',sep = ";")
sep16T<-read.csv2(file = "sep16.csv",header = TRUE,nrows = 20,sep = ";")
head(sep16T)

# diff de columnas al dataset
library(arsenal)
comparedf(rend18,sep18)
summary(comparedf(rend18,sep18))
# columnas q importan:  EDAD_ALU , COD_RAMA=COD_SEC(sector comercial), PROM_GRAL, ASISTENCIA, SIT_FIN

# carga dataset para exploratorio, ejecutar solo al final
# rend18 <- read.csv(file="rendimiento/20190220_Rendimiento_2018_20190131_PUBL.csv", header = TRUE, sep = ";")
# rapido analisis exploratorio para detectar comportamiento de atributos unicos
summary(rend18)
# se detecta el incorrecto formato de la columna promedio, no es numerico
library(ggplot2)
ggplot(rend18,aes(x=EDAD_ALU)) + geom_histogram() + 
  ggtitle("Distribución de edades de estudiantes 2018") + 
  xlab("Edad del alumno (EDAD_ALU)") + 
  ylab("Frecuencia")
ggplot(rend18,aes(x=SIT_FIN_R)) + geom_bar() + 
  ggtitle("Distribución de situación de promoción al cierre del año escolar de estudiantes 2018") + 
  xlab("Promovido, Reprobado, Trasladado o Retirado") + 
  ylab("Frecuencia")
ggplot(rend18,aes(x=ASISTENCIA)) + geom_histogram() + 
  ggtitle("Distribución de asistencia de estudiantes 2018") + 
  xlab("Porcentaje anual de asistencia") + 
  ylab("Frecuencia")
ggplot(rend18,aes(x=PROM_GRAL)) + geom_bar()
# se detecta gran cantidad de datos faltantes, cuyo valor "NA" fue reemplazado por "0"
# esto entorpece el tratamiento de los atributos mas importantes del dataset, prom_gral y asistencia, cuyo formato numerico y 
# completitud es indispensable para cualqier tipo de tratamiento siguiente

# desecho de NAs en atributo de mayor prioridad
head(rend18)
rend18$PROM_GRAL[which(rend18$PROM_GRAL==0)] = NA
rend18 <- rend18[!is.na(rend18$PROM_GRAL), ]
head(rend18)
# exploracion de un dataset mas "explorable"
library(ggplot2)
ggplot(rend18,aes(x=EDAD_ALU)) + geom_histogram() + 
  ggtitle("Distribución de edades de estudiantes 2018") + 
  xlab("Edad del alumno (EDAD_ALU)") + 
  ylab("Frecuencia")
ggplot(rend18,aes(x=SIT_FIN_R)) + geom_bar() + 
  ggtitle("Distribución de situación de promoción al cierre del año escolar de estudiantes 2018") + 
  xlab("Promovido, Reprobado, Trasladado o Retirado") + 
  ylab("Frecuencia")
ggplot(rend18,aes(x=ASISTENCIA)) + geom_histogram() + 
  ggtitle("Distribución de asistencia de estudiantes 2018") + 
  xlab("Porcentaje anual de asistencia") + 
  ylab("Frecuencia")
#limpieza lograda

# obtencion de 
summary(rend18$EDAD_ALU,na.rm = TRUE)
summary(rend18$ASISTENCIA,na.rm = TRUE)
summary(rend18$PROM_GRAL,na.rm = TRUE)
# se arregla formato de PROM_GRAL
class(rend18$PROM_GRAL)
rend18$PROM_GRAL<-as.character(sub(",",".",rend18$PROM_GRAL))
rend18$PROM_GRAL<-as.numeric(rend18$PROM_GRAL)
mean(rend18$PROM_GRAL,na.rm = TRUE)
head(rend18)
summary(rend18)
ggplot(rend18,aes(x=PROM_GRAL)) + geom_histogram() + 
  ggtitle("Distribución de promedios generales de estudiantes 2018") + 
  xlab("Promedio general anual") + 
  ylab("Frecuencia")

# identificacion de correlaciones
# se deben proveer atributos numericos, de los atributos explorados se utilizan los dos que son numericos
cor.test(rend18$PROM_GRAL,rend18$ASISTENCIA,method = "spearman")

# posibles subsets

library(ggplot2)
p <- ggplot(rend18,aes(x=COD_GRADO))
p + geom_bar()
p <- ggplot(rend18,aes(x=ASISTENCIA))
p + geom_bar()


