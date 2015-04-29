# 

# Start with data declarations
#
.data

.align 2

.text
.globl __start			# leave this here for the moment

#BEGIN{{
# Calculates (a^b)%c
# INPUT:
# - $a0 = unsigned int a:	First number
# - $a1 = unsigned int b:	Second number
# - $a2 = unsigned int mod:	Modulus
# OUTPUT:
# - $v0 = unsigned int: 	(a^b)%c
powmod:

	li $t0, 1		## unsigned int x = 1
	move $t1, $a0	## unsigned int y = a

	powmod_loop:					## while (
		ble $a1, $zero, powmod_while_end 	## b > 0 ) {
		
		andi $t2, $a1, 1					## t2 = b % 2
		beq $t2, $zero, powmod_b_mod_2		## if (t2) {
		mul $t0, $t0, $t1					##     x *= y
		divu $t0, $a2						## 	   HI = x % mod
		mfhi $t0							##     x = HI
		powmod_b_mod_2:						## }

		mul $t1, $t1, $t1					## y *= y
		divu $t1, $a2						## HI = y % mod
		mfhi $t1							## y = HI

		srl $a1, $a1, 1						## b /= 2

		j powmod_loop
		powmod_while_end:			## }

	move $v0, $t0
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

	li $v0, 5 
	syscall  		## scanf("%d", &mod)
	move $a2, $v0

	jal powmod 		## res = gcd(a, b, mod)

	move $a0, $v0
	li $v0, 1
	syscall 		## printf("%d", res)

	li $v0, 10		# syscall code 10 for terminating the program
	syscall

