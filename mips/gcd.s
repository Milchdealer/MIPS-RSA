# 

# Start with data declarations
#
.data

.align 2

.text
.globl __start			# leave this here for the moment

#BEGIN{{
# Calculates the greatest common divisor of two numbers
# INPUT:
# - $a0 = unsigned int a:	First number
# - $a1 = unsigned int b:	Second number
# OUTPUT:
# - $v0 = unsigned int: 	The greatest common divisor of a and b.
gcd:
	#PUSH_REGISTERS

	bne $a0, $zero, gcd_loop		## if (a == 0) 
	move $v0, $a1					##     return b
	jr $ra
	gcd_loop:						## while (
		beq $a1, $zero, gcd_while_end ## b != 0) {

		ble $a0, $a1, gcd_a_leq_b 	## if (a > b)
		sub $a0, $a0, $a1			##    a -= b
		j gcd_loop
		gcd_a_leq_b:				## else
		sub $a1, $a1, $a0			##    b -= a
		j gcd_loop

	gcd_while_end:				## }

	move $v0, $a0

	#POP_REGISTERS

	jr $ra 							## return a
#END}}

__start:
main:
	
	li $v0, 5 
	syscall  		## scanf("%d", &a)
	move $a0, $v0

	li $v0, 5 
	syscall  		## scanf("%d", &b)
	move $a1, $v0

	jal gcd 		## res = gcd(a, b)

	move $a0, $v0	
	li $v0, 1		## printf("%d", res)
	syscall 

	li $v0, 10		# syscall code 10 for terminating the program
	syscall

