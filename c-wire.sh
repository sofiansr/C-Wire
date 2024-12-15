#!/bin/bash

#file='c-wire_v00.dat'

# affiche l'aide si demandé ou si args incorrects puis exit
helpexit(){
    message="
    _____       _    _ ___________ _____ 
    /  __ \     | |  | |_   _| ___ \  ___|
    | /  \/_____| |  | | | | | |_/ / |__  
    | |  |______| |/\| | | | |    /|  __| 
    | \__/\     \  /\  /_| |_| |\ \| |___ 
    \____/      \/  \/ \___/\_| \_\____/                  
    
    C-WIRE HELP :

    C-Wire is a command-line script that sort your electricity distribution system by station type and user type.
    Results are sorted by capacity and electricity consumption.

    ARG 1 : DATA FILE PATH (.dat)
    ARG 2 : STATION TYPE (hvb, hva, lv)
    ARG 3 : USER TYPE (comp, indiv, all)
    ARG 4 (optional) : PLANT ID (int)
    
    ARG 4 will filter results by the PLANT ID you mentioned

    USAGE :
    ./c-wire.sh [ARG1] [ARG2] [ARG3] [ARG4]

    -h : Trigger this help message

    NOTE : hvb all, hvb indiv, hva all, hva indiv are forbidden commands



    C-WIRE
    ALL RIGHTS RESERVED 2024-2024
    MIT LICENSE    
    "
    echo "$message"
    exit 1
}

# Vérifier si l'un des paramètres est -h
for arg in "$@"
do
    if [ "$arg" == "-h" ]; then
        helpexit
    fi
done

if [ $# -eq 0 ]
then
    echo "Aucun argument passé en paramètre"
    helpexit
fi

# test non vide
if [ -s $file_path ]
then
    :
else
    echo "fichier "$file_path" vide"
    helpexit
fi



# test perm lecture
if [ -r $file_path ]
then
    :
else
    echo "pas d'acces en lecture au fichier "$file_path""
    helpexit
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
        helpexit
    fi
fi

# check arg 1 : file existe dans dossier courant ?
if [ -e $file_path ]
then
    :
else
    echo "fichier "$file_path" non présent dans le dossier courant"
    helpexit
fi

# check arg 2
if [ "$type_station" != "hvb" ] && [ "$type_station" != "hva" ] && [ "$type_station" != "lv" ]
then
    echo ""$1" est un mauvais argument pour le deuxieme argument (hvb/hva/lv)"
    helpexit
fi

# check arg 3
if [ "$type_consommateur" != "comp" ] && [ "$type_consommateur" != "indiv" ] && [ "$type_consommateur" != "all" ]
then
    echo ""$2" est un mauvais argument pour le troisieme argument (comp/indiv/all)"
    helpexit
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
    helpexit
fi

# check arg 3 : si id_centrale <= 0 ou n'est pas déclaré (si non renseigné)
#if [ $id_centrale -lt 0 ] || [ -z "$id_centrale" ]
#then
#    echo "parametre id_centrale incorrect ou vide"
#    exit 1
#fi

# EXECUTABLE NON PRESENT DANS DOSSIER COURANT :
# make renvoie 0 si ok, autre chose sinon
if [ -e "main.c" ]
then
    :
else
    if make
    then
        make clean
    else
        echo "compilation error"
        exit 1
    fi
fi

# verif dossier tmp existe, le creer sinon, et le vider s'il existe deja
if [ -d "tmp" ]
then
    rm -rf tmp
    mkdir tmp
else
    mkdir tmp
fi




# le filtrage est chronometre : le code du filtrage est entre start_time et end_time

start_time=$(date +%s)

#TODO : echo rappel de la commande demandee
echo "RAPPEL filtrage demande : "$type_station" "$type_consommateur""

echo "debut filtrage : veuillez patienter"

# if [ "$type_station" == "" ]

# awk -F ';' 
# doc awk : https://www.funix.org/fr/unix/awk.htm

# Lorsque le script demande un type de station (hvb, hva, lv), le but final
# sera de créer un fichier contenant une liste de ces stations avec la valeur
# de capacité (la quantité d’énergie qu’elle peut laisser passer) et la somme
# des consommateurs branchés directement dessus.

# (conso) || (capacite)

case $type_station in
    hvb)
        if [ -z "$id_centrale" ]
        then
            # COMP sans id_centrale
            # conso : awk -F ';' '$2 != "-" && $3 == "-" && $4 == "-" && $5 != "-" && $6 == "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
            # capacite : awk -F ';' '$2 != "-" && $3 == "-" && $4 == "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-"' "$file_path" > "tmp/tmp.dat"
            awk -F ';' '($2 != "-" && $3 == "-" && $4 == "-" && $5 != "-" && $6 == "-" && $7 == "-") || ($2 != "-" && $3 == "-" && $4 == "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-")' "$file_path" > "tmp/tmp.dat"
        else
            # COMP avec id_centrale
            # awk -F ';' -v id="$id_centrale" '$1 == id && $2 != "-" && $3 == "-" && $4 == "-" && $5 != "-" && $6 == "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
            awk -F ';' -v id="$id_centrale" '$1 == id && (($2 != "-" && $3 == "-" && $4 == "-" && $5 != "-" && $6 == "-" && $7 == "-") || ($2 != "-" && $3 == "-" && $4 == "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-"))' "$file_path" > "tmp/tmp.dat"
        fi
        ;;
    hva)
        if [ -z "$id_centrale" ]
        then
            # COMP sans id_centrale
            # awk -F ';' '$3 != "-" && $4 == "-" && $5 != "-" && $6 == "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
            # awk -F ';' '$3 != "-" && $4 == "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-"' "$file_path" > "tmp/tmp.dat"
            awk -F ';' '($3 != "-" && $4 == "-" && $5 != "-" && $6 == "-" && $7 == "-") || ($3 != "-" && $4 == "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-")' "$file_path" > "tmp/tmp.dat"
        else
            # COMP avec id_centrale
            # awk -F ';' -v id="$id_centrale" '$1 == id && $3 != "-" && $4 == "-" && $5 != "-" && $6 == "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
            awk -F ';' -v id="$id_centrale" '$1 == id && (($3 != "-" && $4 == "-" && $5 != "-" && $6 == "-" && $7 == "-") || ($3 != "-" && $4 == "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-"))' "$file_path" > "tmp/tmp.dat"
        fi
        ;;
    lv)
        case $type_consommateur in
            comp)
                if [ -z "$id_centrale" ]
                then
                    # COMP sans id_centrale
                    # awk -F ';' '$2 == "-" && $3 != "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    # awk -F ';' '$2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 == "-" && $8 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' '($2 == "-" && $3 != "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 == "-" && $8 == "-")' "$file_path" > "tmp/tmp.dat"
                else
                    # COMP avec id_centrale
                    # awk -F ';' -v id="$id_centrale" '$1 == id && $2 == "-" && $3 != "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' -v id="$id_centrale" '$1 == id && (($2 == "-" && $3 != "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 == "-" && $8 == "-"))' "$file_path" > "tmp/tmp.dat"
                fi
                ;;
            indiv)
                if [ -z "$id_centrale" ]
                then
                    # INDIV sans id_centrale
                    # awk -F ';' '$2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' '($2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 == "-" && $8 == "-")' "$file_path" > "tmp/tmp.dat"
                else
                    # INDIV avec id_centrale
                    # awk -F ';' -v id="$id_centrale" '$1 == id && $2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' -v id="$id_centrale" '$1 == id && (($2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 == "-" && $8 == "-"))' "$file_path" > "tmp/tmp.dat"
                fi
                ;;
            all)
                if [ -z "$id_centrale" ]
                then
                    # ALL sans id_centrale
                    # awk -F ';' '$2 == "-" && $3 == "-" && $4 != "-" && (($5 == "-" && $6 != "-") || ($5 != "-" && $6 == "-")) && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' '($2 == "-" && $3 == "-" && $4 != "-" && (($5 == "-" && $6 != "-") || ($5 != "-" && $6 == "-")) && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 == "-" && $8 == "-")' "$file_path" > "tmp/tmp.dat"
                else
                    # ALL avec id_centrale
                    # awk -F ';' -v id="$id_centrale" '$1 == id && $2 == "-" && $3 == "-" && $4 != "-" && (($5 == "-" && $6 != "-") || ($5 != "-" && $6 == "-")) && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' -v id="$id_centrale" '$1 == id && (($2 == "-" && $3 == "-" && $4 != "-" && (($5 == "-" && $6 != "-") || ($5 != "-" && $6 == "-")) && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 == "-" && $8 == "-"))' "$file_path" > "tmp/tmp.dat"
                fi
                ;;
            *)
                # en theorie on arrive jamais ici
                ;;
        esac
        ;;
    *)
        # idem
        ;;
esac







end_time=$(date +%s)

elapsed=$((end_time - start_time))
echo "Temps écoulé : $elapsed secondes"