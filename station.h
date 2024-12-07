#ifndef STATION_H
#define STATION_H

typedef struct  {
    unsigned long id;
    unsigned long long capacity;
    unsigned long long totalLoad;
} Station;

Station* createStation(unsigned long id, unsigned long long capacity, unsigned long long load);
void printStation(Station* station);

#endif /* STATION_H */