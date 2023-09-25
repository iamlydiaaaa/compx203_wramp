.global	printChar
.text
printChar:
	subui	$sp, $sp, 2
	sw	$12, 0($sp)
	sw	$13, 1($sp)
L.6:
L.7:
	lhi	$13, 0x7
	ori	$13, $13, 0x3
	lw	$13, 0($13)
	andi	$13, $13, 2
	seq	$13, $13, $0
	bnez	$13, L.6
	lhi	$13, 0x7
	ori	$13, $13, 0x0
	lw	$12, 2($sp)
	sw	$12, 0($13)
L.5:
	lw	$12, 0($sp)
	lw	$13, 1($sp)
	addui	$sp, $sp, 2
	jr	$ra
.global	main
main:
	subui	$sp, $sp, 5
	sw	$6, 1($sp)
	sw	$7, 2($sp)
	sw	$13, 3($sp)
	sw	$ra, 4($sp)
	addu	$6, $0, $0
	j	L.11
L.10:
	lhi	$13, 0x7
	ori	$13, $13, 0x3000
	lw	$6, 0($13)
	addui	$13, $0, 13
	sw	$13, 0($sp)
	jal	printChar
	addui	$7, $0, 128
L.13:
	and	$13, $6, $7
	seq	$13, $13, $0
	bnez	$13, L.17
	addui	$13, $0, 95
	sw	$13, 0($sp)
	jal	printChar
	j	L.18
L.17:
	addui	$13, $0, 45
	sw	$13, 0($sp)
	jal	printChar
L.18:
L.14:
	srai	$7, $7, 1
	sne	$13, $7, $0
	bnez	$13, L.13
L.19:
L.20:
	lhi	$13, 0x7
	ori	$13, $13, 0x3000
	lw	$13, 0($13)
	seq	$13, $6, $13
	bnez	$13, L.19
L.11:
	j	L.10
L.9:
	lw	$6, 1($sp)
	lw	$7, 2($sp)
	lw	$13, 3($sp)
	lw	$ra, 4($sp)
	addui	$sp, $sp, 5
	jr	$ra
