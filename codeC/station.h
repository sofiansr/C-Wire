/**
 * @file station.h
 * @brief Header file for the Station structure and related functions.
 */

#ifndef STATION_H
#define STATION_H

/**
 * @struct Station
 * @brief Represents a station with an ID, capacity, and total load.
 */
typedef struct {
    unsigned long id;               /**< Unique identifier for the station. */
    unsigned long long capacity;    /**< Maximum capacity of the station. */
    unsigned long long totalLoad;   /**< Current total load of the station. */
} Station;

/**
 * @brief Creates a new Station instance.
 * 
 * @param id Unique identifier for the station.
 * @param capacity Maximum capacity of the station.
 * @param load Current load of the station.
 * @return Pointer to the newly created Station.
 */
Station* createStation(unsigned long id, unsigned long long capacity, unsigned long long load);

/**
 * @brief Prints the details of a station.
 * 
 * @param station Pointer to the Station to be printed.
 */
void printStation(Station* station);

#endif /* STATION_H */
