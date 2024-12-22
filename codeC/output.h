#ifndef OUTPUT_H
#define OUTPUT_H
#include "avl.h"
#include <stdio.h>

void output(char* type_station, char* type_conso, int id_centrale, Node* avl);
void writeNodeInCSV(Node* root, FILE* fichier);

#endif /* OUTPUT_H */