#!/bin/bash

# Este script simplemente debe chequear que haya conexión a internet.
# Asegúrese de retornar un valor de salida acorde a la situación.
# Puede que necesite modificar el archivo Dockerfile.

# Se usa el valor de salida de ping (0 si llegó respuesta), que también
# detecta el caso en que no hay red y ping no llega a imprimir "0 received"
# Testeo si llega algun paquete al primer dns
DNS=2
ping -qc 1 -w 2 8.8.8.8 > /dev/null 2>&1 || DNS=$(($DNS-1))
# Testeo si llega algun paquete al Segundo dns
ping -qc 1 -w 2 8.8.4.4 > /dev/null 2>&1 || DNS=$(($DNS-1))
# Llego algun paquete a algun DNS
if [ $DNS -gt 0 ] ; then
	echo Conexion Internet OK. && exit 0
else
	echo Conexion Internet Caida. && exit 2
    #Si falla la conexion retorna error 2
fi
