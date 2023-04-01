#                                           ICS 51, Lab #2
# 
#                                          IMPORTANT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
#
#

###############################################################
#                           Text Section
.text

###############################################################
###############################################################
###############################################################
#                            PART 1 (Fibonacci)
#
# 	The Fibonacci Sequence is the series of integer numbers:
#
#		0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...

#	The next number is found by adding up the two numbers before it.
	
#	The `2` is found by adding the two numbers before it (1+1)
#	The `3` is found by adding the two numbers before it (1+2),
#	And the `5` is (2+3),
#	and so on!
#
# You should compute N ($a0) number of elements of fibonacci and put
# in array, named fib_array.
# 
fibonacci:
# $a0: Number of elements. 
# fib_array: The destination array.
################## Part 1: your code begins here ###############
move $t0, $a0
li $t4, 0
la $s0, fib_array

beq $t0, $t4, final

li $t1, 0
sw $t1, 0($s0)

li $t4, 1
beq $t0, $t4, final
addi, $s0, $s0, 4

li $t1, 1
sw $t1, 0($s0)

li $t4, 2
beq $t0, $t4, final
addi, $s0, $s0, 4

while_loop:
subi $s0, $s0, 4
lw $t2, 0($s0)
subi $s0, $s0, 4
lw $t3, 0($s0)
addi, $s0, $s0, 8

add $t1, $t2, $t3
sw $t1, 0($s0)
addi, $s0, $s0, 4

subi $t0, $t0, 1

li $t4, 2
bgt $t0, $t4, while_loop
j final

final:

############################## Part 1: your code ends here   ###
jr $ra

###############################################################
###############################################################
###############################################################
#                  PART 2 (local minimum points)
# Write a function in MIPS assembly that takes an array of 
# integers and finds local minimum points. i.e., points that if 
# the input entry is smaller than both adjacent entries. The 
# output is an array of the same size of the input array. The 
# output point is 1 if the corresponding input entry is a 
# relative minimum, otherwise 0. (You should ignore the output
# array's boundary items, set to 0.) 
# 
# For example,
# 
# the input array of integers is {1, 3, 2, 4, 6, 5, 7, 8}. Then,
# the output array of integers should be {0, 0, 1, 0, 0, 1, 0, 0}
# 
# (Note: The first/last entry of the output array is always 0
#  since it's ignored, never be a local minimum.)
# $a0: The base address of the input array
# $a1: The base address of the output array with local minimum points
# $a2: Size of array
find_local_minima:
############################ Part 2: your code begins here ###
move $s0, $a0
move $s1, $a1
move $t0, $a2

li $t1, 0
beqz $t0, quit

sw $t1, 0($s1)
li $t2, 1
beq $t0, $t2, quit
addi $s0, $s0, 4
addi $s1, $s1, 4

loop:
addi $t2, $t2, 1
beq $t2, $t0, end

subi $s0, $s0, 4
lw $t3, 0($s0)
addi $s0, $s0, 4
lw $t4, 0($s0)
addi $s0, $s0, 4#pointer current on right side
lw $t5, 0($s0)
subi $s0, $s0, 4#get back the pointer

bge $t4, $t3, stop_check
bge $t4, $t5, stop_check
li $t1, 1
j next_loop

stop_check:
li $t1, 0

next_loop:
sw $t1, 0($s1)
addi $s0, $s0, 4
addi $s1, $s1, 4
j loop

end:
li $t1, 0
sw $t1, 0($s1)

quit:

############################ Part 2: your code ends here ###
jr $ra

###############################################################
###############################################################
###############################################################
#                       PART 3 (Change Case)
# Complete the change_case function that takes a Null-terminated
#  (Links to an external site.) string and converts the lowercase
#  characters (a-z) to uppercase and convert the uppercase ones
#  (A-Z) to lower case. Your function should also ignore 
# non-alphabetical characters. For example, "L!A##b@@3" should 
# be converted to "laB". In null-terminated strings, end of the
#  string is specified by a special null character (i.e., value 
# of 0).

#a0: The base address of the input array
#a1: The base address of the output array
###############################################################
change_case:
############################## Part 3: your code begins here ###
new_loop:
lb $t1, ($a0) 
beq $t1, '\0', end_loop 
blt $t1, 'A', next 
ble $t1, 'Z', upper 

bgt $t1, 'z', next
blt $t1, 'a', next

#it is lower case
lower:
sub $t1, $t1, 'a' 
add $t1, $t1, 'A' 
sb $t1, ($a1) 
add $a1, $a1, 1
j next


upper:
sub $t1, $t1, 'A' 
add $t1, $t1, 'a' 
sb $t1, ($a1) 
add $a1, $a1, 1

next:
add $a0, $a0, 1 
b new_loop

end_loop:
sb $t1, ($a1) 
############################## Part 3: your code ends here ###
jr $ra
