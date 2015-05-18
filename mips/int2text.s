# 

# Start with data declarations
#
.data
input_number_array: .space 14100

.align 2

.text
.globl __start			# leave this here for the moment

#BEGIN{{
# Converts an 32-bit number array (with 3 leading zeros) into a 8-bit string.
# Allocates new memory (with malloc)
# INPUT:
# - $a0 = unsigned int* number_array: 	Address of number array to decode
# - $a1 = size_t size:	 				Length of the number array (number of entries, not size in bytes)
# OUTPUT:
# - $v0 = char*: Address of decoded text
int2text:
	move $t0, $a0 	## arr_address_temp = arr_address
	move $t1, $a1   ## arr_length_temp = arr_length

	move $a0, $a1   ## size_in_bytes = arr_length

	li $v0, 9 		## res = malloc(size_in_bytes)
	syscall			## // output in $v0

	move $t2, $v0	## c = res

	move $t4, $t1	## i = text_length_temp

	int2text_loop: 		  ## for i down to 0 {
		lb $t3, 0($t0)    ## num = *arr_address_temp
		sb $t3, 0($t2)	  ## c[0] = num

		addi $t4, $t4,-1  ## i--
		addi $t2, $t2, 1  ## c += sizeof(char)
		addi $t0, $t0, 4  ## arr_address_temp += sizeof(unsignet int)

		bgt $t4, $zero, int2text_loop  ## }

	jr $ra ## return res (aka. $v0)
#END}}

__start:
main:
	
	la $s0, input_number_array 		## unsigned int* ptr = number_array
	li $s1, 0						## num_array_length
	int2text_loop_test: 			## do {
		li $v0, 5 
		syscall  					## scanf("%d", &read_num)
		sw $v0, 0($s0)				## *ptr = read_num
		addi $s1, $s1, 1			## num_array_length++
		addi $s0, $s0, 4			### ptr += sizeof(unsigned int)
		bne $v0, $zero, int2text_loop_test ## } while(read_num != 0)

	la $a0, input_number_array
	move $a1, $s1
	jal int2text	## char* text = int2text(input_number_array, num_array_length)

	move $a0, $v0
	li $v0, 4
	syscall  		## printf("%s", text)


	li $v0, 10		# syscall code 10 for terminating the program
	syscall

