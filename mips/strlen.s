# 

# Start with data declarations
#
.data
input_string: .space 14100

.align 2

.text
.globl __start	# leave this here for the moment

#BEGIN{{
# Calculates the length of a string
# INPUT:
# - $a0 = const char*: Null terminated string
# OUTPUT:
# - $v0 = size_t: Number of characters in the string
strlen:
	li $v0, 0 # initialize the count to zero
	strlen_loop:
		lb $t1, 0($a0) # load the next character into t1
		beqz $t1, exit # check for the null character
		addi $a0, $a0, 1 # increment the string pointer
		addi $v0, $v0, 1 # increment the count
		j strlen_loop # return to the top of the loop
	exit:
		jr $ra
#END}}

__start:
main:
	li $v0, 8  	## scanf("%s", input_string)
	la $a0, input_string
	li $a1, 14100
	syscall

	# move $a0, $a0
	jal strlen

	move $t0, $v0

	li $v0, 1		# an I/O sequence to print an integer to the console window
	move $a0, $t0
	syscall 

	li $v0, 10		# syscall code 10 for terminating the program
	syscall

