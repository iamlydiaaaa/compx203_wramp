.global	pow
.text
pow:
	subui	$sp, $sp, 3
	sw	$6, 0($sp)
	sw	$7, 1($sp)
	sw	$13, 2($sp)
	
	addui	$7, $0, 1
	lw	$13, 4($sp)
	sne	$13, $13, $0
	bnez	$13, L.2
	addu	$1, $0, $7
	j	L.1
L.2:
	addui	$6, $0, 1
	j	L.7
L.4:
	lw	$13, 3($sp)
	mult	$7, $7, $13
L.5:
	addi	$6, $6, 1
L.7:
	lw	$13, 4($sp)
	sle	$13, $6, $13
	bnez	$13, L.4
	addu	$1, $0, $7
L.1:
	lw	$6, 0($sp)
	lw	$7, 1($sp)
	lw	$13, 2($sp)
	addui	$sp, $sp, 3
	jr	$ra
