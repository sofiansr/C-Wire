#include <stdlib.h>
#include <stdio.h>
#include <string.h>


typedef enum {
    POWER_PLANT,
    HV_B,
    HV_A,
    LV
} StationType;

typedef struct Station Station;

struct Station {
    int id;
    long capacity;
    int totalLoad;
    StationType type;
    Station* parent;
} ;

Station* createStation(int id, StationType type, Station* parent, long capacity, int load) {
    Station* station = malloc(sizeof(Station));
    if (station == NULL) {
        exit(1);
    }
    station->id = id;
    station->type = type;
    station->parent = parent;
    station->capacity = capacity;
    station->totalLoad = load;
    return station;
}

typedef struct Node Node;

struct Node {
    Station* station;
    int balance;
    Node* leftChild;
    Node* rightChild;
};

Node* createNode(Station* station) {
    Node* node = malloc(sizeof(Node));
    node->station = station;
    node->leftChild = NULL;
    node->rightChild = NULL;
    node->balance = 0;
    return node;
}

Node* insertAvl(Node* root, Station* station, int* h) {
    Node* new = createNode(station);
    if (root == NULL) {
        *h = 1;
        return new;
    }
    if (station->capacity < root->station->capacity) {
        root->leftChild = insertAvl(root->leftChild, station, h);
        *h = -*h;
    } else if (station->capacity > root->station->capacity) {
        root->rightChild = insertAvl(root->rightChild, station, h);
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

typedef struct Cell Cell;
struct Cell {
    Cell* next;
    Node* node;
};

Cell* newCell(Node* node) {
    Cell* c = malloc(sizeof(Cell));
    if (c == NULL) exit(1);
    c->next = NULL;
    c->node = node;
    return c;
}

typedef struct {
    Cell* deb;
    Cell* fin;
} File;

File* enfile(File* file, Node* node) {
    if (file == NULL) return NULL;
    Cell* cell = newCell(node);
    if (file->fin != NULL) file->fin->next = cell;
    file->fin = cell;
    if (file->deb == NULL) file->deb = cell;
    return file;
}

Node* defile(File* file) {
    if (file == NULL) return NULL;
    Cell* cell = file->deb;
    if (cell == NULL) return NULL;

    Node* node = cell->node;
    file->deb = cell->next;
    if (file->deb == NULL) file->fin = NULL;
    free(cell);
    return node;
}

void affiche(Station* station) {
    if (station == NULL) return;
    printf("[");
    switch (station->type) {
        case POWER_PLANT:
            printf("Power plant ");
            break;
        case HV_B:
            printf("HV-B Station ");
            break;
        case HV_A:
            printf("HV-A Station ");
            break;
        case LV:
            printf("LV Station ");
            break;
        default:
            break;
    }
    printf("id=%d ", station->id);
    printf("cap=%ld ", station->capacity);
    printf("tot=%d]\n", station->totalLoad);
}

// fonction parcours largeur
void printTree(Node* root) {
    if (root == NULL) return;
    File* file = malloc(sizeof(File));
    if (file == NULL) exit(1);

    enfile(file, root);
    while (file->deb != NULL) {
        Node* node = defile(file);
        affiche(node->station);
        if (node->leftChild != NULL) {
            enfile(file, node->leftChild);
        }
        if (node->rightChild != NULL) {
            enfile(file, node->rightChild);
        }
    }
    free(file);
}


int main() {
    FILE* file = fopen("c-wire_v00.dat", "r");
    if (file == NULL) {
        printf("Error opening file\n");
        return 1;
    }
    int h = 0;
    Node* root = NULL;
    Station* station = NULL;
    while (1) {
        char line[100];
        if (fgets(line, 100, file) == NULL) break;

        char* token = strtok(line, ";");
        int power_plant = atoi(token);
        token = strtok(NULL, ";");
        int hv_b = atoi(token);
        token = strtok(NULL, ";");
        int hv_a = atoi(token);
        token = strtok(NULL, ";");
        int lv = atoi(token);
        token = strtok(NULL, ";");
        int company = atoi(token);
        token = strtok(NULL, ";");
        int individual = atoi(token);
        token = strtok(NULL, ";");
        long capacity = strtol(token, NULL, 10);
        token = strtok(NULL, ";");
        int load = atoi(token);

        if (load != 0) { // new client, so we fill the tree
            printf("new client %d\n", load);
            station->totalLoad += load;
            Station* tmp = station->parent;
            while (tmp != NULL) {
                tmp->totalLoad += load;
                tmp = tmp->parent;
            }
            continue;
        }

        if (capacity != 0) {  // new station
            if (lv != 0) {
                station = createStation(lv, LV, station, capacity, load);
            } else if (hv_a != 0) {
                station = createStation(hv_a, HV_A, station, capacity, load);
            } else if (hv_b != 0) {
                station = createStation(hv_b, HV_B, station, capacity, load);
            } else if (power_plant != 0) {
                station = createStation(power_plant, POWER_PLANT, station, capacity, load);
            } else {
                // TODO: handle error
                exit(2);
            }
            affiche(station);
            root = insertAvl(root, station, &h);
        }
        
    }
    fclose(file);

    return 0;
}