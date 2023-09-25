.global main
.text

main:  # Setup interrupts 
    movsg $3, $cctrl            # Copy the current value of $cctrl into $3
    andi  $3, $3, 0x000f        # Disable all interrupts
    addi $3, $0, 0x4d           # Unmask IRQ2, KU=1, OKU=1, IE=0, OIE=1
    #ori   $3, $3, 0x0042        # Enable IRQ2(timer) and IE
    #movgs $cctrl, $3            # Copy the new CPU control value back to $cctrl

    sw $0, 0x72003($0)          # Acknowledge the interrupt
    addi $11, $0, 24          # Put count value(24) into the timer load register
    sw $11, 0x72001($0)

    addi $11, $0, 0x3           # Enable the timer and set auto-restart mode
    sw $11, 0x72000($0)

    movsg $4, $evec             # Get the old handler's address
    sw    $4, old_vector($0)    # and save it

    la    $4, handler           # Get the address of our handler
    movgs $evec, $4             # And copy it in the exception vector($evec) register 


pcb:    
    
    

    # Setup the PCB for task 1
    la $1, task1_pcb

    la $2, task2_pcb        # Setup the link field
    sw $2, pcb_link($1)

    la $2, task1_stack      # Setup the stack pointer
    sw $2, pcb_sp($1)   

    la $2, serial_main       # Setup the $ear field
    sw $2, pcb_ear($1)

    sw $3, pcb_cctrl($1)    # Setup the $cctrl($1)



     # Setup the PCB for task 2
    la $1, task2_pcb

    la $2, task1_pcb        # Setup the link field
    sw $2, pcb_link($1)

    la $2, task2_stack      # Setup the stack pointer
    sw $2, pcb_sp($1)   
# Setup the $cctrl($1)

    la $2, parallel_main       # Setup the $ear field
    sw $2, pcb_ear($1)

    sw $3, pcb_cctrl($1)    # Setup the $cctrl($1)


    

    la $1, task1_pcb        # Set first task as the current task
    sw $1, current_task($0) 

    j load_context

handler:    
    movsg $13, $estat           # Get the value of the Exception Status Register

    andi $13, $13, 0xffb0       # Check if there are interrupts other than IRQ2
    beqz $13, handle_timer      # If it is the one we want, Jump to handle_interrupt
    
    lw $13, old_vector($0)      # Otherwise, jump to the system handler(default) that we saved earlier.
    jr $13


handle_timer:    
    sw $0, 0x72003($0)          # Acknowledge the interrupt

    lw $13, counter($0)          # Load, increase, Store the counter
    addi $13, $13, 1
    sw $13, counter($0)

    
    lw $13, timeslice($0)      
    subi $13, $13, 1            # Subtract 1 from the timeslice counter 
    sw $13, timeslice($0)
	beqz $13, dispatcher        # If timeslice counter is 0, go to dispatcher
    rfe                         # Otherwise return from exception
    
                 

dispatcher:
save_context:
    
    lw $13, current_task($0)    # Get the base address of the current PCB

    sw $1, pcb_reg1($13)        # Save the registers
    sw $2, pcb_reg2($13)
    sw $3, pcb_reg3($13)
    sw $4, pcb_reg4($13)
    sw $5, pcb_reg5($13)
    sw $6, pcb_reg6($13)
    sw $7, pcb_reg7($13)
    sw $8, pcb_reg8($13)
    sw $9, pcb_reg9($13)
    sw $10, pcb_reg10($13)
    sw $11, pcb_reg11($13)
    sw $12, pcb_reg12($13)
    sw $sp, pcb_sp($13)   
    sw $ra, pcb_ra($13)   

    movsg $1, $ers              # $1 is saved now so we can use it. Get the old value of $13
    sw $1, pcb_reg13($13)       # and save it to the PCB

    movsg $1, $ear              # Save ear
    sw $1, pcb_ear($13)

    movsg $1, $cctrl            # Save cctrl
    sw $1, pcb_cctrl($13)


schedule:
    lw $13, current_task($0)    # Get current task
    lw $13, pcb_link($13)       # Get next task from pcb_link field
    sw $13, current_task($0)    # Set next task as current task

    
    # Reset the timeslice counter to an appropriate value
    addi $13, $0, 100            
    sw $13, timeslice($0)
    
load_context:                   # restoring
    lw $13, current_task($0)    # Get PCB of current task

    lw $1, pcb_reg13($13)       # Get thePCB value for $13 back into $ers
    movgs $ers, $1

    lw $1, pcb_ear($13)         # restore ear
    movgs $ear, $1

    lw $1, pcb_cctrl($13)       # restore cctrl
    movgs $cctrl, $1

    lw $1, pcb_reg1($13)        # restore the other registers
    lw $2, pcb_reg2($13)
    lw $3, pcb_reg3($13)
    lw $4, pcb_reg4($13)
    lw $5, pcb_reg5($13)
    lw $6, pcb_reg6($13)
    lw $7, pcb_reg7($13)
    lw $8, pcb_reg8($13)
    lw $9, pcb_reg9($13)
    lw $10, pcb_reg10($13)
    lw $11, pcb_reg11($13)
    lw $12, pcb_reg12($13)
    lw $sp, pcb_sp($13)   
    lw $ra, pcb_ra($13)   

    rfe                         # Return to the new task


.data
old_vector: .word 0
timeslice: .word 100



.equ pcb_link, 0
.equ pcb_reg1, 1
.equ pcb_reg2, 2
.equ pcb_reg3, 3
.equ pcb_reg4, 4
.equ pcb_reg5, 5
.equ pcb_reg6, 6
.equ pcb_reg7, 7
.equ pcb_reg8, 8
.equ pcb_reg9, 9
.equ pcb_reg10, 10
.equ pcb_reg11, 11
.equ pcb_reg12, 12
.equ pcb_reg13, 13   
.equ pcb_sp, 14
.equ pcb_ra, 15
.equ pcb_ear, 16
.equ pcb_cctrl, 17


.bss
current_task:
        .word
        
task1_pcb:
        .space  18

        .space  100 
task1_stack: 


task2_pcb:
        .space  18


        .space  100
task2_stack:
