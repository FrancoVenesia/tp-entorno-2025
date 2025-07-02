#!/bin/bash

# Este script trabaja sobre archivos de la carpeta actual que terminan en .jpg,
# clasificándolos usando YOLO y agregando una descripción de la imagen usando Moondream
#
# Deben crear dos archivos JSON, "$ETIQUETAS_JSON" e imagenes.json (ver la estructura propuesta
# en ....docsaclaraciones.md).
# Usar el comando `jq` para manipular los archivos JSON.
# Asegúrese de devolver un valor de salida acorde a la situación.

<<<<<<< HEAD
=======
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
	
	if [[ `cat "$IMAGENES_JSON" | jq --arg k "$1" '.[$k]' | grep -c "$2"`  -eq 0 ]]; then
	#si no existe $2 en $1 ejecuto lo que sigue
	 cat "$IMAGENES_JSON" | jq --arg k "$1" --arg v $2 '
	  .[$k] += $v
    ' > tmp && mv tmp "$IMAGENES_JSON" 
	#echo `cat "$ETIQUETAS_JSON"`
	fi
}

>>>>>>> mostrar.sh

ETIQUETAS_JSON=etiquetas.json
IMAGENES_JSON=imagenes.json

<<<<<<< HEAD
# Crear JSON vacíos si no existen
[[ ! -f "$ETIQUETAS_JSON" ]] && echo '{}' > "$ETIQUETAS_JSON"
[[ ! -f "$IMAGENES_JSON" ]] && echo '{}' > "$IMAGENES_JSON"


etiq_json() {
    # Reviso si ya fue etiquetado en esa clase
    if [[ `cat "$ETIQUETAS_JSON" | jq --arg k "$1" '.[$k]' | grep -c $2`  -eq 0 ]]; then
    #si no lo fue ejecuto lo que sigue
     cat "$ETIQUETAS_JSON" | jq --arg k "$1" --arg v "imagenes/$2" '
      .[$k] += [$v]
    ' > tmp && mv tmp "$ETIQUETAS_JSON"
    #echo `cat "$ETIQUETAS_JSON"`
    fi
}

img_json() {
    jq --arg k "$2" --arg v "$1" '
      .[$k] = $v
    ' "$IMAGENES_JSON" > tmp && mv tmp "$IMAGENES_JSON"
    #echo `cat "$ETIQUETAS_JSON"`
}

#touch "$ETIQUETAS_JSON" # Estas líneas están comentadas y no son necesarias si los JSON ya se inicializan arriba
#touch "$IMAGENES_JSON" # con '{}'

#1) Encontrar archivos que terminan en JP
for IMAGEN in `ls *.jpg` ; do #Obtener nombre de cada archivo con un for
    #echo "Dentro del for"
    echo "Catalogando: $IMAGEN"
    #2) Clasificarlos usando YOLO
    ETIQUETA=`yolo predict source=/imagenes/$IMAGEN | grep "$IMAGEN" | cut -d ' ' -f 6 | cut -d ',' -f 1`
    # Caso sin categoria
    if [[ $ETIQUETA == "detections)" ]]; then
        ETIQUETA="no_detections"
    fi
    echo "CLASE: $ETIQUETA"

    etiq_json "$ETIQUETA" "$IMAGEN" 

    
    if [[ `jq -r --arg k "$IMAGEN" '.[$k]' "$IMAGENES_JSON"` == "" ]] || [[ `jq -r --arg k "$IMAGEN" '.[$k]' "$IMAGENES_JSON"` == "null" ]] ; then #Se robustece el if para contemplar casos de falta de registro o falta de descripcion de imagen
        echo "Preparando para procesar imagen con MOONDREAM"
        #3) Describirlos usando Moondream
        DESCRIPCION=`ollama run moondream "{'content': 'Describe me this image', 'images': '/imagenes/$IMAGEN'}"`
        echo "Descripcion: $DESCRIPCION"
        img_json "$DESCRIPCION" "$IMAGEN" # Se añadieron comillas 
    else
        echo "Ya se habia descripto" 
        echo -n "Descripcion: "
        echo -e `jq  --arg k "$IMAGEN" '.[$k]' "$IMAGENES_JSON" | tr -d \" ` 
        echo -e "\n"
    fi

done
=======
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
	etiq_json $ETIQUETA $IMAGEN
#3) Describirlos usando Moondream
#Con "$DESCRIPCION" ya toma el parrafo de descripcion
#Falta reparar su insercion en imagenes.json
	DESCRIPCION=`ollama run moondream "{'content': 'Describe me this image, put the description between " "', 'images': '/imagenes/$IMAGEN'}" | grep "\"*\""`
	img_json $IMAGEN $DESCRIPCION

done


#4) Crear archivos JSON "$ETIQUETAS_JSON", imagenes.json

#crear_json() {
#	if [ ! -f $ETIQUETAS_JSON ]; then
#		echo {}  $ETIQUETAS_JSON
#	fi
#	if [ ! -f $IMAGENES_JSON]; then
#		echo {}  $IMAGENES_JSON
#	fi
#}




>>>>>>> mostrar.sh
