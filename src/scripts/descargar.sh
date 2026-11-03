#!/bin/bash

# Este script debe descargar una sola imagen desde internet en la carpeta actual.
# Puede recibir un argumento opcional indicando la clase de la imagen.
# El nombre del archivo deberá ser único, una opción para evitar repetición de imágenes
# y asegurar que sea único se puede usar su suma de verificación.
# Las imágenes descargadas tienen extensión .jpg.
# Asegúrese de devolver un valor de salida acorde a la situación.

#wget -qO img.jpg https://tuia-edp.org/random-image &&  NOMBRE=`sha256sum img.jpg ` &&  mv -f img.jpg  $NOMBRE.jpg" && echo "$NOMBRE.jpg agregada"&& exit 0
# El -q hace que no imprima y el 0 es para nombrarlo              El nombre es el cheksum SHA256    El -f es por si todo falla reescribe la imagen existente     Se usa $NOMBRE porque el checksum son 68 caracteres y el checksum devueve algo mas

# https://tuia-edp.org/random-image ya no está disponible (devuelve 404).
# Sin clase se descarga una foto al azar de Picsum. Con clase se buscan fotos
# de esa clase en Wikimedia Commons y se elige una al azar.
URL_SIN_CLASE="https://picsum.photos/640/480"
COMMONS_API="https://commons.wikimedia.org/w/api.php"
AGENTE="tp-entorno-2025/1.0 (https://github.com/FrancoVenesia/tp-entorno-2025)" # Wikimedia pide identificar al programa
INTENTOS=10 # Cantidad máxima de descargas para conseguir una imagen que no esté repetida


descargar(){
    NOMBRE=""
    while [ -z "$NOMBRE" ] || [ -f "$NOMBRE" ]; do   # Descargo hasta conseguir una imagen que no esté en la carpeta
        INTENTOS=$(($INTENTOS-1))
        if [ $INTENTOS -lt 0 ]; then
            rm -f img.jpg
            echo No se encontró una imagen nueva
            exit 3
        fi
        if [ $# -eq 1 ]; then #Consulto si se le ingreso una clase correctamente
            CLASE=`jq -rn --arg c "$1" '$c|@uri'` # Codifico la clase para usarla en la URL (por ejemplo los espacios)
            RESPUESTA=`wget -qO - -U "$AGENTE" "$COMMONS_API?action=query&format=json&generator=search&gsrsearch=$CLASE%20filetype:bitmap%20filemime:image/jpeg&gsrnamespace=6&gsrlimit=50&prop=imageinfo&iiprop=url&iiurlwidth=640"` || {
                echo No se pudo consultar Wikimedia Commons
                exit 4
            }
            URL=`echo "$RESPUESTA" | jq -r '.query.pages[]?.imageinfo[0].thumburl' | shuf -n 1` # Elijo una de las fotos encontradas al azar
            if [ -z "$URL" ]; then
                echo Clase no encontrada
                exit 8
            fi
        else
            URL=$URL_SIN_CLASE
        fi
        wget -qO img.jpg -U "$AGENTE" "$URL" || { # Si falla la descarga no dejo el archivo a medias en la carpeta
            rm -f img.jpg
            echo No se pudo descargar la imagen
            exit 4
        }
        NOMBRE=`sha256sum img.jpg ` && NOMBRE=${NOMBRE:0:64} && NOMBRE="$NOMBRE.jpg" # El nombre unico es el checksum de la imagen
    done
}

if [ $# -eq 1 ]; then #Consulto si se le ingreso una clase correctamente
    echo "Clase: $1"
    descargar "$1"
    elif [ $# -eq 0 ]; then # Consulto si no ingreso clase
    echo "No Hay clase"
    descargar
else # En ninguno de los dos casos
    echo "Mal los argumentos $@"
    exit 2
fi


mv -f img.jpg  "$NOMBRE" && echo "$NOMBRE agregada"&& exit 0  #Renombro la imagen con su nombre unico y muestro un mensaje que dice que se descargo

echo No se pudo guardar la imagen. && exit 1
