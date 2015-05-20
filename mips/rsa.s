# 

# Start with data declarations
#
.data
input_string: .space 14100

#INCLUDE "strlen.s"
#INCLUDE "text2int.s"
#INCLUDE "getprime.s"

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



	li $v0, 10		# syscall code 10 for terminating the program
	syscall