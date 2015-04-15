
#include "RSA.h"

#define MAX_NUMBERS 1500000  // Maximum size of integer array
#define MAX_PRIMES 100000 // Maximum size of prime array

/**
 *  Finding a prime number near n.
 *  @param n number as reference
 *  @return prime number near n
 */
uint32_t getprime(uint32_t n) {
	if (n >= 5) {
		uint32_t i, j, numbers[MAX_NUMBERS];
		uint32_t primes[MAX_PRIMES];
		
		for (i = 0; i < MAX_NUMBERS; i++)
			numbers[i] = i + 5; // Fill with some natural numbers > 5 (since we start at 5)
		
		// Sieve non primes
		for (i = 0; i MAX_NUMBERS; i++)
			if (numbers[i] != -1)
				for (j = 2 * numbers[i] - 5; j < MAX_NUMBERS; j += numbers[i])
					numbers[j] = -1;

		// Copy primes to their own array
		for (i = 0, j = 0; i < MAX_NUMBERS && j < MAX_PRIMES; i++)
			if (numbers[i] != -1)
				primes[j++] = numbers[i];
		
		for (i = 0; i < MAX_PRIMES; i++)
			printf("%d\n", primes[i]);
	} else if (n > 2) // 3 or 4
		return 3;
	else // 0 to 2
		return 2;
	return 0;
}