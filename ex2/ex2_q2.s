.global	main
.text
main:
	subui	$sp, $sp, 7     # $sp = $sp - 7, unsigned
	sw	$7, 2($sp)          # save $7 into memory at base 2($sp)
	sw	$13, 3($sp)         # save $13 into memory at base 3($sp)
	sw	$ra, 4($sp)         # save $ra into memory at base 4($sp)
	jal	readswitches
	addu	$13, $0, $1     # $13 = $0 + $1, unsigned
	addu	$7, $0, $13     # $7 = $0 + $13, unsigned
	srai	$13, $7, 8      # shift $7 right by 8

	andi	$13, $13, 255   # IF $13 && 255, return $13
	sw	$13, 6($sp)         # save $13 into 6($sp)

	andi	$13, $7, 255    # ELSE IF $7 && 255, return $13
	sw	$13, 5($sp)         # save $13 into 5($sp)

	lw	$13, 6($sp)         # load into $13 the value stored in 6($sp) 
	sw	$13, 1($sp)         ## save $13 into 0($sp) <-changed!
    
	lw	$13, 5($sp)         # load into $13 the value stored in 5($sp) 
	sw	$13, 0($sp)         ## save $13 into 1($sp) <-changed!
	jal	count
L.5:
	lw	$7, 2($sp)
	lw	$13, 3($sp)
	lw	$ra, 4($sp)
	addui	$sp, $sp, 7
	jr	$ra
