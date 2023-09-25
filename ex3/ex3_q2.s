.global main
.text
main:
        addi $5, $0, '#'        # Initialise character  

loop:
        lw $11, 0x70003($0)     # Get the Serial Status Register value
        andi  $11, $11, 0x1     # Check if the Transmit Data Sent bit is set to 1
        beqz $11, loop          # If it is not, check again until it is

        lw $2, 0x70001($0)      # Read a character from SP1
        sw $2, 0x70000($0)

check:                          # Check if the received character is a lowercase letter
        sgei $2, $2, 'a'
        beqz $2, not_lower
        slei $2, $2, 'z'
        beqz $2, not_lower

        j loop

not_lower:                      # if is not a Lowercase letter, than replace it with '#'
        sw $5, 0x70000($0)  
        j loop
