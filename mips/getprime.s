# 

# Start with data declarations
#
.data

.align 2

.text
.globl __start			# leave this here for the moment

#BEGIN{{
# Calculates the exponent d representing the multiplicative inverse 
#  of e % phi).
# INPUT:
# - $a0 = unsigned int phi:	Totient phi
# - $a1 = unsigned int e:	Exponent e
# OUTPUT:
# - $v0 = unsigned int: 	d
getprime:
	move $s0, $a0				## b0 = phi
	li $t0, 0					## x0 = 0
	li $t1, 1					## x1 = 1
	li $t9, 1

	bne $a0, $t1, inverse_phi_1	## if(phi == 1)
	li $v0, 1					##    return 1
	jr $ra
	inverse_phi_1:

	inverse_loop:			## while(
		ble $a1, $t9, inverse_while_end	## e > 1) {

		divu $a1, $a0			## LO = e / phi
								## HI = e % phi

		mflo $t2				## q = LO (aka. e / phi)
		move $t3, $a0			## t = phi
		mfhi $a0				## phi = HI (aka. e % phi)
		move $a1, $t3			## e = t

		move $t3, $t0			## t = x0

		mul $t4, $t2, $t0		## u = q * x0
		sub $t0, $t1, $t4		## x0 = x1 - u

		move $t1, $t3			## x1 = t

		j inverse_loop
		inverse_while_end:	## }

	bge $t1, $zero, inverse_end ## if(x1 < 0) {
	add $t1, $t1, $s0			##     x1 += b0
	inverse_end:				## }

	move $v0, $t1
	jr $ra
#END}}

__start:
main:
	
	li $v0, 5 
	syscall  		## scanf("%d", &a)
	move $a0, $v0

	li $v0, 5 
	syscall  		## scanf("%d", &b)
	move $a1, $v0

	jal inverse		## res = gcd(a, b)

	move $a0, $v0	
	li $v0, 1		## printf("%d", res)
	syscall 

	li $v0, 10		# syscall code 10 for terminating the program
	syscall

