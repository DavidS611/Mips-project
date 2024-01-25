.data 
    prompt: .asciiz "\nPlease enter three characters between '0' to '9':"
    err_msg: .asciiz "\nInvalid input! "
    guess_msg: .asciiz "\nGuess my number:\t"
    err_guess_msg: .asciiz "\nInvalid guess, try againe."
    new_Line:	.byte '\n'
    another_game: .asciiz "\nAnother game?(y/n)\t"
    
    bool: .space 3
    guess: .space 4 # last char for null 
    
.text
    .globl main

###################################################
main:
    # Print prompt
    la $a0, prompt
    jal print_string
    jal new_line
    
    # Read number input
    la $s0, bool
    jal get_number
	
	# Read guess input
	la $s1, guess
	jal get_guess
	
    # Exit
    li $v0, 10     
    syscall 
    
####################################################
one_more_game:
	# Another game?
	la $a0, another_game
	jal keep_play

####################################################
keep_play:
	# push $ra to stack and pop it after printing a string message
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal print_string
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	# Read char
	li $v0, 12
	syscall
	beq $v0, 'y', main
	beq $v0, 'n', exit
	j keep_play			# Keep ask if get another answer but y or n
    
# Print a string
# $a0 - The string
####################################################
print_string:
	li $v0, 4
	syscall
	jr $ra

# Print new line
####################################################
new_line:
	lb $a0, new_Line
	li $v0, 11
	syscall
	jr $ra

# Get the number need to be guessed from the user
# $s0 - array store the number
####################################################
get_number:
	# Read first character into bool
    li $v0, 12         
    syscall
    sb $v0, 0($s0)
    # Read the second character
    li $v0, 12
    syscall
    sb $v0, 1($s0)
    # Read the third character
    li $v0, 12
    syscall
	sb $v0, 2($s0)
	
	# Looking for errors in input
	# push $ra to stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $a0, err_msg
	li $a1, 1		# Flag for incorrect number at get_number
	la $a2, bool
	jal input_validation
	
	# restore $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4

    jr $ra
	
# Get the guesses from the user as a string
# $s1 - guess array
####################################################
get_guess:
	# push $ra to stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# Print massage for the user
	la $a0, guess_msg
    jal print_string
	
	la $a0, guess		# Adress of input buffer
	li $a1, 4			# Max numbers of chars to read + null
	# Read string
	li $v0, 8
	syscall
	# Looking for errors in input
	la $a0, err_guess_msg
	li $a1, 2		# Flag for incorrect number at get_guess
	la $a2, guess
	jal input_validation
	# Compare function (bool, guess)
	la $a0, bool
	la $a1, guess
	jal compare
	# restore $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	# Loop if there is less than 3 bools
	bne $s5, 3, get_guess		# check the indicator for 3 b's
	li $v0, -1		# if there is 3 bools return $v0 = -1
    j one_more_game
  
####################################################
compare:
	li $t9, 0			# Flag
	li $t6, 0			# Bol counter
	li $t7, 0			# Pgia counter
	# push $ra to stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# getting ready for comparation
	lb $t0, 0($a0)		# First bool char
	lb $t1, 1($a0)		# Second bool char
	lb $t2, 2($a0)		# Third bool char
	lb $t3, 0($a1)		# First guess char
	lb $t4, 1($a1)		# Second guess char
	lb $t5, 2($a1)		# Third guess char
	# Checking if there is any bool
	seq $t9, $t0, $t3	# if($t0==$t3) $t9=1
	add $t6, $t6, $t9	# $t6 += $t9
	seq $t9, $t1, $t4	# if($t1==$t4) $t9=1
	add $t6, $t6, $t9	# $t6 += $t9
	seq $t9, $t2, $t5	# if($t2==$t5) $t9=1
	add $t6, $t6, $t9	# $t6 += $t9
	# Checking if there is any pgia
	li $t9, 0			# Initializing $t9
	seq $t9, $t0, $t4	# if($t0==$t4) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t0, $t5	# if($t0==$t5) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t1, $t3	# if($t1==$t3) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t1, $t5	# if($t1==$t5) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t2, $t3	# if($t2==$t3) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t2, $t4	# if($t2==$t4) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	# Save number of bools and pgias
	la $s3, 0($t6)
	la $s4, 0($t7)
	la $s5, 0($t6)		# indicator for 3 b's
	# print guess results ($s3, $s4)
	la $a0, 0($s3)
	la $a1, 0($s4)
	jal print_guess_results
	# restore $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	li $t9, 0			# Flag
	li $t6, 0			# Bol counter
	li $t7, 0			# Pgia counter
	# push $ra to stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# getting ready for comparation
	lb $t0, 0($a0)		# First bool char
	lb $t1, 1($a0)		# Second bool char
	lb $t2, 2($a0)		# Third bool char
	lb $t3, 0($a1)		# First guess char
	lb $t4, 1($a1)		# Second guess char
	lb $t5, 2($a1)		# Third guess char
	# Checking if there is any bool
	seq $t9, $t0, $t3	# if($t0==$t3) $t9=1
	add $t6, $t6, $t9	# $t6 += $t9
	seq $t9, $t1, $t4	# if($t1==$t4) $t9=1
	add $t6, $t6, $t9	# $t6 += $t9
	seq $t9, $t2, $t5	# if($t2==$t5) $t9=1
	add $t6, $t6, $t9	# $t6 += $t9
	# Checking if there is any pgia
	li $t9, 0			# Initializing $t9
	seq $t9, $t0, $t4	# if($t0==$t4) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t0, $t5	# if($t0==$t5) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t1, $t3	# if($t1==$t3) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t1, $t5	# if($t1==$t5) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t2, $t3	# if($t2==$t3) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t2, $t4	# if($t2==$t4) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	# Save number of bools and pgias
	la $s3, 0($t6)
	la $s4, 0($t7)
	la $s5, 0($t6)		# indicator for 3 b's
	# print guess results ($s3, $s4)
	la $a0, 0($s3)
	la $a1, 0($s4)
	jal print_guess_results
	# restore $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	# First guess char
	lb $t4, 1($a1)		# Second guess char
	lb $t5, 2($a1)		# Third guess char
	# Checking if there is any bool
	seq $t9, $t0, $t3	# if($t0==$t3) $t9=1
	add $t6, $t6, $t9	# $t6 += $t9
	seq $t9, $t1, $t4	# if($t1==$t4) $t9=1
	add $t6, $t6, $t9	# $t6 += $t9
	seq $t9, $t2, $t5	# if($t2==$t5) $t9=1
	add $t6, $t6, $t9	# $t6 += $t9
	# Checking if there is any pgia
	li $t9, 0			# Initializing $t9
	seq $t9, $t0, $t4	# if($t0==$t4) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t0, $t5	# if($t0==$t5) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t1, $t3	# if($t1==$t3) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t1, $t5	# if($t1==$t5) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t2, $t3	# if($t2==$t3) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	seq $t9, $t2, $t4	# if($t2==$t4) $t9=1
	add $t7, $t7, $t9	# $t7 += $t9
	# Save number of bools and pgias
	la $s3, 0($t6)
	la $s4, 0($t7)
	la $s5, 0($t6)		# indicator for 3 b's
	# print guess results ($s3, $s4)
	la $a0, 0($s3)
	la $a1, 0($s4)
	jal print_guess_results
	# restore $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
# Print number of guesses ($s5, $s4)
# $s3 - number of bools
# $s4 - number of pgias
####################################################
print_guess_results:
	add $t0, $a0, $a1			# $t0 number of bools and pgias, if there is no bools and pgias it will print 'n'
	la $a0, '\t'
	li $v0, 11
	syscall
	bnez $t0, print_b_result
	la $a0, 'n'
	li $v0, 11
	syscall
	jr $ra
	# for every bool print 'b'
	# $s5 - number of bools
	print_b_result:
		beqz $s3, print_p_result
		la $a0, 'b'
		li $v0, 11
		syscall
		addi $s3, $s3, -1
		j print_b_result
	# for every pgia print 'p'
	# $s4 - number of pgias
	print_p_result:
		beqz $s4, exit
		la $a0, 'p'
		li $v0, 11
		syscall
		addi $s4, $s4, -1
		j print_p_result

# Check for invalid input
####################################################
input_validation:
	lb $t0, 0($a2)		# First char
	lb $t1, 1($a2)		# Second char
	lb $t2, 2($a2)		# Third char	
	li $t8, '0'
	li $t9, '9'
	# numbers out of range
	blt $t0, $t8, invalid_input
	bgt $t0, $t9, invalid_input
	blt $t1, $t8, invalid_input
	bgt $t1, $t9, invalid_input
	blt $t2, $t8, invalid_input
	bgt $t2, $t9, invalid_input
	# numbers equal to each other
	beq $t0, $t1, invalid_input
	beq $t0, $t2, invalid_input
	beq $t2, $t1, invalid_input
	jr $ra

# Printing the invalid massage and returning to prior loop
# $a0 - error massage to print
####################################################
invalid_input:
 	#push $ra to stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
    jal print_string
    #pop $ra from stack
    lw $ra, 0($sp)
    addi $sp, $sp, 4
	beq $a1, 1, main
	beq $a1, 2, get_guess
 	
# return function
####################################################
exit:
	jr $ra
