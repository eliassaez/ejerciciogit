#Segundo cambioo

#Este es un programa hecho en bash en el que se usará para la gestion de ficheros
#tanto para modificarlos como para añadirlos o borrarlos
#gestionar permisos de los distintos ficheros y hacer que ciertos usuarios con distintos permisos puedan acceder o no a ellos


#!/bin/bash

#declaramos los arrays a los que pasaremos los 3 campos que contiene el fichero de texto,
#ficheros, permisos y directorios
declare -a array_ficheros
declare -a array_permisos
declare -a array_directorios

#declaramos el array en el que se guardan los directorios que crea el programa
declare -a array_directorios_creados

#se pasan los parametros 1 (lista de ficheros) y 2 (ruta de los ficheros) a variables
#SE DEBE INDICAR LA RUTA CON / AL FINAL PARA QUE FUNCIONE CORRECTAMENTE A LA HORA DE MOVER ARCHIVOS
datos=$1
ruta_f=$2

########################################################################################################

# esta funcion carga el primer campo del fichero de texto, que es el nombre de los archivos,
#para ello se recorre el fichero mediante un bucle y
#se usa cut para indicar cual es el primer campo, delimitado por |
cargar_ficheros() {

    while read linea; do
        array_ficheros+=("$(echo "$linea" | cut -d"|" -f1)")
    done <$datos
}

# esta funcion carga el segundo campo del fichero de texto, que son los permisos que
#se daran a los archivos de los archivos,
#para ello se recorre el fichero mediante un bucle y
#se usa cut para indicar cual es el segundo campo, delimitado por |
cargar_permisos() {

    while read linea; do
        array_permisos+=("$(echo "$linea" | cut -d"|" -f2)")
    done <$datos
}

# esta funcion carga el tercer campo del fichero de texto, que son los directorios
#donde se moveran los archivos,
#para ello se recorre el fichero mediante un bucle y
#se usa cut para indicar cual es el tercer campo, delimitado por |
cargar_directorios() {

    while read linea; do
        array_directorios+=("$(echo "$linea" | cut -d"|" -f3)")
    done <$datos
}

#esta funcion uestra el contenido de los 3 arrays creado antes,
#para ello se recorre uno de ellos (array ficheros) y se musetra tambien
#el contenido del resto de los arrays (mostrando lo que contienen en la misma posicion)
listar_ficheros() {
    echo "LISTA DE FICHEROS, PERMISOS Y DIRECTORIOS:"
    i=0
    while [ $i -lt ${#array_ficheros[@]} ]; do
        echo "${array_ficheros[$i]}"\|"${array_permisos[$i]}"\|"${array_directorios[$i]}"
        i=$(($i + 1))
    done
}

####################################################################################

#este array permite cambiar los permisos de los archivos que despues moveremos
#para ello se recorre el array ficheros y se ejecuta el comando chmod en cada
#uno de los ficheros que aparecen en el array
cambiar_permisos() {
    i=0
    while [ $i -lt ${#array_ficheros[@]} ]; do
        echo "cambiando permisos de" "${array_ficheros[$i]}"
        sudo chmod "${array_permisos[$i]}" "$ruta_f""${array_ficheros[$i]}"
        i=$(($i + 1))
    done

}

#esta funcion se encarga de mover los ficheros del array ficheros al directorio que les corresponde,
#para ello se recorre el array de ficheros con un bucle, y en cada uno de ellos se hace una comprobacion
#para ver si existe o no el directorio al que debe moverse, si no existe se creara
#(se dara todos los permisos por si fueran necesarios al directorio creado).
#despues se moveran los archivos al directorio y se añadira este directorio creado a un nuevo array

###se usa una flag para poder mostrar mas adelante los directorios solo si la flag cambia a 1###
mover_ficheros() {
    flag_dirs=0
    i=0
    while [ $i -lt ${#array_ficheros[@]} ]; do
        if [ -d "${array_directorios[$i]}" ]; then
            echo "moviendo archivo" "${array_ficheros[$i]}"
            sudo mv "$ruta_f""${array_ficheros[$i]}" "${array_directorios[$i]}"

        else
            echo no existe el directorio "${array_directorios[$i]}" , se creara
            sudo mkdir "${array_directorios[$i]}"
            sudo chmod 777 "${array_directorios[$i]}"

            array_directorios_creados+=("$(echo "${array_directorios[$i]}")")

            echo "moviendo archivo" "${array_ficheros[$i]}"
            sudo mv "$ruta_f""${array_ficheros[$i]}" "${array_directorios[$i]}"

            flag_dirs=1

        fi

        i=$(($i + 1))
    done

}

#se muestra el contenido del array de los nuevos directorios creados mediante un bucle
###esta funcion depende de la flag usada en la funcion anterior, como se vera mas tarde en el menu###
mostrar_dir_creados() {
    echo "LOS DIRECTORIOS QUE SE HAN CREADO SON:"
    i=0
    while [ $i -lt ${#array_directorios_creados[@]} ]; do
        echo "${array_directorios_creados[$i]}"
        i=$(($i + 1))
    done
}

#########################
###INICIO DEL PROGRAMA###
#########################
# el menu esta hecho con cases, que ejecuta las funciones correspondientes segun la opcion elegida
# con el bucle while true, vuelve a mostrar el menu tras haber ejecutado alguna opcion
while true; do
    echo
    echo "este programa permite mover archivos indicados en un fichero de texto....."
    echo "1) CARGAR DATOS DEL FICHERO DE TEXTO"
    echo "2) PROCESAMIENTO DEL FICHERO DE TEXTO"
    echo "q) SALIR DEL PROGRAMA"
    read -p "ELIGE OPCION 1 o 2:  " opcion

    case $opcion in
    1) #ejecuta todas las funciones de carga y despues lista el contenido de los arrays

        cargar_ficheros
        cargar_permisos
        cargar_directorios
        listar_ficheros
        echo
        ;;

    2) # la opcion 2 ejecuta las funciones de cambiar permisos y mover archivos
        cambiar_permisos
        mover_ficheros
        echo
        # si la flag de la funcion mover esta a 1, es decir, se ha creado algun directorio, se ejecutara
        #tambien la funcion de mostrar los directorios creados
        if [[ $flag_dirs == 1 ]]; then
            mostrar_dir_creados
        fi
        echo
        ;;
    q) #permite salir del programa
        exit
        ;;

    *) #se mostrara el mensaje de opcion incorrecta si se elige una opcion que no este en el menu
        echo "opcion incorrecta"
        echo
        ;;
    esac
done
