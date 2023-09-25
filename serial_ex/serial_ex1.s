.global main
.text
main:
        add $2, $0, $0  # Index counter
loop:
        lw $13, test_msg($2)    # Get the next character to transmit
        beqz $13, endloop       # If we've reached the end of the word, finish.
        sw $13, 0x70000($0)     # Put the character into the serial transmit data register
        addi $2, $2, 1          # Increment index counter
        j loop
endloop:
        jr $ra


.data
test_msg:
        .asciiz "Hello COMPX203! This message has come a long way.\n It is first loaded into the RAM of the basys board,\n then moved into a register on the cpu,\n then moved to the serial port,\n then transmitted to this computer for you to read."