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

# test file existe ?
if [ -e $file ]
then
    :
else
    echo "fichier $file n'existe pas"
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

# rappel, 3 arguments
# file_path = chemin du fichier
# type_station = type de station (= hvb/hva/lv)
# type_consommateur = type consommateur (=comp/indiv/all)

# récupération des arguments :
file_path=$1
type_station=$2
type_consommateur=$3

# verif si 4ème argument pour attrib id_centrale
if [$# -eq 4 && $4 != "-h"]
then
    id_centrale=$4
fi

# si arg1, arg 2 et arg 3 invalide
if[jsp]

if [file_path != "hvb" && file_path != "hva" && file_path != "lv"]
then
    echo "$1 est un mauvais argument pour le premier argument (hvb/hva/lv)"
    exit 1
fi

if [type_station != "comp" && type_station != "indiv" && type_station != "all"]
then
    echo "$2 est un mauvais argument pour le premier argument (comp/indiv/all)"
    exit 1
fi

#useless et faux
if [(type_station == "comp" || type_station == "indiv") && type_station == "all"]
then
    echo "argument "$type_station" et argument "all" incompatible"
    exit 1
fi

if [ "$type_station" == "hvb" ] && [ "$type_consommateur" == "all" ] ||
   [ "$type_station" == "hvb" ] && [ "$type_consommateur" == "indiv" ] ||
   [ "$type_station" == "hva" ] && [ "$type_consommateur" == "all" ] ||
   [ "$type_station" == "hvb" ] && [ "$type_consommateur" == "indiv" ]
then
    echo "argument "$type_station" et argument "$type_consommateur" incompatible"
    exit 1
fi

# si id_central <= 0 ou n'est pas déclaré (si non renseigné)
if [$id_centrale -lt 0] && [ -z "$id_centrale" ]
then
    echo "parametre id_centrale incorrect"
    exit 1
fi

