#include <stdlib.h>
#include "station.h"

Station* createStation(int id, long capacity, long load) {
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
    printf("id=%d ", station->id);
    printf("cap=%ld ", station->capacity);
    printf("tot=%d", station->totalLoad);
    printf("]\n");
}