#!/bin/bash

# Este script es un programa interactivo que no recibe argumentos.
# Debe preguntarle al usuario que etiqueta desea buscar y mostrar por
# pantalla todas las imágenes que tengan esa etiqueta, junto con su descripción.



#read -p " Ingrese la etiqueta: " CLASE
#jq --arg c "$CLASE" '.[$c]' etiquetas.json | grep "\"*\"" > /dev/null
#[[ $? -gt 0]] && echo "la clase no existe" && exit $?
ERR=1
while [[ $ERR -gt 0 ]]; do
    read -p " Ingrese la etiqueta: " CLASE
    jq --arg c "$CLASE" '.[$c]' etiquetas.json | grep "\"*\"" > /dev/null
    ERR=$?
    [[ $ERR -gt 0 ]] && echo -n $'Esa clase no existe\t'
done

for IMG in `jq --arg c "$CLASE" '.[$c]' etiquetas.json | grep "\"*\""`; do

    IMG=${IMG:10:68}
    echo "$IMG" 

    [[ -f $IMG ]] && {
	jp2a --color-depth=24 $IMG
    INFO=`jq --arg k "$IMG" '.[$k]' imagenes.json | tr -d \"  `
    [[ $INFO != 'null' ]] && echo -e $INFO || echo "Sin descripcion " # el -e hace que represente los \n
    } || echo "La imagen etiquetada no existe"

done
exit 0