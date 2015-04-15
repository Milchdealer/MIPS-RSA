
#include "RSA.h"

#include <string.h> // memset

/**
 * Finds the closest number in the array to the given number.
 * In case n is exactly in the middle of two prime numbers, take the smaller one.
 * @param values array to search through
 * @param n number as reference
 * @return closest number
 */
unsigned int findClosest(signed char values[], unsigned int n) {
    unsigned int i[2];

    i[0] = i[1] = n;
    while (!values[i[0]] && !values[i[1]]) {
        if (i[0] > 2)
            i[0]--;
        if (i[1] < MAX_NUMBERS)
            i[1]++;
    }

    if (values[i[0]]) // Always try the smaller one first
	    return i[0];
    return i[1];
}

/**
 *  Finding a prime number near n.
 *  @param n number as reference
 *  @return prime number near n
 */
unsigned int getprime(unsigned int n) {
	if (n > MAX_NUMBERS)
		return 0; // error

	if (n >= 5) {
        unsigned int i, j;
        signed char primes[MAX_NUMBERS];
		
        memset(primes, 1, sizeof(primes)); // consider all as primes
		
		// Sieve non primes
        for (i = 2; i < MAX_NUMBERS; i++)
            if (primes[i]) // currently considered prime
                for (j = i; j*i < MAX_NUMBERS; j++)
                    primes[j * i] = 0; // cross out primes
		
        // Do segmented sieve here, if out of memory, because:
        // http://stackoverflow.com/questions/26201489/how-does-segmentation-improve-the-running-time-of-sieve-of-eratosthenes
        // refs:
        // http://stackoverflow.com/questions/6461445/find-primes-in-a-certain-range-efficiently
        // http://primesieve.org/segmented_sieve.html

		// Find closest number to n
		return findClosest(primes, n);
	} else if (n > 2) // 3 or 4
		return 3;
	else // 0 to 2
		return 2;
}

/**
 * Calculate the totient phi from two prime numbers.
 * @param p First prime number
 * @param q Second prime number
 * @return Totient contains phi and modN
 */
Totient totient(unsigned int p, unsigned int q) {
    Totient ret;

    ret.phi = (p - 1) * (q - 1);
    ret.modN = p * q;

    if (ret.phi < p || ret.phi < q ||
        ret.modN < p || ret.modN < q) { // out of bound
        ret.phi = 0;
        ret.modN = 0;
    }

    return ret;
}

/**
 * Finds the greates common divisor.
 * @param a left hand number
 * @param b right hand number
 * @return GCD
 */
unsigned int GCD(unsigned int a, unsigned int b) {
    if (a == 0)
        return b;
    while (b != 0) {
        if (a > b)
            a -= b;
        else
            b -= a;
    }
    return a;
}
/**
 * Calculate the exponent d representing the multiplicative inverse of e % phi).
 * @param phi totient phi
 * @param e exponent e
 * @return exponent d
 */
unsigned int inverse(Totient phi, unsigned int e) {
    unsigned int d = GCD(phi.modN, e);
    return d;
}