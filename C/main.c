
#include "RSA.h"

#include <string.h> // memset

unsigned int *text2int(char const * const text, size_t size) {
	unsigned int i;
	unsigned int *res;

	res = (unsigned int *) malloc(sizeof(unsigned int) * size);
	for (i = 0; i < size; i++)
		res[i] = (unsigned int)text[i];

	return res;
}
char *int2text(unsigned int const * const vals, size_t size) {
	unsigned int i;
	char *res;

	res = (char *) malloc(sizeof(char) * size * sizeof(unsigned int));
	for (i = 0; i < size; i++)
		res[i] = (char) vals[i]; // memory loss

	return res;
}

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
	unsigned int i;
	Totient phi;
	unsigned int *M, *C;
	unsigned int d, e, p, q;
	unsigned int *val;
	char *_decrypted;
	char text[6] = "hello";

	val = text2int(text, 6);
	printf("Message: %s\nAs numbers: ", text);
	for (i = 0; i < 6; i++)
		printf("%d", val[i]);

	p = getprime(50);
	q = getprime(60);
	phi = totient(p, q);
    e = publicExp(phi);
	d = inverse(phi, e);
    printf("\np=%d\nq=%d\nphi=%d\nmodN=%d\ne=%d\nd=%d\nEncrypted as numbers: ", p, q, phi.phi, phi.modN, e, d);

	C = encrypt(val, 6, e, phi);
	for (i = 0; i < 6; i++)
		printf("%d", C[i]);
	printf("\nDecrypted as numbers: ");
	M = decrypt(C, 6, d, phi);
	_decrypted = int2text(M, 6);
	for (i = 0; i < 6; i++) 
			printf("%d", M[i]);
	printf("\nDecrypted message: %s\nPress enter to exit...", _decrypted);

	free(val);
	free(C);
	free(M);
    fgetc(stdin);
	return 0;
}
