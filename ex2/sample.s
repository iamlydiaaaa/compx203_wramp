.global	print
.text
print:
	subui	$sp, $sp, 10
	sw	$7, 1($sp)			# count (Initialise)
	sw	$12, 2($sp)			# result
	sw	$13, 3($sp)			# num (from readswitch)
	sw	$ra, 4($sp)
	addui	$7, $0, 4		# count = 4
loop:
	addui	$13, $sp, 5		# $13 = $sp+5
	addu	$13, $7, $13	# $13 = count + $13
	lw	$12, 10($sp)		# load 10($sp) to result
	remi	$12, $12, 10	# result = result % 10
	sw	$12, 0($13)			# store the result to 0($13)
	lw	$13, 10($sp)		# load 10($sp) to $13
	divi	$13, $13, 10	# num = num / 2
	sw	$13, 10($sp)		# store num to 10($sp)

	subi	$7, $7, 1		# count --
	sge	$13, $7, $0			# if count>=0, $13==TRUE
	bnez	$13, loop		# if $13==TRUE, loop

endloop:

	addi $7, $0, 0
	# for(int i=0; i<5; i++)
	slt $13, 

	lw	$13, 5($sp)
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	putc

	lw	$13, 6($sp)
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	putc

	lw	$13, 7($sp)
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	putc

	lw	$13, 8($sp)
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	putc

	lw	$13, 9($sp)
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	putc

L.1:
	lw	$7, 1($sp)
	lw	$12, 2($sp)
	lw	$13, 3($sp)
	lw	$ra, 4($sp)
	addui	$sp, $sp, 10
	jr	$ra
