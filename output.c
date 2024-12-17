#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "avl.h"

void output(char* type_station, char* type_conso, char* id_centrale, Node* avl){
    FILE* fichier = NULL;
    char nom_fichier[50]; // tmp

    if(type_station == NULL || type_conso == NULL || id_centrale == NULL || avl == NULL){
        exit(1);
    }

    // fichier = fopen("test.txt", "r+");
    if(strcmp(id_centrale, "") == 0){
        sprintf(nom_fichier, "%s_%s.csv", type_station, type_conso);
    }
    else{
        sprintf(nom_fichier, "%s_%s_%s.csv", type_station, type_conso, id_centrale);
    }
    
    FILE *fichier = fopen(nom_fichier, "w+");

    if(strcmp(type_station, "hvb") == 0){
        fputs("Station HVB:Capacite:Consommation (entreprises)\n", fichier);
    }
    else if(strcmp(type_station, "hva") == 0){
        fputs("Station HVA:Capacite:Consommation (entreprises)\n", fichier);
    }
    if(strcmp(type_station, "lv") == 0){
        if(strcmp(type_conso, "comp") == 0){
            fputs("Station LV:Capacite:Consommation (entreprises)\n", fichier);
        }
        else if(strcmp(type_station, "indiv") == 0){
            fputs("Station LV:Capacite:Consommation (particuliers)\n", fichier);
        }
        else{
            fputs("Station LV:Capacite:Consommation (tous)\n", fichier);
        }
    }

    writeNodeInCSV(avl, fichier);

    fclose(fichier);
}

void writeNodeInCSV(Node* root, FILE* fichier) {
    if (root == NULL) return;
    writeNodeInCSV(root->leftChild, fichier);
    //printStation(root->station);
    //fputs("Station LV:Capacite:Consommation (tous)\n", fichier);
    //fprintf( fichier, "Tu es née en %d \n", ans);
    fprintf( fichier, "%lu:%llu:%llu\n", root->station->id, root->station->capacity, root->station->totalLoad);
    writeNodeInCSV(root->rightChild, fichier);
}

// -----------------------

// l'idée : parcourir l'avl, mettre tout dans une liste, trier cette liste par capacité croissante, l'utiliser pour l'output

int nombreNoeud(Node* avl){
    if(avl == NULL){
        return 0;
    }
    return 1 + nombreNoeud(avl->leftChild) + nombreNoeud(avl->rightChild);
}

// result = liste de pointeur de node
void parcoursForList(Node* root, Node** result, int* index) {
    if (root == NULL) return;
    parcoursForList(root->leftChild, result, index);
    result[*index] = root;
    (*index)++;
    parcoursForList(root->rightChild, result, index);
}

// utiliser index pour size

void bubbleSort(Node** result, int size) {
    for (int i = 0; i < size - 1; i++) {
        for (int j = i + 1; j < size; j++) {
            if (result[i]->station->capacity > result[j]->station->capacity) {
                Node* temp = result[i];
                result[i] = result[j];
                result[j] = temp;
            }
        }
    }
}

Node* getList(Node* root) {
    int taille = nombreNoeud(root);
    Node* result = malloc(taille * sizeof(Node));
    //Node* result[1000];
    int index = 0;

    //parcourir l'avl et mettre les noeuds dans une liste
    parcoursForList(root, result, &index);
    // trier la liste
    bubbleSort(result, index);

    return result;
}

void writeNodeInCSVV2(Node* list, FILE* fichier, int* index) {
    if (list == NULL) exit(1);
    for(int i=0; i<*index; i++){
        fprintf( fichier, "%lu:%llu:%llu\n", list->station->id, list->station->capacity, list->station->totalLoad);
    }
}