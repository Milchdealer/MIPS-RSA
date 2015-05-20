
#ifndef __RSA_H_INCLUDED__
#define __RSA_H_INCLUDED__

// Globally used libraries
#include <stdio.h> // I/O
#include <stdlib.h> // alloc

// Makros
#define GETLIMIT(n) (n * 13 / 10) // +30%

// Constants
#define MAX_NUMBERS 1200  // Maximum size of integer array

// Structures
typedef struct {
    unsigned int phi;
    unsigned int modN;
    unsigned int p, q;
} Totient;

// Function Headers
unsigned int *crypt(unsigned int const * const, size_t, unsigned int, Totient);
unsigned int getprime(unsigned int n);
Totient totient(unsigned int p, unsigned int q);
unsigned int publicExp(Totient phi);
unsigned int inverse(Totient phi, unsigned int e);

#endif // __RSA_H_INCLUDED__