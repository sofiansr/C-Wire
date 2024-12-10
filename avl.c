
#include "avl.h"
#include <stdlib.h>

Node* createNode(Station* station) {
    Node* node = malloc(sizeof(Node));
    node->station = station;
    node->leftChild = NULL;
    node->rightChild = NULL;
    node->balance = 0;
    return node;
}

Node* insertStation(Node* root, Station* station, int* h) {
    Node* new = createNode(station);
    if (root == NULL) {
        *h = 1;
        return new;
    }
    if (station->id < root->station->id) {
        root->leftChild = insertStation(root->leftChild, station, h);
        *h = -*h;
    } else if (station->id > root->station->id) {
        root->rightChild = insertStation(root->rightChild, station, h);
    } else {
        *h = 0;
        return root;
    }

    if (*h != 0) {
        new->balance += *h;
        if (new->balance == 0) *h = 0;
        else *h = 1;
    }
    return root;
}

Station* findStation(Node* root, unsigned long id) {
    if (root == NULL) return NULL;
    if (root->station->id == id) {
        return root->station;
    }
    if (root->station->id < id) {
        return findStation(root->rightChild, id);
    }
    return findStation(root->leftChild, id);
}
void printTree(Node* root) {
    if (root == NULL) return;
    printTree(root->leftChild);
    printStation(root->station);
    printTree(root->rightChild);
}