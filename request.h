

#ifndef REQUEST_H
#define REQUEST_H

#include "avl.h"

typedef enum ConsumerType {
    ALL,
    COMP,
    INDIV
} ConsumerType;

Node* hvbRequest(char* tempFilePath, int power_plant);
Node* hvaRequest(char* tempFilePath, int power_plant);
Node* lvRequest(char* tempFilePath, ConsumerType type, int power_plant);

#endif