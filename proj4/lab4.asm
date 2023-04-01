#                         ICS 51, Lab #4
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
#                       PART 1 (Image Thresholding)
#a0: input buffer address
#a1: output buffer address
#a2: image dimension (Image will be square sized, i.e., number of pixels = a2*a2)
#a3: threshold value 
###############################################################
threshold:
############################## Part 1: your code begins here ###
move $t0, $a0
move $t1, $a1
mul $t2, $a2, $a2
move $t3, $a3

beqz $t2, end

while_loop:
lbu $t5, 0($t0)
addi $t0, $t0, 1

bgeu $t5, $t3, greater
li $t5, 0x00
j next

greater:
li $t5, 0xFF

next:
sb $t5, 0($t1)
subi $t2, $t2, 1
addi $t1, $t1, 1
beqz $t2, end
j while_loop

end:
############################## Part 1: your code ends here ###
jr $ra

###############################################################
###############################################################
#                           PART 2 (Matrix Transform)
#a0: input buffer address
#a1: output buffer address
#a2: transform matrix address
#a3: image dimension  (Image will be square sized, i.e., number of pixels = a3*a3)
###############################################################
transform:
############################### Part 2: your code begins here ##
move $t5, $a0 #t5 is the input pointer
move $t6, $a1 #t6 is the output pointer
move $t0, $a3 #t0 stores image dimension
move $t1, $a2 #t1 is the matrix pointer

li $t2, 0 #t2 represents x
li $t3, 0 #t3 represents y

beqz $t0, end_myloop #end if the image dimension is 0

outer_loop:
blt $t3, $t0, inner_loop #end if y coordinate equals maximum size
j end_myloop

inner_loop:
blt $t2, $t0, continue #end if x coordinate equals maximum size, go to outer loop and add 1 to y
addi $t3, $t3, 1
move $t2, $0
j outer_loop

continue:
lw $t7, 0($t1)
mul $t7, $t7, $t2
lw $t8, 4($t1)
mul $t8, $t8, $t3
add $t8, $t8, $t7
lw $t7, 8($t1)
add $t8, $t8, $t7 #$t8 is the calculated x index

lw $t7, 12($t1)
mul $t7, $t7, $t2
lw $t9, 16($t1)
mul $t9, $t9, $t3
add $t9, $t9, $t7
lw $t7, 20($t1)
add $t9, $t9, $t7 #$t9 is the calculated y index

blt $t8, $t0, check_x_zero
j invalid

check_x_zero:
bgez $t8, check_y_size
j invalid

check_y_size:
blt $t9, $t0, check_y_zero
j invalid

check_y_zero: #check the validation of calculated x and y 
bgez $t9, valid
j invalid

invalid: #load 0 to output address if invalid, start another loop
li $t4, 0x00
sb $t4, 0($t6)
addi $t6, $t6, 1
j done

valid: #load the corresponding value to output address
mul $t7, $t9, $t0
add $t7, $t7, $t8
add $t5, $t5, $t7
lbu $t4, 0($t5)
sub $t5, $t5, $t7

sb $t4, 0($t6)
addi $t6, $t6, 1

done:
addi $t2, $t2, 1
j inner_loop

end_myloop:
############################### Part 2: your code ends here  ##
jr $ra
###############################################################
