.global main
.text
main:
        addi $2, $0, 'A'        # Initialise UpperCase character
        addi $3, $0, 'a'        # Initialise LowerCase character
        
uppercase:
        lw $12, 0x71003($0)     # Get the Serial Status Register value (Port2)
        andi  $12, $12, 0x2     # Check if the Transmit Data Sent bit is set to 1
        beqz $12, uppercase     # If it is not, check again until it is

        sw $2, 0x71000($0)      # Put the character into the Serial Transmit Data register (Port2)
        addi $2, $2, 1          # Increment index counter
        
lowercase:
        lw $11, 0x71003($0)
        andi $11, $11, 0x2
        beqz $11, lowercase

        sw $3, 0x71000($0)
        addi $3, $3, 1

check:
        sgti $5, $2, 'Z'        #IF the character reached to 'Z', then go to endloop
        bnez $5, endloop

        sgti $6, $3, 'z'        #IF the character reached to 'z', then go to endloop
        bnez $6, endloop

        j uppercase

endloop:
        jr $ra