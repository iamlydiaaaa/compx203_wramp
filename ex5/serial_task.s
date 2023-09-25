.global	counter
counter:
	.word	0x0
.global	printChar
.text
printChar:
	subui	$sp, $sp, 2
	sw	$12, 0($sp)
	sw	$13, 1($sp)
L.6:
L.7:
	lhi	$13, 0x7
	ori	$13, $13, 0x1003
	lw	$13, 0($13)
	andi	$13, $13, 2
	seq	$13, $13, $0
	bnez	$13, L.6
	lhi	$13, 0x7
	ori	$13, $13, 0x1000
	lw	$12, 2($sp)
	sw	$12, 0($13)
L.5:
	lw	$12, 0($sp)
	lw	$13, 1($sp)
	addui	$sp, $sp, 2
	jr	$ra
.global	serial_main
serial_main:
	subui	$sp, $sp, 9
	sw	$3, 1($sp)
	sw	$4, 2($sp)
	sw	$5, 3($sp)
	sw	$6, 4($sp)
	sw	$7, 5($sp)
	sw	$12, 6($sp)
	sw	$13, 7($sp)
	sw	$ra, 8($sp)
	addui	$6, $0, 49
	addui	$5, $0, 49
	addu	$7, $0, $0
	addu	$3, $0, $0
	addu	$4, $0, $0
	j	L.11
L.10:
	lhi	$13, 0x7
	ori	$13, $13, 0x1001
	lw	$6, 0($13)
	snei	$13, $6, 49
	bnez	$13, L.13
	addui	$5, $0, 49
	j	L.14
L.13:
	snei	$13, $6, 50
	bnez	$13, L.15
	addui	$5, $0, 50
	j	L.16
L.15:
	snei	$13, $6, 51
	bnez	$13, L.17
	addui	$5, $0, 51
	j	L.18
L.17:
	snei	$13, $6, 113
	bnez	$13, L.19
	j	L.9
L.19:
L.18:
L.16:
L.14:
	addui	$13, $0, 13
	sw	$13, 0($sp)
	jal	printChar
	snei	$13, $5, 49
	bnez	$13, L.21
	lw	$13, counter($0)
	divi	$7, $13, 100
	addu	$4, $0, $13
	divi	$13, $7, 1000
	remi	$13, $13, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	divi	$13, $7, 100
	remi	$13, $13, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	addui	$13, $0, 10
	div	$12, $7, $13
	rem	$13, $12, $13
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	remi	$13, $7, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	addui	$13, $0, 46
	sw	$13, 0($sp)
	jal	printChar
	addui	$13, $0, 10
	div	$12, $4, $13
	rem	$13, $12, $13
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	remi	$13, $4, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	j	L.22
L.21:
	snei	$13, $5, 50
	bnez	$13, L.23
	lw	$13, counter($0)
	divi	$7, $13, 100
	divi	$3, $13, 6000
	addui	$13, $0, 10
	div	$12, $3, $13
	rem	$13, $12, $13
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	remi	$13, $3, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	addui	$13, $0, 58
	sw	$13, 0($sp)
	jal	printChar
	divi	$13, $7, 10
	remi	$13, $13, 6
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	remi	$13, $7, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	addui	$13, $0, 32
	sw	$13, 0($sp)
	jal	printChar
	addui	$13, $0, 32
	sw	$13, 0($sp)
	jal	printChar
	j	L.24
L.23:
	snei	$13, $5, 51
	bnez	$13, L.25
	lw	$13, counter($0)
	lhi	$12, 0x1
	ori	$12, $12, 0x86a0
	div	$13, $13, $12
	remi	$13, $13, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	lw	$13, counter($0)
	divi	$13, $13, 10000
	remi	$13, $13, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	lw	$13, counter($0)
	divi	$13, $13, 1000
	remi	$13, $13, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	lw	$13, counter($0)
	divi	$13, $13, 100
	remi	$13, $13, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	addui	$13, $0, 10
	lw	$12, counter($0)
	div	$12, $12, $13
	rem	$13, $12, $13
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	lw	$13, counter($0)
	remi	$13, $13, 10
	addi	$13, $13, 48
	sw	$13, 0($sp)
	jal	printChar
	addui	$13, $0, 32
	sw	$13, 0($sp)
	jal	printChar
L.25:
L.24:
L.22:
L.11:
	j	L.10
L.9:
	lw	$3, 1($sp)
	lw	$4, 2($sp)
	lw	$5, 3($sp)
	lw	$6, 4($sp)
	lw	$7, 5($sp)
	lw	$12, 6($sp)
	lw	$13, 7($sp)
	lw	$ra, 8($sp)
	addui	$sp, $sp, 9
	jr	$ra
