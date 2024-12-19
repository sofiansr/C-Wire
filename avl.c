
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

int min(int a, int b){
    if (a<b) return a;
    return b;
}

int max(int a, int b){
    if (a>b) return a;
    return b;
}

Node* leftRotate(Node* avl){
    Node* pivot = avl->rightChild;
    int eq_avl = avl->balance, eq_pivot = pivot->balance;
    avl->rightChild = pivot->leftChild;
    pivot->leftChild = avl;
    avl->balance = eq_avl - max(eq_pivot, 0) - 1;
    //pivot->balance = min(eq_avl - 2, eq_avl + eq_pivot - 2, eq_pivot - 1);
    pivot->balance = min(min(eq_avl - 2, eq_avl + eq_pivot - 2), eq_pivot - 1);
    return pivot;
}

Node* rightRotate(Node* avl){
    Node* pivot = avl->leftChild;
    int eq_avl = avl->balance, eq_pivot = pivot->balance;
    avl->leftChild = pivot->rightChild;
    pivot->rightChild = avl;
    avl->balance = eq_avl - min(eq_pivot, 0) + 1;
    //pivot->balance = max(eq_avl + 2, eq_avl + eq_pivot + 2, eq_pivot + 1);
    pivot->balance = max(max(eq_avl + 2, eq_avl + eq_pivot + 2), eq_pivot + 1);
    return pivot;
}

Node* doubleLeftRotate(Node* avl){
    avl->rightChild = rightRotate(avl->rightChild);
    return leftRotate(avl);
}

Node* doubleRightRotate(Node* avl){
    avl->leftChild = leftRotate(avl->leftChild);
    return rightRotate(avl);
}

Node* equilibrateAVL(Node* avl){
    if(avl->balance >= 2){
        if(avl->rightChild->balance >= 0){
            return leftRotate(avl);
        }
        else{
            return doubleLeftRotate(avl);
        }
    }
    else if(avl->balance <= -2){
        if(avl->leftChild->balance <= 0){
            return rightRotate(avl);
        }
        else{
            return doubleRightRotate(avl);
        }
    }
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
        // new = equilibrateAVL(new)
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

void freeFullAvl(Node* root) {
    if (root == NULL) return;
    freeFullAvl(root->leftChild);
    freeFullAvl(root->rightChild);
    free(root);
}