#                         ICS 51, Lab #3
#
#      IMPORTANT NOTES:
#
#      Write your assembly code only in the marked blocks.
#
#      DO NOT change anything outside the marked blocks.
#
###############################################################
#                           Text Section
.text

###############################################################
###############################################################
###############################################################
#                           PART 1 (fib_recur)
#a0: input number
###############################################################
fib_recur:
############################### Part 1: your code begins here ##
beqz $a0,zero
beq $a0,1,one

#Calling fib(n-1)
sub $sp,$sp,4
sw $ra,0($sp)

sub $a0,$a0,1
jal fib_recur
add $a0,$a0,1

lw $ra,0($sp)
add $sp,$sp,4


sub $sp,$sp,4
sw $v0,0($sp)

sub $sp,$sp,4
sw $ra,0($sp)

sub $a0,$a0,2
jal fib_recur
add $a0,$a0,2

lw $ra,0($sp)
add $sp,$sp,4

lw $t0,0($sp)
add $sp,$sp,4

add $v0,$v0,$t0
jr $ra

zero:
li $v0,0
jr $ra
one:
li $v0,1
jr $ra
############################### Part 1: your code ends here  ##
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 2 (gcd_recur)
#a0: input number
#a1: input number
###############################################################
gcd_recur:
############################### Part 2: your code begins here ##
addi $sp, $sp, -12
subu $sp,$sp,4
sw $a0,($sp)
subu $sp,$sp,4
sw $a1,($sp)
subu $sp,$sp,4
sw $ra,($sp)
move $v0,$a0
beqz $a1,end
div $v0,$a0,$a1
mfhi $v0
move $a0,$a1
move $a1,$v0
jal gcd_recur

end:
lw $ra,($sp)
addu $sp,$sp,4
lw $a1,($sp)
addu $sp,$sp,4
lw $a0,($sp)
addu $sp,$sp,4
addi $sp, $sp, 12
############################### Part 2: your code ends here  ##
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 3 (SYSCALL: file read, print)
#
# You will calculate the distance between two integers on a number line from .dat file
# Each pair of the integers is placed in a separate line.
# data_file_name : the string that represents the file name
# data_buffer : the buffer that you use to hold data (MAXIMUM: 300 bytes)
#
dist_file:
############################### Part 3: your code begins here ##
addi $sp, $sp, -12
sw $ra, 0($sp)
li $t9, 0
sw $t9, 8($sp)

li $v0, 13
la $a0, data_file_name
li $a1, 0
li $a2, 0
syscall
sw $v0, 4($sp)
bltz $v0, exception

li $v0, 14
lw $a0, 4($sp)
la $a1, data_buffer
li $a2, 300
syscall
bltz $v0, exception

read_line:
la $a0, data_buffer
lw $t5, 8($sp)
add $a0, $a0, $t5
lb $t0, 0($a0)
beqz $t0, dist_file_return
lw $ra, 0($sp)
jal convert

lw $t5, 8($sp)
add $t5, $t5, $v0
sw $t5, 8($sp)
j read_line
	
	
convert:
addi $sp, $sp, -16
sw $ra, 0($sp)
li $t0, 0
sw $t0, 4($sp)
li $t1, 1
sw $t1, 8($sp)
li $t2, 0
sw $t2, 12($sp)
li $t8, 0
	
	
first:
li $t9, 10
lb $t0, 0($a0)
beq $t0, 32, neg_check
beq $t0, 45, nega
lw $t1, 4($sp)
mul $t1, $t9, $t1
addi $t0, $t0, -48
add $t1, $t1, $t0
sw $t1, 4($sp)
addi $a0, $a0, 1
addi $t8, $t8, 1
j first

nega:
li $t1, -1
sw $t1, 8($sp)
addi $a0, $a0, 1
addi $t8, $t8, 1
j first

neg_check:
addi $a0, $a0, 1
addi $t8, $t8, 1
lw $t0, 8($sp)
beq $t0, 1, secondNum
lw $t1, 4($sp)
mul $t1, $t1, $t0
sw $t1, 4($sp)
li $t9, 1
sw $t9, 8($sp)
j secondNum

secondNum:
li $t9, 10
lb $t0, 0($a0)
beq $t0, 10, negative_check2
beq $t0, 45, negative2
addi $t0, $t0, -48
lw $t1, 12($sp)
mul $t1, $t1, $t9
add $t1, $t0, $t1

sw $t1, 12($sp)
addi $a0, $a0, 1
addi $t8, $t8, 1
j secondNum
	
negative2:
li $t1, -1
sw $t1, 8($sp)
addi $a0, $a0, 1
addi $t8, $t8, 1
j secondNum	
	
negative_check2:
addi $t8, $t8, 1
lw $t0, 8($sp)
beq $t0, 1, return
lw $t1, 12($sp)
mul $t1, $t1, $t0
sw $t1, 12($sp)
j return
	
return:
lw $v0, 4($sp)
lw $v1, 12($sp)
sub $a0, $v1, $v0
blez $a0, positive_convert
li $v0, 1
syscall
li $v0, 11
li $a0, '\n'
syscall
move $v0, $t8
addi $sp, $sp, 16
jr $ra

positive_convert:
li $t9, -1
mul $a0, $a0, $t9
li $v0, 1
syscall
li $v0, 11
li $a0, '\n'
syscall
move $v0, $t8
addi $sp, $sp, 16
jr $ra


dist_file_return:
li $v0, 16
lw $a0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 12
syscall
jr $ra


exception:
li $v0, 11
li $a0, 'n'
syscall
lw $ra, 0($sp)
addi $sp, $sp, 12
jr $ra
############################### Part 3: your code ends here   ##
jr $ra
