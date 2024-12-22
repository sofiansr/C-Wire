#!/bin/bash

# Shows help if asked or if any argument is incorrect
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

# Check if any of the arguments is "-h"
for arg in "$@"
do
    if [ "$arg" == "-h" ]; then
        helpexit
    fi
done



# ----------- ROBUSTNESS -----------

# REMINDER, 3 arguments (4)
# arg 1 : file_path = file path
# arg 2 : type_station = station type (= hvb/hva/lv)
# arg 3 : type_consommateur = consumer type (=comp/indiv/all)
# (arg 4 : id_centrale = filter results for a specific power plant (>=1))

if [ $# -eq 0 ]
then
    echo "No arguments given"
    helpexit
fi

# récupération des arguments :
file_path=input/$1
type_station=$2
type_consommateur=$3

# check arg 1 : file existe dans dossier courant ?
if [ ! -e $file_path ]
then
    echo ""$file_path" file not found in the current directory"
    helpexit
fi

# empty file test
if [ ! -s "$file_path" ]
then
    echo ""$file_path" file empty"
    helpexit
fi

# read access test
if [ ! -r $file_path ]
then
    echo "no read access to "$file_path" file"
    helpexit
fi

# check arg 2
if [ "$type_station" != "hvb" ] && [ "$type_station" != "hva" ] && [ "$type_station" != "lv" ]
then
    echo ""$type_station" is a bad argument for 2nd argument (hvb/hva/lv)"
    helpexit
fi

# check arg 3
if [ "$type_consommateur" != "comp" ] && [ "$type_consommateur" != "indiv" ] && [ "$type_consommateur" != "all" ]
then
    echo ""$type_consommateur" is a bad argument for 3rd argument (comp/indiv/all)"
    helpexit
fi

# check if 4 arguments to declare id_centrale if so
if [ $# -eq 4 ]
then
    id_centrale=$(($4))             # int conversion
    if (( $id_centrale <= 0 ))
    then
        echo "id_centrale <= 0 is not allowed"
        helpexit
    fi
fi

# checking for forbidden case for arg 2 and arg 3
if [[ ( "$type_station" == "hvb" || "$type_station" == "hva" ) && 
      ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]]
then
    echo ""$type_station" argument and "$type_consommateur" argument incompatible"
    helpexit
fi

# check arg 3 : if id_centrale <= 0 ou is not declarated
if [ -n "$id_centrale" ] && [ "$id_centrale" -le 0 ]
then
    echo ""$id_centrale" <=0 is not allowed"
    helpexit
fi


# ----------- COMPILATION & FOLDERS -----------

# EXECUTABLE NOT IN FOLDER :
# make return 0 if ok, other otherwise 
cd codeC
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

cd ..

# checks if tmp folder exists, empty it, or create it otherwise
if [ -d "tmp" ] ; then
    rm -rf tmp
fi
mkdir -p tmp
mkdir -p tests

# checks if output folder exists, empty it, or create it otherwise
if [ -d "output" ] ; then
    mv output/* tests/
fi
mkdir -p output

# ----------- DATA FILTERING -----------

# filtering is timed : filtering code is between start_time and end_time

start_time=$(date +%s)


# ----------- DATA PROCESSING & OUTPUT -----------

output_folder="output"

codeC/exec "$file_path" "$type_station" "$type_consommateur" "$id_centrale"
# if id_centrale not given, then argc[3] = ""

# Testing program return code

case $? in
    10)
        echo "No data found error"
        exit 1
        ;;
    0)
        echo "C Program successfully executed, waiting for sorting..."
        ;;
    *)
        echo "Error code in C program "$?
        exit 1
        ;;
esac

if [ $# -eq 4 ]
then
    output_name=""$type_station"_"$type_consommateur"_"$id_centrale".csv"
    (head -n 1 tmp/tmp_final.csv && tail -n +2 tmp/tmp_final.csv | sort -t: -k2 -n) > "$output_folder/$output_name"
else
    output_name=""$type_station"_"$type_consommateur".csv"
    (head -n 1 tmp/tmp_final.csv && tail -n +2 tmp/tmp_final.csv | sort -t: -k2 -n) > "$output_folder/$output_name"
fi

# Testing sort return code
if [ $? -ne 0 ]
then
    echo "sort error"
    exit 1
fi

# lv all case : creating "lv_all_minmax.csv"
if [ "$type_station" == "lv" ] && [ "$type_consommateur" == "all" ]
then
    {
    head -n 1 tmp/tmp_final.csv
    tail -n +2 tmp/tmp_final.csv | sort -t: -k3 -n | tail -n 10
    tail -n +2 tmp/tmp_final.csv | sort -t: -k3 -n | head -n 10
    } > "${output_folder}/lv_all_minmax_${id_centrale}.csv"
    if [ -z "$id_centrale" ] ; then
    mv "${output_folder}/lv_all_minmax_.csv" "${output_folder}/lv_all_minmax.csv"
    fi
    
fi

# Testing sort return code
if [ $? -ne 0 ]
then
    echo "sort error"
    exit 1
fi

end_time=$(date +%s)
elapsed=$((end_time - start_time))

echo "Data processing finished"
echo "Elapsed time : $elapsed seconds"