
#ifndef __RSA_H_INCLUDED__
#define __RSA_H_INCLUDED__

// Makros
#define GETLIMIT(n) (n * 13 / 10) // +30%

// Constants
#define MAX_NUMBERS 150000  // Maximum size of integer array

// Function Headers
unsigned int getprime(unsigned int n);

#endif // __RSA_H_INCLUDED__