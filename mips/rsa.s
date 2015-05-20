# 

# Start with data declarations
#
.data
input_string: .space 14100

str_message: .asciiz "Message: "
str_message_numbers: .asciiz "\nAs numbers: "
str_p_eq: .asciiz "\np="
str_q_eq: .asciiz "\nq="
str_phi_eq: .asciiz "\nphi="
str_modN_eq: .asciiz "\nmodN="
str_e_eq: .asciiz "\ne="
str_d_eq: .asciiz "\nd="
str_len_eq: .asciiz "\nlen="
str_encrypted: .asciiz "\nEncrypted as numbers: "
str_decrypted: .asciiz "\nDecrypted as numbers: "
str_space: .asciiz " "
str_decoded: .asciiz "\nDecrypted message: "


.align 2

.text
.globl __start

#INCLUDE "strlen.s"
#INCLUDE "text2int.s"
#INCLUDE "int2text.s"
#INCLUDE "getprime.s"
#INCLUDE "totient.s"
#INCLUDE "publicExp.s"
#INCLUDE "gcd.s"
#INCLUDE "inverse.s"
#INCLUDE "powmod.s"
#INCLUDE "encrypt.s"

__start:
main:
	
	li $v0, 5       
	syscall			## scanf("%d", &prime1)
	move $s0, $v0	#: prime1

	li $v0, 5       
	syscall			## scanf("%d", &prime2)
	move $s1, $v0	#: prime2

	li $v0, 8
	la $a0, input_string 
	li $a1, 14100	# max 14100 characters
	syscall			## scanf("%s", input_string)

	# move $a0, $a0
	move $s2, $a0	# rescue $a0 aka. input_string
	jal strlen		## text_length = strlen(input_string)
	move $s4, $v0

	##{ remove \n at the end of the string
	add $t0, $s2, $v0
	sb $zero, -1($t0)
	##}

	move $a0, $s2	# restore $a0 aka. input_string
	move $a1, $v0
	jal text2int	## numbers_text = text2int(input_string, text_length)

	move $s3, $v0	#: numbers_text

	la $a0, str_message
	li $v0, 4
	syscall  		## printf("Message: ")
	move $a0, $s2
	li $v0, 4
	syscall  		## printf("%s", text)

	la $a0, str_message_numbers
	li $v0, 4
	syscall  		## printf("Message as numbers: ")

	move $t0, $s3	#: numbers_text
	move $t1, $s4	#: text_length
	rsa_loop_output_message:
		li $v0, 1		# an I/O sequence to print an integer to the console window
		lw $a0, 0($t0)
		syscall 

		la $a0, str_space
		li $v0, 4
		syscall  		## printf(" ")

		addi $t1, $t1, -1
		addi $t0, $t0, 4

		bgt $t1, $zero, rsa_loop_output_message


	move $a0, $s0
	jal getprime	## getprime(prime1)
	move $s0, $v0

	move $a0, $s1
	jal getprime	## getprime(prime2)
	move $s1, $v0

	move $a0, $s0
	move $a1, $s1
	jal totient		## totient(prime1, prime2)

	move $t7, $s4
	move $s4, $v0 	#: modN
	move $s5, $v1	#: phi

	move $a0, $s5
	jal publicExp	## e = publicExp(phi)
	move $s6, $v0	## 

	move $a0, $s5
	move $a1, $s6
	jal inverse		## d = inverse(phi, e)
	move $s7, $v0


	la $a0, str_p_eq
	li $v0, 4
	syscall  		## printf("p=")
	move $a0, $s0
	li $v0, 1		## printf("%d", prime1)
	syscall 

	la $a0, str_q_eq
	li $v0, 4
	syscall  		## printf("q=")
	move $a0, $s1
	li $v0, 1		## printf("%d", prime2)
	syscall 

	move $s0, $t7

	la $a0, str_phi_eq
	li $v0, 4
	syscall  		## printf("phi=")
	move $a0, $s5
	li $v0, 1		## printf("%d", phi)
	syscall 

	la $a0, str_modN_eq
	li $v0, 4
	syscall  		## printf("modN=")
	move $a0, $s4
	li $v0, 1		## printf("%d", modN)
	syscall 

	la $a0, str_e_eq
	li $v0, 4
	syscall  		## printf("e=")
	move $a0, $s6
	li $v0, 1		## printf("%d", e)
	syscall 

	la $a0, str_d_eq
	li $v0, 4
	syscall  		## printf("d=")
	move $a0, $s7
	li $v0, 1		## printf("%d", d)
	syscall 


	la $a0, str_len_eq
	li $v0, 4
	syscall  		## printf("len=")
	move $a0, $s0	## text_length
	li $v0, 1		## printf("%d", text_length)
	syscall 


	la $a0, str_encrypted
	li $v0, 4
	syscall  		## printf("Encrypted as numbers:")


# - $a0 = const unsigned int* M:Decrypted message
# - $a1 = unsigned int e:		The exponent for encryption
# - $a2 = unsigned int modN:	The modulus
# - $a3 = size_t count: 		Length of message
	move $a0, $s3	#: numbers_text
	move $a1, $s6	#: e
	move $a2, $s4	#: modN
	move $a3, $s0	#: text_length
	jal encrypt		## encrypted = encrypt(numbers_text, e, modN, text_length)
	move $s1, $v0	#: encrypted

	move $t0, $s1	#: encrypted
	move $t1, $s0	#: text_length
	rsa_loop_output_encrypted:
		li $v0, 1		# an I/O sequence to print an integer to the console window
		lw $a0, 0($t0)
		syscall 

		la $a0, str_space
		li $v0, 4
		syscall  		## printf(" ")

		addi $t1, $t1, -1
		addi $t0, $t0, 4

		bgt $t1, $zero, rsa_loop_output_encrypted


	move $a0, $s1	#: encrypted
	move $a1, $s7	#: e
	move $a2, $s4	#: modN
	move $a3, $s0	#: text_length
	jal encrypt		## decrypted = encrypt(encrypted, d, modN, text_length)
	move $s1, $v0	#: decrypted


	la $a0, str_decrypted
	li $v0, 4
	syscall  		## printf("Decrypted as numbers:")

	move $t0, $s1	#: decrypted
	move $t1, $s0	#: text_length
	rsa_loop_output_decrypted:
		li $v0, 1		# an I/O sequence to print an integer to the console window
		lw $a0, 0($t0)
		syscall 

		la $a0, str_space
		li $v0, 4
		syscall  		## printf(" ")

		addi $t1, $t1, -1
		addi $t0, $t0, 4

		bgt $t1, $zero, rsa_loop_output_decrypted

# - $a0 = unsigned int* number_array: 	Address of number array to decode
# - $a1 = size_t size:	 				Length of the number array (number of entries, not size in bytes)


	la $a0, str_decoded
	li $v0, 4
	syscall  		## printf("Decrypted message: ")

	move $a0, $s1
	move $a1, $s0
	jal int2text

	move $a0, $v0
	li $v0, 4
	syscall  		## printf(decoded_text)


	li $v0, 10		# syscall code 10 for terminating the program
	syscall