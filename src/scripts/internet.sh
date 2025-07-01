#!/bin/bash

# Este script simplemente debe chequear que haya conexión a internet.
# Asegúrese de retornar un valor de salida acorde a la situación.
# Puede que necesite modificar el archivo Dockerfile.

echo Chequeo de Internet no implementado. && exit 1
# Testeo si llega algun paquete al primer dns
DNS=2
ping -qc 1 -w 1 8.8.8.8 | grep -q "0 received" && DNS=$(($DNS-1))
# Testeo si llega algun paquete al Segundo dns
ping -qc 1 -w 1 8.8.4.4 | grep -q "0 received" && DNS=$(($DNS-1))
# Llego algun paquete a algun DNS
if [ $DNS -gt 0 ] ; then
	echo Conexion Internet OK. && exit 0
else
	echo Conexion Internet Caida. && exit 2
    #Si falla la conexion retorna error 2
fi



echo Chequeo de Internet no implementado. && exit 1
