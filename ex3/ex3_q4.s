.global main
.text
main:
    sw $ra, 0($sp)
    subui $sp, $sp, 1
    
loop:
    jal serial_job          
    jal parallel_job       
    j loop


exit:
    addui $sp, $sp, 1
    lw $ra, 0($sp)

return:
    jr $ra




serial_job:
    s_loop:
        lw $6, 0x70003($0)     # Get the Serial Status Register value
        andi  $6, $6, 0x1      # Check if the Transmit Data Sent bit is set to 1
        beqz $6, return          # If it is not, check again until it is

        addi $5, $0, '#'       # Initialise character  
        lw $2, 0x70001($0)     # Read a character from SP1
        sw $2, 0x70000($0)

    check:                     # Check if the received character is a lowercase letter
        sgei $2, $2, 'a'
        beqz $2, not_lower
        slei $2, $2, 'z'
        beqz $2, not_lower

        j s_loop

    not_lower:                 # if is not a Lowercase letter, than replace it with '#'
        sw $5, 0x70000($0)  
        j s_loop
    


parallel_job:
    p_loop:
        addi $2, $0, 0
        addi $9, $0, 0xffff

        lw $1, 0x73000($0)      # $2 = the value from the switch
        add $2, $1, $0 

        lw $1, 0x73001($0)      # $1 = the value of push button pressed
        beqz $1, return           # wait until a button is pressed

    case_one:
        andi $11, $1, 0x1
        beqz $11, case_two
        j check_led

    case_two:                   # INVERT the $2 value 
        andi $11, $1, 0x2
        beqz $11, case_three
        xori $2, $2, 0xffff 
        j check_led


    case_three:                 # EXIT the program
        andi $11, $1, 0x4
        beqz $11, return

        j exit


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

        j p_loop
