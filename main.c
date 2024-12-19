#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "avl.h"
#include "request.h"
#include "output.h"

void checkArgs(int argc, char** argv) {

}

int main(int argc, char** argv) {
    // argc[1] = chemin du fichier
    // argc[2] = type de station
    // argc[3] = type de consommateur
    // argc[4] = id_centrale (optionnel)

    if (argc < 4) {
        exit(1);
    }
    printf("Nombre d'arguments: %d\n", argc);
    printf("Arguments: %s %s %s\n", argv[1], argv[2], argv[3]);
    
    ConsumerType type = 0;
    char* consumerType = argv[3];
    printf("Type de consommateur: %s\n", consumerType);
    if (strcmp(consumerType, "comp") == 0) type = COMP;
    else if (strcmp(consumerType, "indiv") == 0) type = INDIV;
    else if (strcmp(consumerType, "all") == 0) type = ALL;
    else exit(1);

    int idCentral = 0;
    if (argc == 4) {
        idCentral = atoi(argv[4]);
        printf("Id central trouvé !\n");
    } else {
        printf("Pas d'id central renseigné.\n");
    }
    char* stationType = argv[2];
    Node* node = NULL;

    if (strcmp(stationType, "hvb") == 0) node = hvbRequest("tmp/tmp.dat");
    else if (strcmp(stationType, "hva") == 0) node = hvaRequest("tmp/tmp.dat");
    else if (strcmp(stationType, "lv") == 0) node = lvRequest("tmp/tmp.dat", type);
    else exit(1);
    printTree(node);

    // output

    output(stationType, consumerType, idCentral, node);

    freeFullAvl(node);

    return 0;
}