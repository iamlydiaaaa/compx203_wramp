.global main
.text

main:  # Setup interrupts 
    sw $ra, 0($sp)
    subui $sp, $sp, 1

    movsg $3, $cctrl            # Copy the current value of $cctrl into $3
    andi  $3, $3, 0x000f        # Disable all interrupts
    ori   $3, $3, 0x00C2        # Enable IRQ2(timer), IRQ3(Parallel) and IE
    movgs $cctrl, $3            # Copy the new CPU control value back to $cctrl

    # Setup Parallel Control Register
    addi $5, $0, 3              # Enable Parallel Control Registor (Manual p35)
    sw $5, 0x73004($0)

    # Setup Timer Register
    sw $0, 0x72003($0)          # Acknowledge the timer interrupt
    addi $11, $0, 24          # Put count value(2400) into the timer load register
    sw $11, 0x72001($0)

    addi $11, $0, 0x2           # Enable Automatic restart only
    sw $11, 0x72000($0)

    movsg $4, $evec             # Get the old handler's address
    sw    $4, old_vector($0)    # and save it

    la    $4, handler           # Get the address of our handler
    movgs $evec, $4             # And copy it in the exception vector($evec) register 


loop:  # Main program loop (Mainline code)

    lw $2, counter($0)
    divi $2, $2, 100
    remi $2, $2, 10
    sw $2, 0x73009($0)          # print to SSD
    
    lw $2, counter($0)
    divi $2, $2, 1000
    remi $2, $2, 10
    sw $2, 0x73008($0)

    j loop


handler:    
    movsg $13, $estat           # Get the value of the Exception Status Register
    lw $1, 0x73001($0)         # the value of push button pressed
    andi $13, $13, 0xff70        # Check if there are interrupts other than IRQ3
    beqz $13, parallel_interrupt_handler  # If it is the one we want, Jump to handle_interrupt


    andi $13, $13, 0xffb0       # Check if there are interrupts other than IRQ2
    beqz $13, interrupt_handler  # If it is the one we want, Jump to handle_interrupt
    
    lw $13, old_vector($0)      # Otherwise, jump to the system handler(default) that we saved earlier.
    jr $13



parallel_interrupt_handler:
    sw $0, 0x73005($0)          # Acknowledge the push button interrupt
    beqz $1, return            # IF nothing pressed, then return

case_one:           # start (or resume) the stopwatch (Toggle timer enable bit)
    andi $12, $1, 0x1
    beqz $12, case_two


    lw $13, 0x72000($0)
    seqi $13, $13, 0x2
    beqz $13, stop              # IF timer is running, then stop

    start: 
        lw $13, 0x72000($0)
        addi $13, $0, 0x3           # Enable the timer and set auto-restart mode
        sw $13, 0x72000($0)
        rfe

    stop:

        lw $13, 0x72000($0)
        addi $13, $0, 0x2 
        sw $13, 0x72000($0)
        rfe

case_two:               # reset the counter to zero if timer enable=0
    andi $12, $1, 0x2
    beqz $12, case_three

    lw $13, 0x72000($0)         # Check if Timer Enable=0  
    seqi $13, $13, 0x2
    beqz $13, record            
    
    lw $13, counter($0)         # reset the counter
    addi $13, $0, 0
    sw $13, counter($0)          

    lw $13, 0x73009($0)          # print to SSD
    addi $13, $0, 0
    sw $13, 0x73009($0)          # print to SSD

    lw $13, 0x73008($0)          # print to SSD
    addi $13, $0, 0
    sw $13, 0x73008($0)          # print to SSD

    rfe

    record:
        # print out the number of counter to the Serial Port 2

        lw $13, carriage($0)    # \r
        jal check_string


        lw $13, newline($0)     # \n
        jal check_string


        lw $13, counter($0)     # num_1 
        divi $13, $13, 1000
        jal check_character    


        lw $13, counter($0)     # num_2
        divi $13, $13, 100
        jal check_character


        lw $13, dot($0)         # .
        jal check_string


        lw $13, counter($0)    # num_3
        divi $13, $13, 10
        jal check_character


        lw $13, counter($0)    # num_4
        jal check_character


        rfe


    check_character:
        lw $12, 0x71003($0)
        andi $12, $12, 0x2
        beqz $12, check_character

        remi $13, $13, 10
        addi $13, $13, '0'
        sw $13, 0x71000($0)

        jr $ra

    check_string:
        lw $12, 0x71003($0)
        andi $12, $12, 0x2
        beqz $12, check_string

        sw $13, 0x71000($0)

        jr $ra
        

case_three:              # EXIT the program
    andi $12, $1, 0x4
    beqz $12, loop

    lw $13, 0x72000($0)
    addi $13, $0, 0x2
    sw $13, 0x72000($0)
    

    lw $13, counter($0)         # reset the counter
    addi $13, $0, 0
    sw $13, counter($0)          

    lw $13, 0x73009($0)          # print to SSD
    addi $13, $0, 0
    sw $13, 0x73009($0)          # print to SSD

    lw $13, 0x73008($0)          # print to SSD
    addi $13, $0, 0
    sw $13, 0x73008($0)          # print to SSD

    addui $sp, $sp, 1
    lw $ra, 0($sp)
    jr $ra


interrupt_handler:    
    sw $0, 0x72003($0)          # Acknowledge the interrupt

    lw $13, counter($0)          # Load, increase, Store the counter
    addi $13, $13, 1
    sw $13, counter($0)

reset:

return: 
    rfe


.data 
counter: .word 0
carriage: .word '\r'
newline: .word '\n'
dot: .word '.'

old_vector: .word 0