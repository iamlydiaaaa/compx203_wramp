.global main
.text

main:  # Setup interrupts 
    movsg $3, $cctrl            # Copy the current value of $cctrl into $3
    andi  $3, $3, 0x000f        # Disable all interrupts
    # addi $3, $0, 0x4d           # Unmask IRQ2, KU=1, OKU=1, IE=0, OIE=1
    ori   $3, $3, 0x0042        # Enable IRQ2(timer) and IE
    movgs $cctrl, $3            # Copy the new CPU control value back to $cctrl

    sw $0, 0x72003($0)          # Acknowledge the interrupt
    addi $11, $0, 24          # Put count value(24) into the timer load register
    sw $11, 0x72001($0)

    addi $11, $0, 0x3           # Enable the timer and set auto-restart mode
    sw $11, 0x72000($0)

    movsg $4, $evec             # Get the old handler's address
    sw    $4, old_vector($0)    # and save it

    la    $4, handler           # Get the address of our handler
    movgs $evec, $4             # And copy it in the exception vector($evec) register 

    j serial_main

handler:    
    movsg $13, $estat           # Get the value of the Exception Status Register

    andi $13, $13, 0xffb0       # Check if there are interrupts other than IRQ2
    beqz $13, interrupt_handler  # If it is the one we want, Jump to handle_interrupt
    
    lw $13, old_vector($0)      # Otherwise, jump to the system handler(default) that we saved earlier.
    jr $13


interrupt_handler:    
    sw $0, 0x72003($0)          # Acknowledge the interrupt

    lw $13, counter($0)          # Load, increase, Store the counter
    addi $13, $13, 1
    sw $13, counter($0)

    rfe



.data
old_vector: .word 0