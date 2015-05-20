# 

# Start with data declarations
#
.data

.align 2

.text
.globl __start	# leave this here for the moment

#BEGIN{{

#INCLUDE "getprime.s"
#INCLUDE "gcd.s"

# Calculates the public exponent
# INPUT:
# - $a0 = unsigned int phi: Totient to base the public exponent on
# OUTPUT:
# - $v0 = size_t: The public exponent
publicExp:
	#PUSH_REGISTERS
	li $s0, 1 		## unsigned int i = 2
	move $s1, $a0	## phi = phi

	publicExp_loop: ## for (i = 2; i < phi; ++i) {
		addi $s0, $s0, 1

		bge $s0, $s1, publicExp_exit

		move $a0, $s0
		move $a1, $s1

		jal gcd			## v = gcd(i, phi)

		li $t0, 1		## if (v != 1) continue;
		bne $v0, $t0, publicExp_loop

		la $t0, primes
		add $t0, $t0, $s0
		lb $t1, 0($t0)	## p = primes[i]

		beq $t1, $zero, publicExp_loop ## if (p == 0) continue;

	publicExp_exit:

	move $v0, $s0

	#POP_REGISTERS
	jr $ra
#END}}

__start:
main:
	jal getprime

	li $v0, 5 
	syscall  		## scanf("%d", &read_num)

	move $a0, $v0

	jal publicExp

	move $t0, $v0

	li $v0, 1		# an I/O sequence to print an integer to the console window
	move $a0, $t0
	syscall 

	li $v0, 10		# syscall code 10 for terminating the program
	syscall

