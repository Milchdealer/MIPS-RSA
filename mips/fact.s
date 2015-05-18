# First SPIM Assignment

# Start with data declarations
#
.align 2

.globl __start			# leave this here for the moment
.text			

fact: # $a0 as input, calc $a0!
	li $t1, 1
	li $v0, 1
	loop:
		mul $v0, $v0, $t1
		addi $t1, $t1, 1

		ble $t1, $a0, loop

	jr $ra

__start:
main:
	li $v0, 5       # an I/O sequence to read an integer from 
					# the console window
	syscall 
	move $t0, $v0	# place the value read into register $t0

	move $a0, $t0
	jal fact

	move $t0, $v0

	li $v0, 1		# an I/O sequence to print an integer to the console window
	move $a0, $t0	
	syscall 

	li $v0, 10		# syscall code 10 for terminating the program
	syscall

