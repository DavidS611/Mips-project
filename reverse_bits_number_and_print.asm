.data 
    prompt: .asciiz "\nPlease enter an integer between 9999 to -9999:\n"
    err_msg: .asciiz "Invalid number! "
    msg: .asciiz "Binary representation:\n"
    rev_msg: .asciiz "\nReverse binary representation:\n"
    val_msg: .asciiz "\nThe value of the reverse bits is: \n"
    
.text
    .globl main

### Getting a number between -9999 - 9999
# print the lower 16 bits
# print the reverse form of the lower 16 bits
# print the value of the reversed lower 16 bits
####################################################
main:
    # Print prompt
    la $a0, prompt
    jal print_string
    
    # Read integer
    li $v0, 5         
    syscall
    move $s0, $v0 

    # Check if the number is between -9999 and 9999
    li $t0, 9999       
    bgt $s0, $t0, invalid_input
    li $t1, -9999       
    blt $s0, $t1, invalid_input
    # Making upper 16 bits zero's
    andi $s0, $s0, 0xFFFF		
    
    # Print the binary representation
    la $a0, msg
    jal print_string
    # Print lower 16 bits
    jal print_16
    
    # Ordering the bits in reverse
    jal reverse
    
    # Print reverse representation
    la $a0, rev_msg
    jal print_string
    jal print_16
    
    # Print the reverse value
    la $a0, val_msg
    jal print_string
    jal print_number
    
    # Exit
    li $v0, 10         # Load the system call number for program exit
    syscall 
    
    
## Printing the string loaded inside $a0
# jumping back to the instruction after calling this function
####################################################
print_string:
	li $v0, 4
	syscall
	jr $ra
	
## Printing the invalid massage and returning to main function
####################################################
invalid_input:
    la $a0, err_msg
    jal print_string
    j main
 
## Printing the lower 16 bits
# $t0 - Counter for the loop
# $t1 - Mask
# $t2 - Bit on indicator
# $s0 - The register where we saved the lower 16 bits to print
####################################################
print_16:  
	li $t0, 16 			
	li $t1, 1 			
	sll $t1, $t1, 15	# Mask for the first bit from left (of lower 16 bits)
	j loop
	
####################################################
loop:
	and $t2, $t1, $s0	# Check if the bit is on, and save the result inside $s0
	srl $t1, $t1, 1		# Shift the mask right by 1
	subi $t0, $t0, 1	# Counter decrement by 1
	bnez $t2, print_one # if $t2 != 0 print '1' else print '0'
	j print_zero
	
####################################################
continue_print:
	bnez $t0, loop	# if counter != 0 then print the next bit
	jr $ra

####################################################
print_one:
	li $a0, '1'
	li $v0, 11
    syscall
    j continue_print
    
####################################################
print_zero:
	li $a0, '0'
	li $v0, 11
    syscall
    j continue_print

## Reverse the lower 16 bits
# by coping them in reverse to the upper 16 bits and then shiftting by 16
# $t0 - Loop Counter
# $t1 - Mask
# $t2 - Bit on indicator
# $t3 - Variable for shiftting
# $s0 - The number that needs to reverse
####################################################
reverse:
	li $t0, 16			
	li $t1, 1			
	li $t3, 31
rev_loop:
	and $t2, $t1, $s0		# Checking if the bit is on in the lower 16 bits, and storing the result inside $t2
	sllv $t2, $t2, $t3		# Shiftting the bit mask to the correct reversed place in the upper 16 bits
	or $s0, $s0, $t2		# Storing the reverse bit inside the upper 16 bits of $s0 
	sll $t1, $t1, 1			# Shiftting mask left by 1
	subi $t0, $t0, 1		# Decrement counter by 1
	subi $t3, $t3, 2		# Decrement shift for reverse order by 2 (one for the lower bits and one for the upper bits)
	beqz $t0, continue_rev_loop
	j rev_loop
	
# Shiftting the reverse upper bits to become lower bits
####################################################
continue_rev_loop:
	srl $s0, $s0, 16
	jr $ra
	
## Print the value of the lower 16 bits
# If the 16 bit is on then print '-' before the number
# $t0 - Check if the sign bit is on
# $s0 - The number to print
####################################################
print_number:
	move $t0, $s0
	srl $t0, $t0, 15
	bnez $t0, print_minus
	
####################################################
continue_number_print:
	li $v0, 1
	move $a0, $s0
	syscall
	jr $ra

####################################################
print_minus:
	li $v0, 11
	li $a0, '-'
	syscall
	j continue_number_print
	
