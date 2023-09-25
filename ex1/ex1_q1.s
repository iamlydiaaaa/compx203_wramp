.text

.global main
main:
	addi $2, $0, 0 #initialise a counter to zero
	
	jal readswitches
	
	add $2, $1, $0

	jal writessd
	
	j main
