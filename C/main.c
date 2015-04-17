
#include "RSA.h"

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
	char text[6] = "Hello";

	val = text2int(text, 6);
	printf("%s\n", text);
	for (i = 0; i < 6; i++)
		printf("%d", val[i]);
	printf("\n");

	p = 11;
	q = 23;
	phi = totient(p, q);
	e = 13;
	d = inverse(phi, e);
	C = encrypt(val, 6, e, phi);
	for (i = 0; i < 6; i++)
		printf("%d", C[i]);
	printf("\n");

	M = decrypt(C, 6, d, phi);
	_decrypted = int2text(M, 6);
	for (i = 0; i < 6; i++) 
			printf("%d", M[i]);
	printf("\n");

	free(val);
	free(C);
	free(M);
	return 0;
}
