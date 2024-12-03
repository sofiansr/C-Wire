#include <stdlib.h>
#include <stdio.h>


typedef enum {
    HV_A,
    HV_B,
    LV
} StationType;

typedef struct {
    int id;
    int capacity;
    int totalLoad;
    StationType type;
    Station* parent;
} Station;

Station* createStation(int id, StationType type, Station* parent, int capacity, int load) {
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
}

Station* find(Node* root, int id, StationType type) {
    if (root == NULL) return NULL;
    if (root->station->id == id) return root->station;
    if (id < root->station->id) {
        return find(root->leftChild, id);
    }
    return find(root->rightChild, id);
}



// fonction parcours largeur




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

        // TODO: revoir les tokens et le capacity
        char* token = strtok(line, ";");
        int powerPlantId = atoi(token);

        token = strtok(NULL, ";");
        int hv_b = atoi(token);
        token = strtok(NULL, ";");
        int hv_a = atoi(token);
        token = strtok(NULL, ";");
        int lv = atoi(token);

        token = strtok(NULL, ";");
        int load = atoi(token);
        if (capacity != 0) {  // new station
            station = createStation(id, capacity, load);
            root = insertAvl(root, station, &h);
        } else if (load != 0) { // new client 
            station->totalLoad += load;
            Station* tmp = station->parent;
            while (tmp != NULL) {
                tmp->totalLoad += load;
                tmp = tmp->parent;
            }
        }
    }
    fclose(file);

    return 0;
}