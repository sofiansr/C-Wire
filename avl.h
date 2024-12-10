#ifndef AVL_H
#define AVL_H
#include "station.h"

typedef struct Node Node;
struct Node {
    Station* station;
    int balance;
    Node* leftChild;
    Node* rightChild;
};

Node* createNode(Station* station);
Node* insertStation(Node* root, Station* station, int* h);
Station* findStation(Node* root, unsigned long id);
void printTree(Node* root);

#endif /* AVL_H */