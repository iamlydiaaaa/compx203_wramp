.data 
counter: .word 0
old_vector: .word 0

.global main
.text

main:  # Setup interrupts 
    movsg $3, $cctrl            # Copy the current value of $cctrl into $3
    andi  $3, $3, 0x000f        # Disable all interrupts
    ori   $3, $3, 0x00A2        # Enable IRQ1, IRQ3 and IE
    movgs $cctrl, $3            # Copy the new CPU control value back to $cctrl

    addi $5, $0, 3              # Enable Parallel Control Registor (Manual p35)
    sw $5, 0x73004($0)

    movsg $4, $evec             # Get the old handler's address
    sw    $4, old_vector($0)    # and save it

    la    $4, handler           # Get the address of our handler
    movgs $evec, $4             # And copy it in the exception vector($evec) register 

loop:  # Main program loop (Mainline code)

    lw $2, counter($0)
    remi $2, $2, 10
    sw $2, 0x73009($0)          # print to SSD

    srli $2, $2, 4

    lw $2, counter($0)
    divi $2, $2, 10
    sw $2, 0x73008($0)

    j loop

handler:    
    movsg $13, $estat           # Get the value of the Exception Status Register

    andi $13, $13, 0xffd0       # Check if there are interrupts other than IRQ1
    beqz $13, user_interrupt_handler  # If it is the one we want, Jump to handle_interrupt
    

    andi $13, $13, 0xff70        # Check if there are interrupts other than IRQ3
    beqz $13, parallel_interrupt_handler  # If it is the one we want, Jump to handle_interrupt
    
    lw $13, old_vector($0)      # Otherwise, jump to the system handler(default) that we saved earlier.
    jr $13



user_interrupt_handler:    
    sw $0, 0x7f000($0)          # Acknowledge the interrupt

    lw $13, counter($0)          # Load, increase, Store the counter
    addi $13, $13, 1
    sw $13, counter($0)

    rfe         # Return from the interrupt (rfe)


parallel_interrupt_handler:
    sw $0, 0x73005($0)          # Acknowledge the interrupt

    lw $13, 0x73001($0)
    beqz $13, return

    lw $13, counter($0)          # Load, increase, Store the counter
    addi $13, $13, 1
    sw $13, counter($0)


return:
    rfe         # Return from the interrupt (rfe)
