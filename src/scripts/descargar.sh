#!/bin/bash

# Este script debe descargar una sola imagen desde internet en la carpeta actual.
# Puede recibir un argumento opcional indicando la clase de la imagen.
# El nombre del archivo deberá ser único, una opción para evitar repetición de imágenes
# y asegurar que sea único se puede usar su suma de verificación.
# Las imágenes descargadas tienen extensión .jpg.
# Asegúrese de devolver un valor de salida acorde a la situación. 

#wget -qO /imagenes/img.jpg https://tuia-edp.org/random-image &&  NOMBRE=`sha256sum img.jpg ` &&  mv -f /imagenes/img.jpg "/imagenes/$NOMBRE.jpg" && echo "$NOMBRE.jpg agregada"&& exit 0  
# El -q hace que no imprima y el 0 es para nombrarlo              El nombre es el cheksum SHA256    El -f es por si todo falla reescribe la imagen existente     Se usa $NOMBRE porque el checksum son 68 caracteres y el checksum devueve algo mas                                                                                        


descargar(){
    NOMBRE=`ls /imagenes/ | head -n 1 ` #Obtengo el Nombre de un archivo de la carpeta 
    while [ -f /imagenes/$NOMBRE ]; do   # Me fijo si existe "/imagenes/$NOMBRE" y mientras no exista ejecuto lo de dentro del do  
        wget -qO img.jpg https://tuia-edp.org/random-image &&  NOMBRE=`sha256sum img.jpg ` && NOMBRE=${NOMBRE:0:64} && NOMBRE="$NOMBRE.jpg" #Descargo la imagen con el nombre img.jpg y me fijo cual seria el nombre unico guardando el nombre en la variable NOMBRE
    done
}

clase (){
    test 1 -eq 2 #Hago un test que siempre de salida distinto 0
    until [ $0 -eq 0 ]; do #Hago un loop de que se ejecuta si el ultimo comando dio distinto de 0 hago 
        descargar
        ollama run moondream "{'content': 'This image enter in the $1 class? Answer yes or no', 'images': '/imagenes/img.jpg'}" | grep -i "no"
        # Le pido a la ia que se fije si entra en la clase y depende lo que responda es el valor del greo
    done
}


if [ $# -eq 1 ]; then #Consulto si se le ingreso una clase correctamente
    echo "Clase: $1"
    #clase $1  !NO IMPLEMENTAR HASTA RESOLVER PORQUE NO ANDA EL MOONDREAM
    descargar
    elif [ $# -eq 0 ]; then # Consulto si no ingreso clase
    echo "No Hay clase"
    descargar
else # En ninguno de los dos casos
    echo "Mal los argumentos $@"
    exit 2
fi


mv -f /imagenes/img.jpg "/imagenes/$NOMBRE" && echo "$NOMBRE agregada"&& exit 0  #Renombro la imagen con su nombre unico y muestro un mensaje que dice que se descargo

echo Descarga de imágenes de internet no implementada. && exit 1
