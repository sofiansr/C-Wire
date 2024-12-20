

#ifndef REQUEST_H
#define REQUEST_H

#include "avl.h"

typedef enum ConsumerType {
    ALL,
    COMP,
    INDIV
} ConsumerType;

Node* hvbRequest(char* tempFilePath);
Node* hvaRequest(char* tempFilePath);
Node* lvRequest(char* tempFilePath, ConsumerType type);

#endif