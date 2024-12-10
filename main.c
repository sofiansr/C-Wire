#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "avl.h"

int main() {
    FILE* file = fopen("c-wire_v00.dat", "r");
    if (file == NULL) {
        printf("Error opening file\n");
        return 1;
    }
    int h = 0;
    Node* root = NULL;
    Station* station = NULL;
    while (1) {
        char line[100];
        if (fgets(line, 100, file) == NULL) break;

        char* token = strtok(line, ";");
        unsigned long power_plant = atoi(token); // 5 centrales
        token = strtok(NULL, ";");
        unsigned long hvbId = strtoul(token, NULL, 10); // ~118 sous-stations HV-B
        token = strtok(NULL, ";");
        unsigned long hvaId = strtoul(token, NULL, 10); // ~512 sous-stations HV-A
        token = strtok(NULL, ";");
        unsigned long lvId = strtoul(token, NULL, 10); // +180k postes LV
        token = strtok(NULL, ";");
        unsigned long companyId = strtoul(token, NULL, 10); // +1.25M consommateurs (entreprises)
        token = strtok(NULL, ";");
        unsigned long long individualId = strtoull(token, NULL, 10); // +7.6M   consommateurs (particuliers)
        token = strtok(NULL, ";");

        unsigned long long capacity = strtoull(token, NULL, 10);
        token = strtok(NULL, ";");
        unsigned long long load = strtoull(token, NULL, 10);

        if (load != 0) { // new client, so we fill the tree
            printf("new client %llu\n", load);
            // TODO

        }

        if (capacity != 0) {  // new station
            // TODO
        }
        
    }
    fclose(file);

    return 0;
}