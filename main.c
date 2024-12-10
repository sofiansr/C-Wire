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
    Station* station = NULL;
    Node* hvbNode = NULL;
    Node* hvaNode = NULL;
    Node* lvNode = NULL;

    while (1) {
        char line[100];
        if (fgets(line, 100, file) == NULL) break;

        char* token = strtok(line, ";");
        unsigned long power_plant = strtoul(token, NULL, 10); // 5 centrales
        if (power_plant == 0) continue;
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

        int h = 0;
        Station* st;
        if (lvId != 0) {
            st = findStation(lvNode, lvId);
            if (st == NULL) {
                st = createStation(lvId, capacity, load);
                lvNode = insertStation(lvNode, st, &h);
            }
        } else if (hvaId != 0) {
            st = findStation(hvaNode, hvaId);
            if (st == NULL) {
                st = createStation(hvaId, capacity, load);
                hvaNode = insertStation(hvaNode, st, &h);
            }
        } else if (hvbId != 0) {
            st = findStation(hvbNode, hvbId);
            if (st == NULL) {
                st = createStation(hvbId, capacity, load);
                hvbNode = insertStation(hvbNode, st, &h);
            }
        } else continue; // power plant
        st->totalLoad += load;
    }
    fclose(file);

    return 0;
}