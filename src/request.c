#include "request.h"
#include "station.h"
#include "avl.h"
#include <stdio.h>
#include <stdlib.h>


typedef struct {
    unsigned long power_plant; // 5 centrales
    unsigned long hvbId; // ~118 sous-stations HV-B
    unsigned long hvaId; // ~512 sous-stations HV-A
    unsigned long lvId; // +180k postes LV
    unsigned long companyId; // +1.25M consommateurs (entreprises)
    unsigned long long individualId; // +7.6M   consommateurs (particuliers)
    unsigned long long capacity;
    unsigned long long load;
} FileLine;

FileLine parseLine(char* line) {
    FileLine fileLine;
    char* token = strtok(line, ";");
    fileLine.power_plant = strtoul(token, NULL, 10); // 5 centrales
    token = strtok(NULL, ";");
    fileLine.hvbId = strtoul(token, NULL, 10); // ~118 sous-stations HV-B
    token = strtok(NULL, ";");
    fileLine.hvaId = strtoul(token, NULL, 10); // ~512 sous-stations HV-A
    token = strtok(NULL, ";");
    fileLine.lvId = strtoul(token, NULL, 10); // +180k postes LV
    token = strtok(NULL, ";");
    fileLine.companyId = strtoul(token, NULL, 10); // +1.25M consommateurs (entreprises)
    token = strtok(NULL, ";");
    fileLine.individualId = strtoull(token, NULL, 10); // +7.6M   consommateurs (particuliers)
    token = strtok(NULL, ";");
    fileLine.capacity = strtoull(token, NULL, 10);
    token = strtok(NULL, ";");
    fileLine.load = strtoull(token, NULL, 10);
    return fileLine;
}

Node* hvbRequest(char* tempFilePath) {

    FILE* file = fopen(tempFilePath, "r");
    if (file == NULL) {
        exit(1);
    }

    char* line = NULL;
    Node* node = NULL;
    int h = 0;
    while (1) {
        fgets(line, 100, file);
        if (line == NULL) break;
        FileLine fileLine = parseLine(line);

        if (fileLine.individualId > 0 || fileLine.lvId > 0 || fileLine.hvaId > 0) {
            continue;
        }
        Station* station = findStation(node, fileLine.hvbId);
        if (station == NULL) {
            station = createStation(fileLine.hvbId, fileLine.capacity, fileLine.load);
            node = insertStation(node, station, &h);
        } else {
            station->totalLoad += fileLine.load;
        }
    }

    fclose(file);
    return node;
}

Node* hvaRequest(char* tempFilePath) {

    FILE* file = fopen(tempFilePath, "r");
    if (file == NULL) {
        exit(1);
    }

    char* line = NULL;
    Node* node = NULL;
    int h = 0;
    while (1) {
        fgets(line, 100, file);
        if (line == NULL) break;
        FileLine fileLine = parseLine(line);

        if (fileLine.companyId > 0 || fileLine.lvId > 0) {
            continue;
        }
        Station* station = findStation(node, fileLine.hvaId);
        if (station == NULL) {
            station = createStation(fileLine.hvaId, fileLine.capacity, fileLine.load);
            node = insertStation(node, station, &h);
        } else {
            station->totalLoad += fileLine.load;
        }
    }

    fclose(file);
    return node;
}

Node* lvRequest(char* tempFilePath, ConsumerType type) {

    FILE* file = fopen(tempFilePath, "r");
    if (file == NULL) {
        exit(1);
    }

    char* line = NULL;
    Node* node = NULL;
    int h = 0;
    while (1) {
        fgets(line, 100, file);
        if (line == NULL) break;
        FileLine fileLine = parseLine(line);

        if (fileLine.companyId > 0 && type == INDIV) continue;
        if (fileLine.individualId > 0 && type == COMP) continue;
        
        Station* station = findStation(node, fileLine.lvId);
        if (station == NULL) {
            station = createStation(fileLine.lvId, fileLine.capacity, fileLine.load);
            node = insertStation(node, station, &h);
        } else {
            station->totalLoad += fileLine.load;
        }
    }
    
    fclose(file);
    return node;
}