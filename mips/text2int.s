# 

# Start with data declarations
#
.data
input_string: .space 14100

.align 2

.text
.globl __start			# leave this here for the moment

#BEGIN{{
# Converts an 8-bit string into a 32-bit number array (with 3 leading zeros).
# Allocates new memory (with malloc)
# INPUT:
# - $a0 = char* text: 	 Address of text to encode
# - $a1 = size_t size:	 Length of the string
# OUTPUT:
# - $v0 = unsigned int*: Address of encoded number array
text2int:
	move $t0, $a0 	## text_address_temp = text_address
	move $t1, $a1   ## text_length_temp = text_length

	sll $a0, $a1, 2 ## size_in_bytes = text_length * 4

	li $v0, 9 		## res = malloc(size_in_bytes)
	syscall			## // output in $v0

	move $t2, $v0	## c = res

	move $t4, $t1	## i = text_length_temp

	text2int_loop: 		  ## for i down to 0 {
		lb $t3, 0($t0)    ## num = *text_address_temp
		sb $t3, 0($t2)	  ## c[0] = num

		sb $zero, 1($t2)  ## c[1] = 1
		sb $zero, 2($t2)  ## c[2] = 2
		sb $zero, 3($t2)  ## c[3] = 0

		addi $t4, $t4,-1  ## i--
		addi $t2, $t2, 4  ## c += sizeof(unsigned int)
		addi $t0, $t0, 1

		bgt $t4, $zero, text2int_loop  ## }

	jr $ra ## return c
#END}}

#INCLUDE "strlen.s"

__start:
main:
	li $v0, 8
	la $a0, input_string 
	li $a1, 14100	# max 14100 characters
	syscall			## scanf("%s", input_string)

	# move $a0, $a0
	move $s1, $a0	# rescue $a0 aka. input_string
	jal strlen		## text_length = strlen(input_string)

	##{ remove \n at the end of the string
	add $s1, $s1, $v0
	sb $zero, -1($s1)
	sub $s1, $s1, $v0
	##}

	move $a0, $s1	# restore $a0 aka. input_string
	move $a1, $v0
	move $s2, $v0
	jal text2int	## numbers_text = text2int(input_string, text_length)

	move $s1, $v0	# rescue $v0 aka. numbers_text

	text2int_loop_test:

		li $v0, 1		# an I/O sequence to print an integer to the console window
		lw $a0, 0($s1)
		syscall 

		addi $s2, $s2, -1
		addi $s1, $s1, 4

		bgt $s2, $zero, text2int_loop_test

	li $v0, 10		# syscall code 10 for terminating the program
	syscall

