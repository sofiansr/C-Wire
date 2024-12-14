#!/bin/bash

#file='c-wire_v00.dat'

# Vérifier si l'un des paramètres est -h
for arg in "$@"
do
    if [ "$arg" == "-h" ]; then
        echo "pomme"
        exit 0
    fi
done

if [$# -eq 0]
then
    echo "Aucun argument passé en paramètre"
    exit 1
fi

# test non vide
if [ -s $file ]
then
    :
else
    echo "fichier $file vide"
    exit 1
fi



# test perm lecture
if [ -r $file ]
then
    :
else
    echo "pas d'acces en lecture au fichier $file"
    exit 1
fi

# rappel, 3 arguments (4)
# arg 1 : file_path = chemin du fichier
# arg 2 : type_station = type de station (= hvb/hva/lv)
# arg 3 : type_consommateur = type consommateur (=comp/indiv/all)
# (arg 4 : id_centrale = filtre les résultats pour une centrale spécifique (>=1))

# récupération des arguments :
file_path=$1
type_station=$2
type_consommateur=$3

# verif si 4 arguments pour attrib id_centrale
if [ $# -eq 4 ]
then
    id_centrale=$(($4))             # conversion en int
    if (( $id_centrale <= 0 ))
    then
        echo "id_centrale <= 0 : incorrect"
        exit 1
    fi
fi

# cehck arg 1 : file existe dans dossier courant ?
if [ -e $file_path ]
then
    :
else
    echo "fichier "$file" non présent dans le dossier courant"
    exit 1
fi

# check arg 2
if [ "$type_station" != "hvb" ] || [ "$type_station" != "hva" ] || [ "$type_station" != "lv" ]
then
    echo ""$1" est un mauvais argument pour le deuxieme argument (hvb/hva/lv)"
    exit 1
fi

# check arg 3
if [ "$type_consommateur" != "comp" ] || [ "$type_consommateur" != "indiv" ] || [ "$type_consommateur" != "all" ]
then
    echo ""$2" est un mauvais argument pour le troisieme argument (comp/indiv/all)"
    exit 1
fi

# useless et faux
# if [ ("$type_station" == "hvb" || "$type_station" == "hva") && ("$type_consommateur" == "all"  || "$type_consommateur" == "indiv")]
# then
#     echo "argument "$type_station" et argument "all" incompatible"
#     exit 1
# fi

# if ( [ "$type_station" == "hvb" ] && [ "$type_consommateur" == "all" ] ) ||
#    ( [ "$type_station" == "hvb" ] && [ "$type_consommateur" == "indiv" ] ) ||
#    ( [ "$type_station" == "hva" ] && [ "$type_consommateur" == "all" ] ) ||
#    ( [ "$type_station" == "hvb" ] && [ "$type_consommateur" == "indiv" ] )
# then
#     echo "argument "$type_station" et argument "$type_consommateur" incompatible"
#     exit 1
# fi

# vérif des cas interdits arg 2 et 3
if [[ ( "$type_station" == "hvb" || "$type_station" == "hva" ) && 
      ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]
then
    echo "argument "$type_station" et argument "$type_consommateur" incompatible"
    exit 1
fi

# check arg 3 : si id_central <= 0 ou n'est pas déclaré (si non renseigné)
#if [ $id_centrale -lt 0 ] || [ -z "$id_centrale" ]
#then
#    echo "parametre id_centrale incorrect ou vide"
#    exit 1
#fi

# EXECUTABLE NON PRESENT DANS DOSSIER COURANT
if [ -e "main.c" ]
then
    :
else
    make