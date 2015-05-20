# 

# Start with data declarations
#

#BEGIN{{
	
.data

.align 2

.text
.globl __start			# leave this here for the moment

# Calculates phi and mod N.
# INPUT:
# - $a0 = unsigned int p:	first prime number
# - $a1 = unsigned int q: 	second prime number
# OUTPUT:
# - $v0 = unsigned int: 	mod N
# - $v1 = unsigned int: 	phi
totient:						## function Totient(p, q) {
	move $s0, $a0				## 	s0 = a0 = p;
	move $s1, $a1				## 	s1 = a1 = q;
	move $t0, $s0				## 	t0 = p;
	move $t1, $s1				## 	t1 = q;
	li $t2, 1					## 	t2 = 1;
	
	subu $t0, $t0, $t2			## 	t0 = p - 1;
	subu $t1, $t1, $t2			## 	t1 = q - 1;
	multu $t0, $t1				## 	(p - 1) * (q - 1);
	mfhi $t2					## 	t2 = hi;
	bne $t2, $zero, overflow	## 	if (t2 != 0)	goto overflow;
	mflo $v1					## 	v1 = phi = lo;
	multu $s0, $s1				##	p * q;
	mfhi $t2					## 	t2 = hi;
	bne $t2, $zero, overflow	##	if (t2 != 0)	goto overflow;
	mflo $v0					## 	v0 = modN = lo;
	
	jr $ra						## 	return; }
	
overflow:
	move $v0, $zero				## v0 = 0;
	move $v1, $zero				## v1 = 0;
	jr $ra						## return;
	
#END}}

__start:
main:
	
	li $v0, 5 
	syscall  		## scanf("%d", &a)
	move $a0, $v0	## p
	
	li $v0, 5
	syscall			## scanf("%d", &a)
	move $a1, $v0	## q

	jal totient		## totient

	move $a0, $v0	
	li $v0, 1		## printf("%d", modN)
	syscall 
	
	move $a0, $v1	
	li $v0, 1		## printf("%d", phi)
	syscall 

	li $v0, 10		# syscall code 10 for terminating the program
	syscall
