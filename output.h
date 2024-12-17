#ifndef OUTPUT_H
#define OUTPUT_H
#include "avl.h"
#include <stdio.h>

void output(char* type_station, char* type_conso, char* id_centrale, Node* avl);
void writeNodeInCSV(Node* root, FILE* fichier);


int nombreNoeud(Node* avl);
void parcoursForList(Node* root, Node** result, int* index);
void bubbleSort(Node** result, int size);
Node* getList(Node* root);
void writeNodeInCSVV2(Node* list, FILE* fichier, int* index);

#endif /* OUTPUT_H */