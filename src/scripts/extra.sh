#!/bin/bash
#Deberia crear un HTML
# Se usa un heredoc en vez de echo '...' para que no se pierdan las comillas simples del ícono
cat << 'FIN' > index.html
<html>
    <head>
        <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><circle cx='50' cy='50' r='40' fill='%23f00'/></svg>" type="image/svg+xml">
        <style>
            body {background-color: #0f0f0f;}
            img {max-width: 321px; height: auto; display: table-cell;}
            div {display: grid; grid-template-columns: repeat(auto-fill, minmax(321px, 1fr)); gap: 5px;}
        </style>
    </head>
    <body>
        <div>
FIN
for IMAGEN in `ls *.jpg`; do
    echo  "<img src=\"$IMAGEN\" >" >> index.html
done
echo '        </div>
    </body>
    </html>' >> index.html

echo $' Ingrese a http://localhost:8000/ Para ver una galeria de las imagenes descargadas\n Utilice ^C para cerrar el servidor local'
python3 -m http.server --bind localhost 8000 > /dev/null 2>&1
