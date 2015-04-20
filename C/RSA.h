
#ifndef __RSA_H_INCLUDED__
#define __RSA_H_INCLUDED__

// Globally used libraries
#include <stdio.h>
#include <stdlib.h>

// Makros
#define GETLIMIT(n) (n * 13 / 10) // +30%

// Constants
#define MAX_NUMBERS 650000  // Maximum size of integer array

// Structures
typedef struct {
    unsigned int phi;
    unsigned int modN;
} Totient;

// Function Headers
unsigned int *encrypt(unsigned int const * const, size_t, unsigned int, Totient);
unsigned int *decrypt(unsigned int const * const, size_t, unsigned int, Totient);
unsigned int getprime(unsigned int n);
Totient totient(unsigned int p, unsigned int q);
unsigned int publicExp(Totient phi);
unsigned int inverse(Totient phi, unsigned int e);

#endif // __RSA_H_INCLUDED__