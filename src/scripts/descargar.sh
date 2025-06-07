#!/bin/bash

# Este script debe descargar una sola imagen desde internet en la carpeta actual.
# Puede recibir un argumento opcional indicando la clase de la imagen.
# El nombre del archivo deberá ser único, una opción para evitar repetición de imágenes
# y asegurar que sea único se puede usar su suma de verificación.
# Las imágenes descargadas tienen extensión .jpg.
# Asegúrese de devolver un valor de salida acorde a la situación.
NOMBRE=""
wget -qO img.jpg https://tuia-edp.org/random-image &&  NOMBRE=`sha256sum img.jpg ` && mv -f img.jpg "/imagenes/${NOMBRE:0:64}.jpg" && echo "${NOMBRE:0:64}.jpg agregada"&& exit 0 
#while [[ find /imagenes/ -name ${NOMBRE:0:64}.jpg ]]; do
#    wget -O img.jpg https://tuia-edp.org/random-image &&  NOMBRE=`md5sum img.jpg `
#done



echo Descarga de imágenes de internet no implementada. && exit 1
