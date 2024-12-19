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
int min(int a, int b);
int max(int a, int b);
Node* leftRotate(Node* avl);
Node* rightRotate(Node* avl);
Node* doubleLeftRotate(Node* avl);
Node* doubleRightRotate(Node* avl);
Node* equilibrateAVL(Node* avl);
Node* insertStation(Node* root, Station* station, int* h);
Station* findStation(Node* root, unsigned long id);
void printTree(Node* root);
void freeFullAvl(Node* root);

#endif /* AVL_H */