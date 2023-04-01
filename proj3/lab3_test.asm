.include "lab3.asm"

.data

new_line: .asciiz "\n"
space: .asciiz " "
i_str: .asciiz "Program input: " 
po_str: .asciiz "Obtained output: " 
eo_str: .asciiz "Expected output: "
t2_str: .asciiz "Testing fib_recur: \n"
t3_str: .asciiz "Testing gcd_recur: \n"
dist_str: .asciiz "Testing dist_file: \n" 

num_numeric_tests:          .word 8

numerical_inputs:           .word       0, 1, 2, 3, 6, 9 , 10, 13
fib_recur_expected_outputs: .word 0, 1, 1, 2, 8, 34, 55, 233

gcd_inputs:                 .word 1, 12, 4, 79322, 1378, 75, 28300, 74000
gcd_expected_outputs:       .word     1, 4,     2,     2, 1,     25,  100 

dist_file_lbl: .asciiz "\n1\n1\n7\n23\n"

data_file_name:
	.asciiz	"lab3_data.dat"	# File name
	.word	0

data_buffer:
	.space	300			# Place to store character


###############################################################
#                           Text Section
.text
.globl data_file_name
.globl data_buffer
.globl main

# Utility function to print integer arrays
#a0: array
#a1: length
print_array:

li $t1, 0
move $t2, $a0
print:

lw $a0, ($t2)
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra

###############################################################
###############################################################
###############################################################

#                          Main Function
main:

###############################################################
# Test fib_recur function
li $v0, 4
la $a0, t2_str
syscall

la $a0, i_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, numerical_inputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, eo_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, fib_recur_expected_outputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, po_str
syscall

la $s2, numerical_inputs
test_fib_recur:
bge $s0, $s1, end_test_fib_recur
# call the function
lw $a0, 0($s2)
jal fib_recur
# print results
move $a0, $v0
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4
j test_fib_recur


end_test_fib_recur:
la $a0, new_line
syscall
syscall
###############################################################
# Test gcd_recur function
li $v0, 4
la $a0, t3_str
syscall

la $a0, i_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
la $s2, gcd_inputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, eo_str
syscall
li $s0, 0 # used to index current test input
la $s1, num_numeric_tests
lw $s1, 0($s1)  # number of tests
addi $s1, $s1, -1 # tests are in pairs
la $s2, gcd_expected_outputs
move $a0, $s2
move $a1, $s1
jal print_array
la $a0, new_line
syscall


la $a0, po_str
syscall

la $s2, gcd_inputs

test_gcd:
bge $s0, $s1, end_test_gcd
# call the function
lw $a0, 0($s2)
lw $a1, 4($s2)
jal gcd_recur
# print results
move $a0, $v0
li $v0, 1   
syscall

li $v0, 4
la $a0, space
syscall

addi $s0, $s0, 1
addi $s2, $s2, 4
j test_gcd


end_test_gcd:
la $a0, new_line
syscall

###############################################################
# Test dist_file function
li $v0, 4
la $a0, new_line
syscall
la $a0, dist_str
syscall

la $a0, eo_str
syscall
la $a0, dist_file_lbl
syscall

la $a0, po_str
syscall
la $a0, new_line
syscall
jal dist_file

_end:
# end program
li $v0, 10
syscall
