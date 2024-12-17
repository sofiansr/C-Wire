#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "avl.h"
#include "request.h"

void checkArgs(int argc, char** argv) {

}

int main(int argc, char** argv) {
    // argc[0] = chemin du fichier
    // argc[1] = type de station
    // argc[2] = type de consommateur
    // argc[3] = id_centrale (optionnel)

    if (argc < 3) {
        exit(1);
    }
    
    ConsumerType type = 0;
    char* consumerType = argv[2];
    if (strcmp(consumerType, "comp") == 0) type = COMP;
    else if (strcmp(consumerType, "indiv") == 0) type = INDIV;
    else if (strcmp(consumerType, "all") == 0) type = ALL;
    else exit(1);

    int idCentral = 0;
    if (argc == 4) idCentral = atoi(argv[3]);

    Node* node = NULL;
    if (strcmp(stationType, "hvb") == 0) node = hvbRequest("tmp/tmp.dat");
    else if (strcmp(stationType, "hva") == 0) node = hvaRequest("tmp/tmp.dat");
    else if (strcmp(stationType, "lv") == 0) node = lvRequest("tmp/tmp.dat", type);
    else exit(1);

    return 0;
}