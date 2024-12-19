/**
 * @file avl.h
 * @brief Header file for AVL tree implementation for managing stations.
 */

#ifndef AVL_H
#define AVL_H

#include "station.h"

/**
 * @struct Node
 * @brief Represents a node in the AVL tree.
 */
typedef struct Node Node;
struct Node {
    Station* station;   /**< Pointer to a station associated with the node. */
    int balance;        /**< Balance factor of the node. */
    Node* leftChild;    /**< Pointer to the left child node. */
    Node* rightChild;   /**< Pointer to the right child node. */
};

/**
 * @brief Creates a new node for the AVL tree.
 * @param station Pointer to the station to associate with the new node.
 * @return Pointer to the created node.
 */
Node* createNode(Station* station);

/**
 * @brief Returns the minimum of two integers.
 * @param a First integer.
 * @param b Second integer.
 * @return The smaller of the two integers.
 */
int min(int a, int b);

/**
 * @brief Returns the maximum of two integers.
 * @param a First integer.
 * @param b Second integer.
 * @return The larger of the two integers.
 */
int max(int a, int b);

/**
 * @brief Performs a left rotation on an AVL tree.
 * @param avl Pointer to the root node of the subtree to rotate.
 * @return Pointer to the new root of the rotated subtree.
 */
Node* leftRotate(Node* avl);

/**
 * @brief Performs a right rotation on an AVL tree.
 * @param avl Pointer to the root node of the subtree to rotate.
 * @return Pointer to the new root of the rotated subtree.
 */
Node* rightRotate(Node* avl);

/**
 * @brief Performs a double left rotation on an AVL tree.
 * @param avl Pointer to the root node of the subtree to rotate.
 * @return Pointer to the new root of the rotated subtree.
 */
Node* doubleLeftRotate(Node* avl);

/**
 * @brief Performs a double right rotation on an AVL tree.
 * @param avl Pointer to the root node of the subtree to rotate.
 * @return Pointer to the new root of the rotated subtree.
 */
Node* doubleRightRotate(Node* avl);

/**
 * @brief Balances an AVL tree.
 * @param avl Pointer to the root node of the subtree to balance.
 * @return Pointer to the new root of the balanced subtree.
 */
Node* equilibrateAVL(Node* avl);

/**
 * @brief Inserts a station into the AVL tree.
 * @param root Pointer to the root node of the AVL tree.
 * @param station Pointer to the station to insert.
 * @param h Pointer to an integer tracking the height change.
 * @return Pointer to the root node of the updated AVL tree.
 */
Node* insertStation(Node* root, Station* station, int* h);

/**
 * @brief Finds a station in the AVL tree by its ID.
 * @param root Pointer to the root node of the AVL tree.
 * @param id ID of the station to find.
 * @return Pointer to the station if found, otherwise NULL.
 */
Station* findStation(Node* root, unsigned long id);

/**
 * @brief Prints the structure of the AVL tree.
 * @param root Pointer to the root node of the AVL tree.
 */
void printTree(Node* root);

/**
 * @brief Frees the memory allocated for the entire AVL tree.
 * @param root Pointer to the root node of the AVL tree.
 */
void freeFullAvl(Node* root);

#endif /* AVL_H */
