.data

lfsr:
	.align 4
	.word 0x1

.text

# Implements a 16-bit lfsr
#
# Arguments: None
lfsr_random:
	la t0 lfsr      #t0 holds lfsr address
	lhu a0 0(t0)	#load lfsr in a0

	# Your Code Here
	addi t1, x0, 0		#t1 = i = 0
	addi t2, x0, 16		#t2 = 16
	loop:
		bge t1, t2, endloop

		#store highest in t3
		#a0 holds "reg"

		srli t3, a0, 0	#t3 = reg >> 0
		srli t4, a0, 2	#t4 = reg >> 2
		xor t3, t3, t4  #t3 = (reg >> 0) ^ (reg >> 2)

		srli t4, a0, 3  #t4 = reg >> 3
		xor t3, t3, t4	#t3 = (reg >> 0) ^ (reg >> 2) ^ (reg >> 3)

		srli t4, a0, 5    #t4 = reg >> 5
		xor t3, t3, t4    #t3 = (reg >> 0) ^ (reg >> 2) ^ (reg >> 3) ^ (reg >> 5)
		andi t3, t3, 0x1  #clear all bits besides LSB (only bit needed)

		#t3 currently holds "highest"
		#a0 currently holds "reg"

		srli a0, a0, 1  #reg = reg >> 1
		slli t3, t3, 15 #highest = highest << 15
		or a0, a0, t3	#reg = (reg >> 1) | (highest << 15);

		addi t1, t1, 1	#i++
		j loop			#loop

	endloop:

	la t0 lfsr      #store lfsr in t0
	sh a0 0(t0)		#store lower 16 bits of lfsr into a0
	jr ra           #return
