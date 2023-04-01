#                                           ICS 51, Lab #1
# 
#                                          IMPORTATNT NOTES:
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
#                            PART 1 (Swap Bits)
# 
# You are given an 32-bits integer stored in $a0. You need swap the bits
# at odd and even positions. i.e. b31 <-> b30, b29 <-> b28, ... , b1 <-> b0
# 
# Implementation details:
# The integer is stored in register $a0. You need to store the answer 
# into register $v0 in order to be returned by the function to the caller.
swap_bits:
############################## Part 1: your code begins here ###
move $t0, $a0

li $t3, 0xAAAAAAAA
li $t4, 0x55555555

and $t1, $t0, $t3
and $t2, $t0, $t4

srl $t1, $t1, 1
sll $t2, $t2, 1

or $t0, $t1, $t2
move $v0, $t0
############################## Part 1: your code ends here ###
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 2 (Double Range)
# 
# You are given three integers. You need to find the smallest 
# one and the largest one and multiply their sum by two and return it.
# 
# Implementation details:
# The three integers are stored in registers $a0, $a1, and $a2. You 
# need to store the answer into register $v0 in order to be returned by 
# the function to the caller.
double_range:
############################### Part 2: your code begins here ##
move $t0, $a0
move $t1, $a1
move $t2, $a2

bgt $t0, $t1, ElseCode
move $t3, $t1
move $t4, $t0
j Check_c

ElseCode:
move $t3, $t0
move $t4, $t1

Check_c:
bgt $t3, $t2, Check_smallest
move $t3, $t2

Check_smallest:
blt $t4, $t2, final_operation
move $t4, $t2

final_operation:
add $t5, $t3, $t4
sll $t5, $t5, 1
move $v0, $t5

############################### Part 2: your code ends here  ##
jr $ra

###############################################################
###############################################################
###############################################################
#                            PART 3 (Determinant)
# 
# You are given a 2x2 matrix, that each element is 16-bit. 
# Calculate its determinant.
# 
# Implementation details:
# The four 16-bit integers are stored in registers $a0, $a1. 
# You need to store the answer into register $v0 in order to 
# be returned by the function to the caller.
determinant:
############################## Part 3: your code begins here ###
move $t0, $a0
move $t1, $a1

li $t2, 0x0000ffff
li $t3, 0xffff0000

and $t4, $t0, $t2
and $t5, $t0, $t3
sra $t5, $t5, 16

and $t6, $t1, $t2
and $t7, $t1, $t3
sra $t7, $t7, 16

li $t2, 0x00008000
li $t9, 0xffff0000

move $t0, $t5
move $t1, $t4
move $t3, $t7
move $t8, $t6

and $t5, $t2, $t5
and $t4, $t2, $t4
and $t7, $t2, $t7
and $t6, $t2, $t6

beqz $t5, a_iszero
or $t0, $t0, $t9

a_iszero:
beqz $t4, b_iszero
or $t1, $t1, $t9

b_iszero:
beqz $t7, c_iszero
or $t3, $t3, $t9

c_iszero:
beqz $t6, d_iszero
or $t8, $t8, $t9

d_iszero:
mul $t2, $t0, $t8
mul $t9, $t1, $t3

sub $t0, $t2, $t9
move $v0, $t0
############################## Part 3: your code ends here ###
jr $ra

