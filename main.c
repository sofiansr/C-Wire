#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "avl.h"
#include "request.h"
#include "output.h"

/**
 * @brief Entry point of the program.
 *
 * The program processes input arguments to perform operations on an AVL tree 
 * based on the type of station, consumer, and optionally, a specific station ID.
 *
 * @param argc Number of command-line arguments.
 * @param argv Array of command-line arguments.
 *        - argv[0]: Executable path
 *        - argv[1]: File path
 *        - argv[2]: Station type ("hvb", "hva", or "lv")
 *        - argv[3]: Consumer type ("comp", "indiv", or "all")
 *        - argv[4] (optional): Central station ID
 * @return 0 on success, exits with an error code on failure.
 */
int main(int argc, char** argv) {
    // Check if the required number of arguments is provided
    if (argc < 4) {
        exit(1); // Exit if not enough arguments
    }

    // Parse the consumer type
    ConsumerType type = 0;
    char* consumerType = argv[3];
    printf("Consumer type: %s\n", consumerType);
    if (strcmp(consumerType, "comp") == 0) type = COMP;         // Company
    else if (strcmp(consumerType, "indiv") == 0) type = INDIV;  // Individual
    else if (strcmp(consumerType, "all") == 0) type = ALL;      // All consumers
    else exit(1); // Exit if the consumer type is invalid

    // Parse the power station ID if provided
    int powerStation = 0;
    if (argc > 4) powerStation = atoi(argv[4]); // Convert the argument to an integer

    // Parse the station type
    char* stationType = argv[2];
    Node* node = NULL;

    // Handle requests based on the station type
    if (strcmp(stationType, "hvb") == 0) { 
        node = hvbRequest(argv[1], powerStation); // High Voltage Bus request
    } else if (strcmp(stationType, "hva") == 0) { 
        node = hvaRequest(argv[1], powerStation); // High Voltage Alternating request
    } else if (strcmp(stationType, "lv") == 0) { 
        node = lvRequest(argv[1], type, powerStation); // Low Voltage request
    } else {
        exit(1); // Exit if the station type is invalid
    }

    // Generate the output based on the processed data
    output(stationType, consumerType, powerStation, node);

    // Free the memory used by the AVL tree
    freeFullAvl(node);

    return 0;
}
