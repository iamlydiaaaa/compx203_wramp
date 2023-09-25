.text

.global main
main:
	addi $2, $0, 0		# initialise a result to zero
	addi $3, $0, 0		# a counter
	addi $9, $0, 8		#initialise a loop counter
	
	jal readswitches
	
loop:
	beqz $9, endloop	# if loop == 0, go to 'endloop'
	
	andi $4, $1, 1		# if the last bit of $1 is 1, set $4=1 (true)
	beqz $4, else	    # if $4==0(false), than go to 'else'
	addi $3, $3, 1		# add 1 to counter ($3)

else:
	divi $1, $1, 2		# Shifts $1 to the right by 1 bit, $1 = $1 % 2 
	subi $9, $9, 1		# Decrement the loop counter
	j loop
	
endloop:
	add $2, $2, $3		# add the total counts($3) to the result($2)
	jal writessd
	j main
