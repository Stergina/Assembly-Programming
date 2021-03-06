#------------------------------------------------------------------------------------------------
# Author: Stergina
#------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------
# Data declaration section
#------------------------------------------------------------------------------------------------
    .data		

# Prompts user to enter two integer values and their GCD.
    a: .asciiz "Enter an integer: "
    b: .asciiz "Enter an integer: "
    s: .asciiz "What's the greatest common divisor of integers a and b? "
    blank: .asciiz "\n"
    wrong: .asciiz "Wrong answer! Try again!\n"
    right: .asciiz "Congratulations!"


#------------------------------------------------------------------------------------------------
# Code section - commands 
#------------------------------------------------------------------------------------------------
    .text
    .globl main		# program execution

main:
# Storing integer inputs
    la $a0, a        	    
    li $v0, 4              # system call 
    syscall                # to output message a

    li $v0, 5              # system call 
    syscall                # to input integer a into $v0
    add $a1, $v0, $zero    # store a in $a1

    la $a0, b              
    li $v0, 4              # system call 
    syscall                # to output message b

    li $v0, 5              # system call 
    syscall                # to input integer b into $v0
    add $a2, $v0, $zero    # store b in $a2

    la $a0, blank          # load appropriate system call code into register $v0;
    li $v0, 4              # load address of string to be printed into $a0
    syscall   

	
# Call gcd function
    addi $sp, $sp, -8      # allocate two words on the stack
    sw $a1, 4($sp)         # save integer a
    sw $a2, 0($sp)         # save integer b
    jal gcd                # jump to gcd function
    lw $a1, 4($sp)         # load integer a
    lw $a2, 0($sp)         # load integer b
    addi $sp, $sp, 4       # restore $sp to free allocated space
    add $s0, $v0, $zero    # store gcd in $v0
    sw $s0, 0($sp)         # save gcd


# Call compare function
    addi $sp, $sp, -8      # allocate two words on the stack
    sw $s0, 4($sp)         # save gcd
    sw $a3, 0($sp)         # save integer s
    jal loop               # jump to compare function
    lw $s0, 4($sp)         # load gcd
    lw $a3, 0($sp)         # load s
    add $s1, $v0, $zero    # store loop result in $v0
    sw $s1, 0($sp)         # save loop result


# Output   
    la $a0, blank          # load appropriate system call code into register $v0;
    li $v0, 4              # load address of string to be printed into $a0
    syscall   
       
    la $a0, s              
    li $v0, 4              # system call
    syscall                # to output message s

    li $v0, 5              # system call 
    syscall                # to input integer s into $v0
    add $a3, $v0, $zero    # store s in $a3
   
    li $v0, 10             # exit program
    syscall


# GCD function
gcd:
    addi $sp, $sp, -8      # allocate two words on the stack
    sw $ra, 4($sp)         # save the return address $ra to the upper one

    div $a1, $a2           # divide integer a by integer b
    mfhi $s0               # store the above result in $s0
    sw $s0, 0($sp)         # save $s0
    bne $s0, $zero, body   # repeat while $s0 != 0

    add $v0, $a2, $zero    # store integer b in $v0
    addi $sp, $sp, 8       # restore $sp to free allocated space
    jr $ra                 # return

body:
    add $a1, $a2, $zero    # a=b
    lw $s0, 0($sp)         # load into register $s0
    add $a2, $s0, $zero    # b=$s0
    jal gcd                # overwrite the return address $ra

    lw $ra, 4($sp)         # reload the previous return address
    addi $sp, $sp, 8       # restore $sp to free allocated space
    jr $ra                 # return


# Compare function
loop:
    addi $sp, $sp, -8      # allocate two words on the stack
    sw $ra, 4($sp)         # save the return address $ra to the upper one
    li $v0, 5              # load gcd
    add $a2, $s0, $zero    # $a2 = $s0; put gcd result in $a2 for output
    bne $a3, $a2, body2    # repeat while s!=gcd

    la $a0, blank          # load appropriate system call code into register $v0;
    li $v0, 4              # load address of string to be printed into $a0
    syscall   

    la $a0, right          # load appropriate system call code into register $v0;
    li $v0, 4 	           # load address of string to be printed into $a0
    syscall

    li $v1, 4              # load appropriate system call code into register $v1;
    la $a1, s	           # load address of string to be printed into $a1

    addi $sp, $sp, 8       # restore $sp to free allocated space
    jr $ra                 # return

body2:
    la $a0, blank          # load appropriate system call code into register $v0;
    li $v0, 4              # load address of string to be printed into $a0
    syscall   

    la $a0, wrong          # load appropriate system call code into register $v0;
    li $v0, 4   	   # load address of string to be printed into $a0
    syscall

    la $a0, blank          # load appropriate system call code into register $v0;
    li $v0, 4              # load address of string to be printed into $a0
    syscall   

    la $a0, s              
    li $v0, 4              # system call
    syscall                # to output message s

    li $v0, 5              # system call 
    syscall                # to input integer s into $v0
    add $a3, $v0, $zero    # store s in $a3

    jal loop               # overwrite the return address $ra

    lw $ra, 4($sp)         # reload the previous return address
    addi $sp, $sp, 8       # restore $sp to free allocated space
    jr $ra                 # return
