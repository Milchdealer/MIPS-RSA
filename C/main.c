
#include <stdio.h>

#include "RSA.h"

/**
 * Main routine containing the following functionality
 *	- Support the user in generating large prime numbers p and q
 *  - Asks the user for a public exponent e
 *  - Calculates and prints the private exponent d
 *  - Request the user to enter a message M
 *  - Encrypts the message into a ciphertext C and prints C
 *  - Decrypts the ciphertext and prints the decrypted message M'
 *  - Requests the user for the next message M until an empty message is entered.
 */
int main(int argc, char **argv) {
    if (argc > 1)
        printf("%d\n", GCD(atoi(argv[1]), atoi(argv[2])));
    else
	    printf("%d\n", GCD(100, 50));
	return 0;
}
