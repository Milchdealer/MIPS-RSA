
#ifndef __RSA_H_INCLUDED__
#define __RSA_H_INCLUDED__

// Makros
#define GETLIMIT(n) (n * 13 / 10) // +30%

// Constants
#define MAX_NUMBERS 150000  // Maximum size of integer array

// Structures
typedef struct {
    unsigned int phi;
    unsigned int modN;
} Totient;

// Function Headers
void encrypt(char const * const M, char * const C, size_t num, unsigned int e, unsigned int n);
void decrypt(char const * const C, char * const M, size_t num, unsigned int d, unsigned int n);
unsigned int getprime(unsigned int n);
Totient totient(unsigned int p, unsigned int q);

#endif // __RSA_H_INCLUDED__