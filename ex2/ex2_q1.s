.global	count
.text
count:
	subui	$sp, $sp, 4
	sw	$12, 1($sp)
	sw	$13, 2($sp)
	sw	$ra, 3($sp)
	j	L.3
L.2:
	lw	$13, 4($sp)
	sw	$13, 0($sp)
	jal	writessd
	jal	delay
	lw	$13, 4($sp)
	lw	$12, 5($sp)
	sle	$13, $13, $12
	bnez	$13, L.5
	lw	$13, 4($sp)
	subi	$13, $13, 1
	sw	$13, 4($sp)
	j	L.6
L.5:
	lw	$13, 4($sp)
	addi	$13, $13, 1
	sw	$13, 4($sp)
L.6:
L.3:
	lw	$13, 4($sp)
	lw	$12, 5($sp)
	sne	$13, $13, $12
	bnez	$13, L.2
	lw	$13, 4($sp)
	lw	$12, 5($sp)
	sne	$13, $13, $12
	bnez	$13, L.7
	lw	$13, 4($sp)
	sw	$13, 0($sp)
	jal	writessd
L.7:
L.1:
	lw	$12, 1($sp)
	lw	$13, 2($sp)
	lw	$ra, 3($sp)
	addui	$sp, $sp, 4
	jr	$ra
