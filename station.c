#include <stdlib.h>
#include "station.h"
#include <stdio.h>

Station* createStation(unsigned long id, unsigned long long capacity, unsigned long long load) {
    Station* station = malloc(sizeof(Station));
    if (station == NULL) {
        exit(1);
    }
    station->id = id;
    station->capacity = capacity;
    station->totalLoad = load;
    return station;
}
void printStation(Station* station) {
    if (station == NULL) return;
    printf("[");
    printf("id=%lu ", station->id);
    printf("cap=%llu ", station->capacity);
    printf("tot=%llu", station->totalLoad);
    printf("]\n");
}