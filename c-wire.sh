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
    ARG 4 (optional) : PLANT ID (int >0)
    
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



# ----------- ROBUSTESSE -----------

# rappel, 3 arguments (4)
# arg 1 : file_path = chemin du fichier
# arg 2 : type_station = type de station (= hvb/hva/lv)
# arg 3 : type_consommateur = type consommateur (=comp/indiv/all)
# (arg 4 : id_centrale = filtre les résultats pour une centrale spécifique (>=1))

if [ $# -eq 0 ]
then
    echo "Aucun argument passé en paramètre"
    helpexit
fi

# récupération des arguments :
file_path=$1
type_station=$2
type_consommateur=$3

# check arg 1 : file existe dans dossier courant ?
if [ ! -e $file_path ]
then
    echo "fichier "$file_path" non présent dans le dossier courant"
    helpexit
fi

# test fichier vide
if [ ! -s "$file_path" ]
then
    echo "fichier "$file_path" vide"
    helpexit
fi

# test perm lecture
if [ ! -r $file_path ]
then
    echo "pas d'acces en lecture au fichier "$file_path""
    helpexit
fi

# check arg 2
if [ "$type_station" != "hvb" ] && [ "$type_station" != "hva" ] && [ "$type_station" != "lv" ]
then
    echo ""$type_station" est un mauvais argument pour le deuxieme argument (hvb/hva/lv)"
    helpexit
fi

# check arg 3
if [ "$type_consommateur" != "comp" ] && [ "$type_consommateur" != "indiv" ] && [ "$type_consommateur" != "all" ]
then
    echo ""$type_consommateur" est un mauvais argument pour le troisieme argument (comp/indiv/all)"
    helpexit
fi

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

# vérif des cas interdits arg 2 et 3
if [[ ( "$type_station" == "hvb" || "$type_station" == "hva" ) && 
      ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]
then
    echo "argument "$type_station" et argument "$type_consommateur" incompatible"
    helpexit
fi

# check arg 3 : si id_centrale <= 0 ou n'est pas déclaré (si non renseigné)
if [ -n "$id_centrale" ] && [ "$id_centrale" -le 0 ]
then
    echo ""$id_centrale" <=0 non autorise"
    helpexit
fi


# ----------- COMPILATION & DOSSIERS -----------

# EXECUTABLE NON PRESENT DANS DOSSIER COURANT :
# make renvoie 0 si ok, autre chose sinon
if [ ! -e "exec" ]
then
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



# ----------- FILTRAGE -----------

# le filtrage est chronometre : le code du filtrage est entre start_time et end_time

start_time=$(date +%s)

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
                    # awk -F ';' '($2 == "-" && $3 != "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 == "-" && $8 == "-")' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' '($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 != "-") || ($2 == "-" && $3 == "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-" && $8 != "-")' "$file_path" > "tmp/tmp.dat"
                else
                    # COMP avec id_centrale
                    # awk -F ';' -v id="$id_centrale" '$1 == id && $2 == "-" && $3 != "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' -v id="$id_centrale" '$1 == id && (($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 != "-") || ($2 == "-" && $3 == "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-" && $8 != "-"))' "$file_path" > "tmp/tmp.dat"
                fi
                ;;
            indiv)
                if [ -z "$id_centrale" ]
                then
                    # INDIV sans id_centrale
                    # awk -F ';' '$2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' '($2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-")' "$file_path" > "tmp/tmp.dat"
                else
                    # INDIV avec id_centrale
                    # awk -F ';' -v id="$id_centrale" '$1 == id && $2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' -v id="$id_centrale" '$1 == id && (($2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-"))' "$file_path" > "tmp/tmp.dat"
                fi
                ;;
            all)
                if [ -z "$id_centrale" ]
                then
                    # ALL sans id_centrale
                    # awk -F ';' '$2 == "-" && $3 == "-" && $4 != "-" && (($5 == "-" && $6 != "-") || ($5 != "-" && $6 == "-")) && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    # awk -F ';' '($2 == "-" && $3 == "-" && $4 != "-" && (($5 == "-" && $6 != "-") || ($5 != "-" && $6 == "-")) && $7 == "-") || ($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 == "-" && $8 == "-")' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' '($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-") || ($2 == "-" && $3 == "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-" && $8 != "-") || ($2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-")' "$file_path" > "tmp/tmp.dat"
                else
                    # ALL avec id_centrale
                    # awk -F ';' -v id="$id_centrale" '$1 == id && $2 == "-" && $3 == "-" && $4 != "-" && (($5 == "-" && $6 != "-") || ($5 != "-" && $6 == "-")) && $7 == "-"' "$file_path" > "tmp/tmp.dat"
                    awk -F ';' -v id="$id_centrale" '$1 == id && (($2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 != "-" && $8 == "-") || ($2 == "-" && $3 == "-" && $4 != "-" && $5 != "-" && $6 == "-" && $7 == "-" && $8 != "-") || ($2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $7 == "-"))' "$file_path" > "tmp/tmp.dat"
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



# ----------- TRAITEMENT -----------

./exec "$file_path" "$type_station" "$type_consommateur" "$id_centrale"
# si id_centrale non renseigne, alors argc[3] = "" 

output_name=""$type_station"_"$type_consommateur".csv"
(head -n 1 "$output_name" && tail -n +2 data.txt | sort -t\; -k2 -n) > "$output_name"


end_time=$(date +%s)

elapsed=$((end_time - start_time))
echo "Traitement terminé"
echo "Temps écoulé : $elapsed secondes"