.data
.files:
.word 0 
matrix:
	.align 4
	.byte 	0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
start_msg: .asciiz "Starting program...\n"
exit_msg:  .asciiz "Exiting program...\n"
# Header for matrix
pm_head:  .asciiz "  -----0----------1----------2----------3----------4----------5----------6----------7-----\n"
# Quadtree Node representation
# Recall that quadtree representation uses the following format:
#	struct qNode {
#		int leaf;
#		int size;
#		int x;
#		int y;
#		int gray_value;
#		qNode *child_NW, *child_NE, *child_SE, *child_SW;
#	}
q00:   .word  0, 8, 0, 0,  -1, 0, 0, 0, 0
qx00:  .word  1, 4, 0, 0,   1, 0, 0, 0, 0
qx40:  .word  0, 4, 4, 0,  -1, 0, 0, 0, 0
qx44:  .word  0, 4, 4, 4,  -1, 0, 0, 0, 0
qx04:  .word  1, 4, 0, 4,   2, 0, 0, 0, 0
qxx40: .word  1, 2, 4, 0,   3, 0, 0, 0, 0
qxx60: .word  1, 2, 6, 0,   4, 0, 0, 0, 0
qxx62: .word  0, 2, 6, 2,  -1, 0, 0, 0, 0
qxx42: .word  1, 2, 4, 2,   5, 0, 0, 0, 0
qxx44: .word  1, 2, 4, 4,   6, 0, 0, 0, 0
qxx64: .word  1, 2, 6, 4,   7, 0, 0, 0, 0
qxx66: .word  0, 2, 6, 6,  -1, 0, 0, 0, 0
qxx46: .word  1, 2, 4, 6,   8, 0, 0, 0, 0
qxxx62: .word 1, 1, 6, 2,   9, 0, 0, 0, 0
qxxx72: .word 1, 1, 7, 2,  10, 0, 0, 0, 0
qxxx73: .word 1, 1, 7, 3,  11, 0, 0, 0, 0
qxxx63: .word 1, 1, 6, 3,  12, 0, 0, 0, 0
qxxx66: .word 1, 1, 6, 6,  13, 0, 0, 0, 0
qxxx76: .word 1, 1, 7, 6,  14, 0, 0, 0, 0
qxxx77: .word 1, 1, 7, 7,  15, 0, 0, 0, 0
qxxx67: .word 1, 1, 6, 7,  16, 0, 0, 0, 0
.text
la t0 .files
main:
	# Load in pointers into data section because Venus does not
	# support using labels as data values
	la t0 q00
	la t1 qx00
	sw t1 20(t0)
	la t1 qx40
	sw t1 24(t0)
	la t1 qx44
	sw t1 28(t0)
	la t1 qx04
	sw t1 32(t0)
	la t0 qx40
	la t1 qxx40
	sw t1 20(t0)
	la t1 qxx60
	sw t1 24(t0)
	la t1 qxx62
	sw t1 28(t0)
	la t1 qxx42
	sw t1 32(t0)
	la t0 qx44
	la t1 qxx44
	sw t1 20(t0)
	la t1 qxx64
	sw t1 24(t0)
	la t1 qxx66
	sw t1 28(t0)
	la t1 qxx46
	sw t1 32(t0)
	la t0 qxx62
	la t1 qxxx62
	sw t1 20(t0)
	la t1 qxxx72
	sw t1 24(t0)
	la t1 qxxx73
	sw t1 28(t0)
	la t1 qxxx63
	sw t1 32(t0)
	la t0 qxx66
	la t1 qxxx66
	sw t1 20(t0)
	la t1 qxxx76
	sw t1 24(t0)
	la t1 qxxx77
	sw t1 28(t0)
	la t1 qxxx67
	sw t1 32(t0)
	# printf("%s", start_msg)
	la a1 start_msg
	jal print_str
	# quad2matrix(&q00, &matrix, 8)
	la a0 q00
	la a1 matrix
	li a2 8
	jal quad2matrix
	# print_matrix(&matrix, 8)
	la a0 matrix
	li a1 8
	li a2 8
	jal print_matrix
	# print a new line
	jal print_newline
	# printf("%s", exit_msg)
	la a1 exit_msg
	jal print_str
	# exit()
	li a0 10
	ecall
# Helper functions (may be useful for debugging)
# You can assume these don't touch any registers except
# ra, a0, and a1.
print_int:
	li a0 1
	ecall
	jr ra
print_intx:
	li a0 34
	ecall
	jr ra
print_str:
	li a0 4
	ecall
	jr ra
print_space:
	li a1 ' '
	li a0 11
	ecall
	jr ra
print_newline:
	li a1 '\n'
	li a0 11
	ecall
	jr ra
# Prints a $a1 x $a2 matrix
#
# Arguments:
#     matrix (unsigned char*)
#     matrix_width (int)
#     matrix_height (int)
print_matrix:
	addi sp sp -24
	sw ra 0(sp)
	sw s0 4(sp)
	sw s1 8(sp)
	sw s2 12(sp)
	sw s3 16(sp)
	sw s4 20(sp)
	# s0 = matrix
	mv s0 a0
	# s1 = matrix_width
	mv s1 a1
	# s2 = matrix_height
	mv s2 a2
	# printf("%s", pm_head)
	la a1 pm_head
	jal print_str
	# for (s3 = 0; s3 < height; s3++)
	mv s3 x0
pm_loop1:
	bge s3 s2 pm_loop1end
	#printf("%d ", s3)
	mv a1 s3
	jal print_int
	jal print_space
	# for (s4 = 0; s4 < width; s4++)
	mv s4 x0
pm_loop2:
	bge s4 s1 pm_loop2end
	# printf("%x ", matrix[s3 * width + s4])
	mul t5 s1 s3
	add t5 t5 s4
	add t5 s0 t5
	lbu a1 0(t5)
	jal print_intx
	jal print_space
	addi s4 s4 1
	j pm_loop2
pm_loop2end:
	# printf("\n")
	jal print_newline
	addi s3 s3 1
	j pm_loop1
pm_loop1end:
	lw ra 0(sp)
	lw s0 4(sp)
	lw s1 8(sp)
	lw s2 12(sp)
	lw s3 16(sp)
	lw s4 20(sp)
	addi sp sp 24
	jr ra
# Decodes a quadtree to the original matrix
#
# Arguments:
#     quadtree (qNode*)
#     matrix (void*)
#     matrix_width (int)
#
# Recall that quadtree representation uses the following format:
#     struct qNode {
#         int leaf;
#         int size;
#         int x;
#         int y;
#         int gray_value;
#         qNode *child_NW, *child_NE, *child_SE, *child_SW;
#     }
quad2matrix:
	# Your code here
	# a0 has pointer to quadtree root
	mv s1, a1	# s1 has pointer to matrix
	mv s2, a2	# s2 has width of matrix
	addi s3, x0, 1	# s3 = 1
	#a0 should hold valid pointer to current node (not null)
	beq a0, x0, nullptr
	#a1 should hold valid pointer to matrix (not null)
	beq a1, x0, nullptr
	#a2 should not be negative (else return, which nullptr label does)
	blt a2, x0, nullptr
	# Save the return address before recursive calls
	addi sp, sp, -4
	sw ra, 0(sp)
	# Call matrix_fxn
	jal ra, matrix_fxn
	# Restore the stack pointer and return adddress
	lw ra, 0(sp)
	addi sp, sp, 4
	# Prewritten code
	jr ra
# s1 holds pointer to matrix
# s2 holds width of matrix
#a0 should hold current node
matrix_fxn:
	#store leaf in t0
	lw t0, 0(a0)
	#store pointer to current node (a0) in s4
	mv s4, a0
	# if leaf = 1, is a node (s3 holds 1)
	beq t0, s3, is_leaf
	# save the return address and current node in stack frame
	addi sp, sp, -8
	sw ra, 4(sp)
	sw s4, 0(sp)
	# if not a node recurse fxn on all child nodes
	# a0 = 20(a0)
	# child NW
	lw a0, 20(s4)
	jal ra, matrix_fxn
	lw s4, 0(sp)	# restore s4 after call returns
	# child NE
	lw a0, 24(s4)
	jal ra, matrix_fxn
	lw s4, 0(sp)	# restore s4 after call returns
	# child SE
	lw a0, 28(s4)
	jal ra, matrix_fxn
	lw s4, 0(sp)	# restore s4 after call returns
	# child SW
	lw a0, 32(s4)
	jal ra, matrix_fxn
	# Restore the stack pointer and return adddress
	lw s4, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 8
	# return to caller
	jr ra
# Finish recursive call if leaf
is_leaf:
	# fill in array
	# store size in t0
	lw t0, 4(a0)
	# store x in t1
	lw t1, 8(a0)
	# store y in t2
	lw t2, 12(a0)
	# store gray_value in t3
	lw t3, 16(a0)
	# s1 has pointer to matrix
	# s2 has width of matrix
	# t4 is counter for x
	mv t4, t1
	# t5 is counter for y
	mv t5, t2
	# t1 becomes upper limit for x (x+size)
	add t1, t1, t0
	# t2 becomes upper limit for y (y+size)
	add t2, t2, t0
	# to account for starting at index 0, subtract 1 from x in beginning
	addi t4, t4, -1
	# loop all x
	x_loop:
	addi t4, t4, 1 # x++
	# loop until x >= x+size
	bge t4, t1, endloop
	# reset y counter every x_loop
	lw t5, 12(a0)
	# loop all y
	halfloop:
		bge t5, t2, x_loop
		# t6 holds current index value (y*width + x)
		mul t6, t5, s2 # index = y*width
		add t6, t6, t4 # index = index + x
		# add s1 (pointer to matrix) to t6 (index value)
		add t6, t6, s1
		# store gray value in matching index
		sb t3, 0(t6)
		# update y counter and jump
		addi t5, t5, 1
		j halfloop
	endloop:
	# return to caller
	jr ra
# just return if null pointer
nullptr:
	jr ra
