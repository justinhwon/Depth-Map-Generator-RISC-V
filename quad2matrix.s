.text

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

