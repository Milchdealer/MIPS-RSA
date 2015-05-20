# 

# Start with data declarations
#
.data

input_number_array: .space 14100
newline: .asciiz "\n"

.align 2

.text
.globl __start	# leave this here for the moment

#BEGIN{{

#INCLUDE "powmod.s"

# Encrypts / Decrypts a message
# INPUT:
# - $a0 = const unsigned int* M:Decrypted message
# - $a1 = unsigned int e:		The exponent for encryption
# - $a2 = unsigned int modN:	The modulus
# - $a3 = size_t count: 		Length of message
# OUTPUT:
# - $v0 = size_t: Number of characters in the string
encrypt:
	#PUSH_REGISTERS

	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3

	sll $a0, $s3, 2 ## size_in_bytes = text_length * 4
	li $v0, 9 		## cipher = malloc(size_in_bytes)
	syscall			## // output in $v0
	move $s5, $v0	#: cipher

	li $s4, 0		## for (int i = 0; i < count; ++i) {
	encrypt_loop:
		beq $s4, $s3, encrypt_exit 	## 
		sll $t0, $s4, 2
		add $t0, $t0, $s0	##    unsigned* msg = M + i;
		lw $a0, 0($t0) 		##    unsigned b = *msg;

		move $a1, $s1
		move $a2, $s2
		jal powmod			##    unsigned mod (aka. $v0) = powmod(b, e, modN)

		sll $t0, $s4, 2
		add $t0, $t0, $s5	##    unsigned* decry = cipher + i;
		sw $v0, 0($t0)		##    *decry = mod

		addi $s4, $s4, 1	##	  ++i
		j encrypt_loop		## } 
	encrypt_exit:
		move $v0, $s5

	#POP_REGISTERS
	jr $ra
#END}}

__start:
main:

	li $v0, 5       
	syscall			## scanf("%d", &exponent)
	move $s4, $v0	#: exponent

	li $v0, 5       
	syscall			## scanf("%d", &modulusN)
	move $s5, $v0	#: modulusN
	
	la $s0, input_number_array 		## unsigned int* ptr = number_array
	li $s1, 0						## num_array_length
	encrypt_loop_test_in: 			## do {
		li $v0, 5 
		syscall  					##    scanf("%d", &read_num)
		sw $v0, 0($s0)				##    *ptr = read_num
		addi $s1, $s1, 1			##    num_array_length++
		addi $s0, $s0, 4			##    ptr += sizeof(unsigned int)
		bne $v0, $zero, encrypt_loop_test_in ## } while(read_num != 0)

	la $a0, input_number_array
	move $a1, $s4
	move $a2, $s5
	move $a3, $s1

	jal encrypt

	move $s2, $s1
	move $s1, $v0

	encrypt_loop_test_out:

		li $v0, 1		# an I/O sequence to print an integer to the console window
		lw $a0, 0($s1)
		syscall 

		addi $s2, $s2, -1
		addi $s1, $s1, 4

		la $a0, newline
		li $v0, 4
		syscall

		bgt $s2, $zero, encrypt_loop_test_out

	li $v0, 10		# syscall code 10 for terminating the program
	syscall

