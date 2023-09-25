.global main
.text
main:
    sw $ra, 0($sp)
    subui $sp, $sp, 1

loop:
    addi $2, $0, 0
    addi $9, $0, 0xffff

    lw $1, 0x73000($0)  # $2 = the value from the switch
    add $2, $1, $0 

    lw $1, 0x73001($0)  # $1 = the value of push button pressed
    beqz $1, loop       # wait until a button is pressed

case_one:
    andi $11, $1, 0x1
    beqz $11, case_two
    j check_led

case_two:               # INVERT the $2 value 
    andi $11, $1, 0x2
    beqz $11, case_three
    xori $2, $2, 0xffff 
    j check_led


case_three:              # EXIT the program
    andi $11, $1, 0x4
    beqz $11, loop

    addui $sp, $sp, 1
    lw $ra, 0($sp)
    jr $ra


check_led:
    remi $10, $2, 4          # CHECK IF $2 % 4 = 0
    bnez $10, turn_off_led

    sw $9, 0x7300A($0)      # turn ON all the LEDs.
    j case_end

turn_off_led:               
    sw $0, 0x7300A($0)      # turn OFF all the LEDs.
    j case_end


case_end:
    sw $2, 0x73009($0)      # Write down to the SSD
	srli $2, $2, 4
	sw $2, 0x73008($0)
	srli $2, $2, 4
	sw $2, 0x73007($0)
	srli $2, $2, 4
	sw $2, 0x73006($0)

    
    j loop