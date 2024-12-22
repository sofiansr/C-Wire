#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "avl.h"
#include "output.h"

void output(char* type_station, char* type_conso, int id_centrale, Node* avl){
    if (type_station == NULL || type_conso == NULL || avl == NULL){
        exit(10);
    }

    FILE* file = NULL;
    file = fopen("tmp/tmp_final.csv", "w+");
    if (file == NULL) exit(1);

    if (strcmp(type_station, "hvb") == 0) {
        fputs("Station HVB:Capacite:Consommation (entreprises)\n", file);
    }
    else if (strcmp(type_station, "hva") == 0) {
        fputs("Station HVA:Capacite:Consommation (entreprises)\n", file);
    }
    else if (strcmp(type_station, "lv") == 0) {
        if (strcmp(type_conso, "comp") == 0) {
            fputs("Station LV:Capacite:Consommation (entreprises)\n", file);
        }
        else if (strcmp(type_conso, "indiv") == 0) {
            fputs("Station LV:Capacite:Consommation (particuliers)\n", file);
        }
        else {
            fputs("Station LV:Capacite:Consommation (tous)\n", file);
        }
    }

    writeNodeInCSV(avl, file);
    fclose(file);
}

void writeNodeInCSV(Node* root, FILE* file) {
    if (root == NULL) return;
    writeNodeInCSV(root->leftChild, file);
    fprintf(file, "%lu:%llu:%llu\n", root->station->id, root->station->capacity, root->station->totalLoad);
    writeNodeInCSV(root->rightChild, file);
}