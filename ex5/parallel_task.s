.global	parallel_main
.text
parallel_main:
	subui	$sp, $sp, 5
	sw	$5, 0($sp)
	sw	$6, 1($sp)
	sw	$7, 2($sp)
	sw	$12, 3($sp)
	sw	$13, 4($sp)
	addu	$6, $0, $0
	addu	$5, $0, $0
	addui	$7, $0, 10
	j	L.7
L.6:
	lhi	$13, 0x7
	ori	$13, $13, 0x3000
	lw	$6, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3001
	lw	$5, 0($13)
	snei	$13, $5, 1
	bnez	$13, L.9
	addui	$7, $0, 10
L.9:
	snei	$13, $5, 2
	bnez	$13, L.11
	addui	$7, $0, 16
	j	L.12
L.11:
	snei	$13, $5, 4
	bnez	$13, L.13
	j	L.5
L.13:
L.12:
	slt	$13, $6, $0
	bnez	$13, L.17
	mult	$13, $7, $7
	mult	$13, $13, $7
	mult	$13, $13, $7
	slt	$13, $6, $13
	bnez	$13, L.15
L.17:
	j	L.5
L.15:
	lhi	$13, 0x7
	ori	$13, $13, 0x3006
	mult	$12, $7, $7
	mult	$12, $12, $7
	div	$12, $6, $12
	rem	$12, $12, $7
	sw	$12, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3007
	mult	$12, $7, $7
	div	$12, $6, $12
	rem	$12, $12, $7
	sw	$12, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3008
	div	$12, $6, $7
	rem	$12, $12, $7
	sw	$12, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3009
	rem	$12, $6, $7
	sw	$12, 0($13)
L.7:
	j	L.6
L.18:
L.19:
	lhi	$13, 0x7
	ori	$13, $13, 0x3000
	lw	$13, 0($13)
	seq	$13, $6, $13
	bnez	$13, L.18
L.5:
	lw	$5, 0($sp)
	lw	$6, 1($sp)
	lw	$7, 2($sp)
	lw	$12, 3($sp)
	lw	$13, 4($sp)
	addui	$sp, $sp, 5
	jr	$ra
