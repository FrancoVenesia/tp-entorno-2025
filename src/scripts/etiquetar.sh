#!/bin/bash

# Este script trabaja sobre archivos de la carpeta actual que terminan en .jpg,
# clasificándolos usando YOLO y agregando una descripción de la imagen usando Moondream
#
# Deben crear dos archivos JSON, "$ETIQUETAS_JSON" e imagenes.json (ver la estructura propuesta
# en ....docsaclaraciones.md).
# Usar el comando `jq` para manipular los archivos JSON.
# Asegúrese de devolver un valor de salida acorde a la situación.

etiq_json() {
	
	if [[ `cat "$ETIQUETAS_JSON" | jq --arg k "$1" '.[$k]' | grep -c $2`  -eq 0 ]]; then
	#si no existe $2 en $1 ejecuto lo que sigue
	 cat "$ETIQUETAS_JSON" | jq --arg k "$1" --arg v "imagenes/$2" '
	  .[$k] += [$v]
    ' > tmp && mv tmp "$ETIQUETAS_JSON" 
	#echo `cat "$ETIQUETAS_JSON"`
	fi
}
img_json() {
	
	if [[ `cat "$IMAGENES_JSON" | jq --arg k "$1" '.[$k]' | grep -c $2`  -eq 0 ]]; then
	#si no existe $2 en $1 ejecuto lo que sigue
	 cat "$IMAGENES_JSON" | jq --arg k "$1" --arg v "$2" '
	  .[$k] += $v
    ' > tmp && mv tmp "$IMAGENES_JSON" 
	#echo `cat "$ETIQUETAS_JSON"`
	fi
}


ETIQUETAS_JSON=etiquetas.json
IMAGENES_JSON=imagenes.json

#touch "$ETIQUETAS_JSON"
#touch "$IMAGENES_JSON"

#1) Encontrar archivos que terminan en JP
for IMAGEN in `ls *.jpg` ; do # OPCION PIPE POTENCIAL  while  QUE PONGO ACA; do
	echo "Dentro del for"
 #Obtener nombre del archivo
#2) Clasificarlos usando YOLO
	ETIQUETA=`yolo predict source=/imagenes/$IMAGEN | grep "$IMAGEN" | cut -d ' ' -f 6 | cut -d ',' -f 1`
	
	if [[ $ETIQUETA == "detections)" ]]; then
		ETIQUETA="no_detections"
	fi
	echo "$ETIQUETA"
	
	#ollama run moondream "{'content': 'Describe me this image', 'images': '/imagenes/$IMAGEN'}"

	etiq_json $ETIQUETA $IMAGEN

	# img_json $IMAGEN $DESCRIPCION

done


#3) Describirlos usando Moondream

#4) Crear archivos JSON "$ETIQUETAS_JSON", imagenes.json

#crear_json() {
#	if [ ! -f $ETIQUETAS_JSON ]; then
#		echo {}  $ETIQUETAS_JSON
#	fi
#	if [ ! -f $IMAGENES_JSON]; then
#		echo {}  $IMAGENES_JSON
#	fi
#}
#5) Manipular con comando jq


#6) Almacenar y mostrar valore




#Comando YOLO para clasificar


#Comando Moondream para describir

#Inicializar JSON