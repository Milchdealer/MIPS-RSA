
#include "RSA.h"

#include <math.h> // floor, sqrt
#include <string.h> // memset

// static function headers
unsigned int modmult(unsigned int a, unsigned int b, unsigned int n);
unsigned int findClosest(unsigned int n); 
unsigned int powmod(unsigned int a, unsigned int b, unsigned int mod);
unsigned int GCD(unsigned int a, unsigned int b);

// static variables
static signed char primes[MAX_NUMBERS];

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
		
        memset(primes, 1, sizeof(primes)); // consider all as primes
		
		// Sieve non primes
        for (i = 2; i < MAX_NUMBERS; i++)
            if (primes[i]) // currently considered prime
                for (j = i; j*i < MAX_NUMBERS; j++) // Takes multiples of the current prime
                    primes[j * i] ^= primes[j * i]; // cross out non-primes
		
        // Do segmented sieve here, if out of memory, because:
        // http://stackoverflow.com/questions/26201489/how-does-segmentation-improve-the-running-time-of-sieve-of-eratosthenes
        // refs:
        // http://stackoverflow.com/questions/6461445/find-primes-in-a-certain-range-efficiently
        // http://primesieve.org/segmented_sieve.html

		// Find closest number to n
		return findClosest(n);
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

    if (//ret.phi < p || ret.phi < q || // Since N is bigger, if N is in bound, so is phi
        ret.modN < p || ret.modN < q) { // out of bound
        ret.phi = 0;
        ret.modN = 0;
    }
    ret.p = p;
    ret.q = q;

    return ret;
}

/**
 * Encrypts message M with length num into ciphertext C.
 * @param M message to encrypt
 * @param num length of M
 * @param e exponent
 * @param n modulus
 * @return pointer to the array containing the 
 */
unsigned int *encrypt(unsigned int const * const M, size_t num, unsigned int e, Totient phi) {
	unsigned int i;
	unsigned int *cipher;

	cipher = (unsigned *) malloc(sizeof(unsigned int) * num);

	for (i = 0; i < num; i++)
		cipher[i] = powmod(M[i], e, phi.modN);

	return cipher;
}

/**
 * Decrypts ciphertext C with length num into message M.
 * @param C ciphertext to decrypt
 * @param num length of C
 * @param d exponent inverse
 * @param n modulus
 */
unsigned int *decrypt(unsigned int const * const C, size_t num, unsigned int d, Totient phi) {
	unsigned int i;
	unsigned int *message;

	message = (unsigned int *) malloc(sizeof(unsigned int) * num);

	for (i = 0; i < num; i++)
		message[i] = powmod(C[i], d, phi.modN);
	
	return message;
}

unsigned int modInverse(unsigned a, Totient phi) {
	return powmod(a, phi.phi - 2, phi.phi);
}

/**
 * Gets the public exponent based on the totient.
 * @param phi Totient to base the public exponent on
 * @return public exponent
 */
unsigned int publicExp(Totient phi) {
	unsigned int i;

	for (i = 2; i < phi.phi; i++) {
		if (GCD(i, phi.phi) != 1)
			continue;
		if (primes[i])
			return i;
	}
	// Error: No public exponent found
	return getprime(rand() % 1024 + 2);
}

// Helper Functions\\ 

/** This function calculates (a^b)%phi.
 * @param a base
 * @param b exponent
 * @param phi modulus
 * @return (a^b)%phi
 */
unsigned int powmod(unsigned int a, unsigned int b, unsigned int mod) {
	unsigned int x = 1, y = a;
    while(b > 0) {
        if(b % 2) {
            x= x * y;
            if(x > mod)
				x %= mod;
        }
        y = y * y;
        if (y)
            y %= mod;
        b /= 2;
    }
    return x;
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
    int b0 = phi.phi, t, q;
	int x0 = 0, x1 = 1;

	if (phi.phi == 1)
		return 1;
	while (e > 1) {
		q = e / phi.phi;
		t = phi.phi, phi.phi = e % phi.phi, e = t;
		t = x0, x0 = x1 - q * x0, x1 = t;
	}
	if (x1 < 0)
		x1 += b0;
	return x1;
}

/**
 * Finds the closest number in the array to the given number.
 * In case n is exactly in the middle of two prime numbers, take the smaller one.
 * @param values array to search through
 * @param n number as reference
 * @return closest number
 */
unsigned int findClosest(unsigned int n) {
    unsigned int i[2];

    i[0] = i[1] = n;
    while (!primes[i[0]] && !primes[i[1]]) {
        if (i[0] > 2)
            i[0]--;
        if (i[1] < MAX_NUMBERS)
            i[1]++;
    }

    if (primes[i[0]]) // Always try the smaller one first
	    return i[0];
    return i[1];
}