.text

.global readswitches
readswitches:
	lw	$1, 0x73000($0)
	jr	$ra

.global writessd
writessd:	
	sw	$2, 0x73003($0)
	srli	$1, $2, 4
	sw	$1, 0x73002($0)
	jr	$ra
	
.global putstr
putstr:
	subui	$sp, $sp, 2
	sw	$ra, 1($sp)
	sw	$2, 0($sp)
	jal	printf
	lw	$ra, 1($sp)
	addui	$sp, $sp, 2
	jr	$ra
	
.global readchar
readchar:
	subui	$sp, $sp, 1
	sw	$ra, 0($sp)
	jal	read_char
	lw	$ra, 0($sp)
	addui	$sp, $sp, 1
	jr	$ra

.global putch
putch:
	subui	$sp, $sp, 2
	sw	$ra, 1($sp)
	sw	$2, 0($sp)
	jal	send_char
	lw	$ra, 1($sp)
	addui	$sp, $sp, 2
	jr	$ra

.global readnum
readnum:
	subui	$sp, $sp, 4
	sw	$ra, 3($sp)

	la	$1, buffer
	sw	$1, 0($sp)
	jal	gets

	la	$1, buffer
	sw	$1, 0($sp)
	la	$1, tmp
	sw	$1, 1($sp)
	addui	$1, $0, 10
	sw	$1, 2($sp)
	jal	atob
	
	lw	$1, tmp($0)

	lw	$ra, 3($sp)
	addui	$sp, $sp, 4
	jr	$ra

.global writenum
writenum:
	subui	$sp, $sp, 3
	sw	$2, 1($sp)
	la	$1, number
	sw	$1, 0($sp)
	sw	$ra, 2($sp)
	jal	printf
	lw	$1, 1($sp)
	lw	$ra, 2($sp)
	addui	$sp, $sp, 3
	jr	$ra
	

.bss
buffer:
	.space	256
tmp:	.word
	
.data
number:
	.asciiz	"%d\n"
	
.text
	
.global exit
exit:
	syscall

read_char:
	lw	$1, 0x70003($zero)
	andi	$1, $1, 0x1
	beqz	$1, read_char

	lw	$1, 0x70001($zero)

	andi	$1, $1, 0xff

	jr	$ra

send_char:
	lw	$1, 0x70003($0)		# Get LSR
	andi	$1, $1, 0x2		# Look at TDS bit
	beqz	$1, send_char		# Wait for previous character to be sent

	lw	$1, 0($sp)		# Get the character
	sw	$1, 0x70000($0)		# Send the character
	
	jr	$ra
	
# int strlen(char *s)
# returns the length of string s
strlen:
	# Save registers
	subui	$sp, $sp, 2
	sw	$4, 0($sp)
	sw	$5, 1($sp)

	# Get the parameter
	lw	$4, 2($sp)

	# Reset the counter
	addu	$1, $0, $0

strlen_loop:
	# Get the character
	lw	$5, 0($4)
	
	# Increment the pointer
	addui	$4, $4, 1

	# Exit on end of string
	beqz	$5, strlen_end

	# Increment the counter
	addui	$1, $1, 1

	# Loop
	j	strlen_loop
strlen_end:

	# Restore registers
	lw	$4, 0($sp)
	lw	$5, 1($sp)
	addui	$sp, $sp, 2
	
	# Return
	jr	$ra

# int isdigit(char c)
# Returns 1 if c is an digit character
isdigit:
	# Save a register
	subui	$sp, $sp, 1
	sw	$4, 0($sp)

	# Get the parameter
	lw	$4, 1($sp)

	# Test for >= '0'
	sgei	$1, $4, '0'
	# Test for <= '9'
	slei	$4, $4, '9'
	# We want both of these
	and	$1, $1, $4
	
	# Restore the register
	lw	$4, 0($sp)
	addui	$sp, $sp, 1
	
	# Return
	jr	$ra

# int ishex(char c)
# Returns 1 if c is an digit character
ishex:
	# Save a register
	subui	$sp, $sp, 3
	sw	$4, 0($sp)
	sw	$5, 1($sp)
	sw	$6, 2($sp)

	# Get the parameter
	lw	$4, 3($sp)

	# Test for >= '0'
	sgei	$1, $4, '0'
	# Test for <= '9'
	slei	$5, $4, '9'
	# We want both of these
	and	$1, $1, $5

	# Test for >= 'a'
	sgei	$5, $4, 'a'
	# Test for <= 'f'
	slei	$6, $4, 'f'
	# We want both of these
	and	$5, $5, $6

	# Combine with the first result
	or	$1, $1, $5
	
	# Test for >= 'A'
	sgei	$5, $4, 'A'
	# Test for <= 'F'
	slei	$6, $4, 'F'
	# We want both of these
	and	$5, $5, $6

	# Combine with the first two
	or	$1, $1, $5
	
	# Restore the register
	lw	$4, 0($sp)
	lw	$5, 1($sp)
	lw	$6, 2($sp)
	addui	$sp, $sp, 3
	
	# Return
	jr	$ra

# int isprint(char c)
# Returns 1 if c is an printable character
isprint:
	# Save a register
	subui	$sp, $sp, 1
	sw	$4, 0($sp)

	# Get the parameter
	lw	$4, 1($sp)

	# Test for >= 32
	sgei	$1, $4, 32
	# Test for < 127
	slti	$4, $4, 127
	# We want both of these
	and	$1, $1, $4
	
	# Restore the register
	lw	$4, 0($sp)
	addui	$sp, $sp, 1
	
	# Return
	jr	$ra

# int isspace(char c)
# returns 1 if c is a whitespace character
isspace:
	subui	$sp, $sp, 1
	sw	$4, 0($sp)
	
	# Get the parameter
	lw	$4, 1($sp)
	seqi	$1, $4, 32	# c == ' '
	bnez	$1, isspace_return

	slei	$1, $4, 13
	sgei	$4, $4, 9
	and	$1, $1, $4
isspace_return:

	lw	$4, 0($sp)
	addui	$sp, $sp, 1
	
	jr	$ra
	


# char tolower(char c)
# returns the lower case version of c
tolower:
	subui	$sp, $sp, 1
	sw	$4, 0($sp)

	# Get the parameter
	lw	$4, 1($sp)

	slti	$1, $4, 'A'
	bnez	$1, tolower_not_upcase
	
	sgti	$1, $4, 'Z'
	bnez	$1, tolower_not_upcase
	
	addui	$4, $4, 32
tolower_not_upcase:

	addu	$1, $4, $0

	lw	$4, 0($sp)
	addui	$sp, $sp, 1

	jr	$ra

# int a_con_bin(char c)
# Convert a character to its binary representation
a_con_bin:
	subui	$sp, $sp, 6
	sw	$4, 4($sp)
	sw	$ra, 5($sp)
	
	# Get the parameter
	lw	$4, 6($sp)

	# Convert to lowercase
	sw	$4, 0($sp)
	jal	tolower
	addu	$4, $1, $0

	sw	$4, 0($sp)
	jal	isdigit

	beqz	$1, a_con_bin_not_digit

	subi	$1, $4, '0'

	j	a_con_bin_return
a_con_bin_not_digit:	

	sw	$4, 0($sp)
	jal	ishex

	beqz	$1, a_con_bin_not_hex

	subi	$1, $4, 87	# return (c - 'a' + 10)

	j	a_con_bin_return
a_con_bin_not_hex:

	addui	$1, $0, 10000
	
a_con_bin_return:	
	
	lw	$4, 4($sp)
	lw	$ra, 5($sp)
	addui	$sp, $sp, 6

	jr	$ra

.data
debug:	.asciiz	"(%08x)"
.text
# char *atoui(char *str, u_int *ptrnum, u_int base)
# convert an ASCII string to a unsigned number in base.
atoui:
	subui	$sp, $sp, 11
	sw	$4, 4($sp)
	sw	$5, 5($sp)
	sw	$6, 6($sp)
	sw	$7, 7($sp)	# next_nib
	sw	$8, 8($sp)	# accum
	sw	$9, 9($sp)	# max_accum
	sw	$ra, 10($sp)

	lw	$4, 11($sp)	# char *str
	lw	$5, 12($sp)	# u_int *ptrnum
	lw	$6, 13($sp)	# u_int base

	# max_accum = -1 / base
	subi	$1, $0, 1
	divu	$9, $1, $6
	
	# *ptrnum = 0
	sw	$0, 0($5)
	
	# accum = 0
	addu	$8, $0, $0

	# while ((next_nib = a_con_bin(*str)) < base)
atoui_loop:
	lw	$1, 0($4)
	sw	$1, 0($sp)
	jal	a_con_bin
	addu	$7, $1, $0
	sltu	$1, $7, $6
	beqz	$1, atoui_done

	# if (accum > max_accum)
	sgtu	$1, $8, $9
	bnez	$1, atoui_overflow

	# tmp = (accum * base) + next_nib
	multu	$1, $8, $6
	addu	$1, $1, $7

	
	# if (tmp < accum)
	sltu	$7, $1, $8
	bnez	$7, atoui_overflow

	# accum = tmp
	addu	$8, $1, $0

	# str++
	addui	$4, $4, 1

	j	atoui_loop
atoui_overflow:
.data
overflow_msg:	
	.asciiz	"Integer Overflow\n"
.text
	la	$1, overflow_msg
	sw	$1, 0($sp)
	jal	printf

atoui_done:	
	# *ptrnum = accum
	sw	$8, 0($5)

	# return (str)
	addu	$1, $4, $0
	
	lw	$4, 4($sp)
	lw	$5, 5($sp)
	lw	$6, 6($sp)
	lw	$7, 7($sp)
	lw	$8, 8($sp)
	lw	$9, 9($sp)
	lw	$ra, 10($sp)
	addui	$sp, $sp, 11

	jr	$ra


# char *atob(char *str, u_int *ptrnum, u_int base)
# Convert an ASCII string to a number
atob:	
	subui	$sp, $sp, 12
	sw	$4, 4($sp)
	sw	$5, 5($sp)
	sw	$6, 6($sp)
	sw	$7, 7($sp)
	sw	$8, 8($sp)	# minus
	sw	$9, 9($sp)
	sw	$10, 10($sp)	# end_str
	sw	$ra, 11($sp)

	lw	$4, 12($sp)	# char *str
	lw	$5, 13($sp)	# u_int *ptrnum
	lw	$6, 14($sp)	# u_int base

.bss
num:	.word
.text
	# num = 0
	sw	$0, num($0)

	# while (isspace(*str))
atob_leading_whitespace:
	lw	$1, 0($4)
	sw	$1, 0($sp)
	jal	isspace
	beqz	$1, atob_check_minus

	addui	$4, $4, 1
	j	atob_leading_whitespace
atob_check_minus:
	# if (*str == '-')
	#  minus = 1, str++
	# else
	# minus = 0
	lw	$1, 0($4)
	seqi	$8, $1, '-'
	addu	$4, $4, $8

	# if (*str == '0')
	lw	$1, 0($4)
	seqi	$1, $1, '0'
	beqz	$1, atob_else

	# switch (*++str)
	addui	$4, $4, 1
	lw	$7, 0($4)
	
	seqi	$1, $7, 'x'
	seqi	$9, $7, 'X'
	or	$1, $1, $9
	beqz	$1, atob_check_octal

	# ++str
	addui	$4, $4, 1
	sw	$4, 0($sp)
	la	$1, num
	sw	$1, 1($sp)
	addui	$1, $0, 16
	sw	$1, 2($sp)
	jal	atoui
	addu	$10, $1, $0

	j	atob_break
	
atob_check_octal:	
	seqi	$1, $7, 'o'
	seqi	$9, $7, 'O'
	or	$1, $1, $9
	beqz	$1, atob_check_decimal

	# ++str
	addui	$4, $4, 1
	sw	$4, 0($sp)
	la	$1, num
	sw	$1, 1($sp)
	addui	$1, $0, 8
	sw	$1, 2($sp)
	jal	atoui
	addu	$10, $1, $0

	j	atob_break

atob_check_decimal:	
	seqi	$1, $7, 'd'
	seqi	$9, $7, 'D'
	or	$1, $1, $9
	beqz	$1, atob_default_case

	# ++str
	addui	$4, $4, 1
	sw	$4, 0($sp)
	la	$1, num
	sw	$1, 1($sp)
	addui	$1, $0, 10
	sw	$1, 2($sp)
	jal	atoui
	addu	$10, $1, $0

	j	atob_break

atob_default_case:
	# str--
	subui	$4, $4, 1
	
atob_else:	
	sw	$4, 0($sp)
	la	$1, num
	sw	$1, 1($sp)
	sw	$6, 2($sp)
	jal	atoui
	addu	$10, $1, $0

atob_break:

	# if ((minus) && num < 0)
	lw	$1, num($0)
	slt	$1, $1, $0
	and	$1, $1, $8
	beqz	$1, atob_not_overflow

.data
signed_overflow_msg:
	.asciiz	"Signed Overflow\n"
.text
	
	la	$1, signed_overflow_msg
	sw	$1, 0($sp)
	jal	printf

	j	atob_return
atob_not_overflow:	

	# else if (minus)
	beqz	$8, atob_return
	lw	$1, num($0)
	sub	$1, $0, $1
	sw	$1, num($0)
	
atob_return:
	# *ptrnum = num
	lw	$1, num($0)
	sw	$1, 0($5)

	# return(end_str)
	addu	$1, $10, $0
	
	lw	$4, 4($sp)
	lw	$5, 5($sp)
	lw	$6, 6($sp)
	lw	$7, 7($sp)
	lw	$8, 8($sp)
	lw	$9, 9($sp)
	lw	$10, 10($sp)
	lw	$ra, 11($sp)
	addui	$sp, $sp, 12

	jr	$ra
	
# void putchar(char c)
# Output the character c to the main serial port
.data
column:	.word	0
.text
putchar:
	# Save some registers
	subui	$sp, $sp, 7
	sw	$4, 4($sp)
	sw	$5, 5($sp)
	sw	$ra, 6($sp)

	# Get the parameter
	lw	$4, 7($sp)

	# Test for newline
	seqi	$1, $4, '\n'
	beqz	$1, putchar_not_newline

	# putchar('\r')	
	addui	$1, $0, '\r'
	sw	$1, 0($sp)
	jal	putchar
	
	# column = 0
	sw	$0, column($0)
	
	j	putchar_case_end
putchar_not_newline:	
	# Test for tab
	seqi	$1, $4, '\t'
	beqz	$1, putchar_default

putchar_do_loop:
	# putchar(' ')
	addui	$1, $0, 32 # ' ' Should make this work
	sw	$1, 0($sp)
	jal	putchar

	# column % 8
	lw	$1, column($0)

	remui	$1, $1, 8
	
	# while (column % 8)
	bnez	$1, putchar_do_loop

	j	putchar_return
	
putchar_default:	
	# isprint(c)
	sw	$4, 0($sp)
	jal	isprint

	# if (...) column++
	lw	$5, column($0)
	addu	$5, $5, $1
	sw	$5, column($0)

putchar_case_end:	
	sw	$4, 0($sp)
	jal	send_char
	
putchar_return:
	# Restore the registers
	lw	$4, 4($sp)
	lw	$5, 5($sp)
	lw	$ra, 6($sp)
	addui	$sp, $sp, 7

	# Return
	jr	$ra


# void printf(char *fmt, ...)
# Print the string as given by the format specifier
.bss

__fmt:	.word	# char *__fmt
__ptrbf:
	.word	# char *__ptrbf

buf:	.space	30	# char buf[30]
c:	.word	# char c
base:	.word	# int base
s:	.word	# char *s
adj:	.word	# char adj
argcount:
	.word	# int argcount
x:	.word	# int x
n:	.word	# int n
m:	.word	# int m
width:	.word	# long width
padchar:
	.word	# char padchar
charset:
	.word	# long charset
.text
printf:
	# Save some registers
	subui	$sp, $sp, 12
	sw	$2, 4($sp)
	sw	$3, 5($sp)
	sw	$4, 6($sp)
	sw	$5, 7($sp)
	sw	$6, 8($sp)
	sw	$7, 9($sp)
	sw	$8, 10($sp)
	sw	$ra, 11($sp)

	# Get the format specifier
	lw	$2, 12($sp) # get fmt
	addui	$7, $sp, 13	# Get the offset of the first argument
	
	
	# argcount = 0
	sw	$0, argcount($0)
	# charset = 0
	sw	$0, charset($0)
	# _ptrbf = buf
	la	$8, buf
		
printf_nextchar:
	# Get the next format character
	lw	$3, 0($2)
	# Increment the pointer
	addui	$2, $2, 1

	# Exit if null character
	beqz	$3, printf_return

	# Test for the % character
	seqi	$1, $3, '%'
	beqz	$1, printf_normalchar

	# adj = 'r'
	addui	$1, $0, 'r'
	sw	$1, adj($0)

	# if (*__fmt == '-')
	lw	$3, 0($2)
	seqi	$1, $3, '-'
	beqz	$1, printf_padchar

	# adj = 'l'
	addui	$1, $0, 'l'
	sw	$1, adj($0)
	# __fmt++
	addui	$2, $2, 1

printf_padchar:
	# padchar = ' '
	addui	$1, $0, 32    # ' '  Again
	sw	$1, padchar($0)
	
	# if (*__fmt == '0')
	lw	$3, 0($2)
	seqi	$1, $3, '0'
	beqz	$1, printf_width

	# padchar = '0'
	sw	$3, padchar($0)
printf_width:
	# width = __conv()
	sw	$2, __fmt($0)
	jal	__conv
	sw	$1, width($0)
	lw	$2, __fmt($0)

	# s = 0
	sw	$0, s($0)
	
	# switch (c = *__fmt++)
	lw	$3, 0($2)
	addui	$2, $2, 1
	sw	$3, c($0)	

	# Test for 'd' or 'D' or 'u'
	seqi	$4, $3, 'D'
	seqi	$5, $3, 'd'
	seqi	$6, $3, 'u'
	or	$5, $5, $6
	or	$4, $4, $5
	beqz	$4, printf_octal

	# base = 10
	addui	$1, $0, 10
	sw	$1, base($0)
	
	j	printf_output
printf_octal:	

	# Test for 'o' or 'O'
	seqi	$4, $3, 'o'
	seqi	$5, $3, 'O'
	or	$4, $4, $5
	beqz	$4, printf_hexadecimal

	# base = 8
	addui	$1, $0, 8
	sw	$1, base($0)

	j	printf_output
printf_hexadecimal:

	# Test for 'X'
	seqi	$4, $3, 'X'
	seqi	$5, $3, 'x'
	bnez	$5, printf_lowercase_hex
	beqz	$4, printf_string
	
	# charset = 1
	addui	$1, $0, 1
	sw	$1, charset($0)
printf_lowercase_hex:
	# base = 16
	addui	$1, $0, 16
	sw	$1, base($0)

	j	printf_output
	
printf_string:	
	# Test for 's' or 'S'
	seqi	$4, $3, 's'
	seqi	$5, $3, 'S'
	or	$4, $4, $5
	beqz	$4, printf_character

	# s = *argptr
	lw	$1, 0($7)
	sw	$1, s($0)
	addui	$7, $7, 1
	# argcount++
	lw	$1, argcount($0)
	addui	$1, $1, 1
	sw	$1, argcount($0)
	
	j	printf_output
printf_character:	
	# Test for 'c' or 'C'
	seqi	$4, $3, 'c'
	seqi	$5, $3, 'C'
	or	$4, $4, $5
	beqz	$4, printf_default

	# x = *argptr
	lw	$4, 0($7)
	sw	$4, x($0)
	addui	$7, $7, 1
	# argcount++
	lw	$1, argcount($0)
	addui	$1, $1, 1
	sw	$1, argcount($0)

	# *__ptrbf++ = x & 0xff
	andi	$1, $4, 0xff
	sw	$1, 0($8)
	addui	$8, $8, 1
	# *__ptrbf = 0
	sw	$0, 0($8)
	
	# s = buf
	la	$1, buf
	sw	$1, s($0)
		
	j	printf_output

printf_default:
	# *__ptrbf++ = c
	andi	$1, $3, 0xff
	sw	$1, 0($8)
	addui	$8, $8, 1
	# *__ptrbf = 0
	sw	$0, 0($8)
	
	# s = buf
	la	$1, buf
	sw	$1, s($0)

printf_output:
	# if (s == 0)
	lw	$1, s($0)
	bnez	$1, printf_get_strlen

	# x = *argptr
	lw	$4, 0($7)
	sw	$4, x($0)
	addui	$7, $7, 1
	
	# argcount++
	lw	$1, argcount($0)
	addui	$1, $1, 1
	sw	$1, argcount($0)

	# prtn(base, x, charset)

	sw	$8, __ptrbf($0)
	lw	$1, base($0)
	sw	$1, 0($sp)
	lw	$1, x($0)
	sw	$1, 1($sp)
	lw	$1, charset($0)
	sw	$1, 2($sp)
	jal	prtn
	lw	$8, __ptrbf($0)
	
	# *__ptrbf = 0
	sw	$0, 0($8)
	
	# s = buf
	la	$1, buf
	sw	$1, s($0)
	
	# charset = 0
	sw	$0, charset($0)
	
printf_get_strlen:	
	# n = strlen(s)
	sw	$1, 0($sp)
	jal	strlen
	sw	$1, n($0)

	# m = width - n
	lw	$4, width($0)
	sub	$4, $4, $1
	sw	$4, m($0)

	# if (adj == 'r')
	lw	$1, adj($0)
	seqi	$1, $1, 'r'
	beqz	$1, printf_do_output

	# while (m-- > 0)
printf_right_pad:	
	subi	$4, $4, 1
	sge	$1, $4, $0
	beqz	$1, printf_do_output

	# Print pad character
	lw	$1, padchar($0)
	sw	$1, 0($sp)
	jal	putchar

	# Loop
	j	printf_right_pad
	
printf_do_output:

	# while (n--)
	lw	$5, n($0)
printf_output_next:
	subi	$5, $5, 1
	slt	$1, $5, $0
	bnez	$1, printf_left_pad

	# putchar(*s++)
	lw	$1, s($0)
	lw	$6, 0($1)
	sw	$6, 0($sp)
	addui	$1, $1, 1
	sw	$1, s($0)
	jal	putchar

	# Loop
	j	printf_output_next

printf_left_pad:

	# while (m-- > 0)
	subi	$4, $4, 1
	sge	$1, $4, $0
	beqz	$1, printf_reset_buffer

	# Print pad character
	lw	$1, padchar($0)
	sw	$1, 0($sp)
	jal	putchar

	# Loop
	j	printf_left_pad
printf_reset_buffer:
	la	$8, buf
	sw	$8, __ptrbf($0)

	# Next iteration of the while loop
	j	printf_nextchar
			
printf_normalchar:
	# Print this character
	sw	$3, 0($sp)
	jal	putchar
	# Loop
	j	printf_nextchar

printf_return:
	# Restore the registers
	lw	$2, 4($sp)
	lw	$3, 5($sp)
	lw	$4, 6($sp)
	lw	$5, 7($sp)
	lw	$6, 8($sp)
	lw	$7, 9($sp)
	lw	$8, 10($sp)
	lw	$ra, 11($sp)
	addui	$sp, $sp, 12
	
	# Return
	jr	$ra
	
# long __conv()
# Returns the value of a decimal ascii string
__conv:
	subui	$sp, $sp, 7
	sw	$4, 4($sp)
	sw	$5, 5($sp)
	sw	$ra, 6($sp)

	# n = 0
	addu	$4, $0, $0
__conv_loop:	
	# c = *__fmt++
	lw	$1, __fmt($0)
	lw	$5, 0($1)
	addui	$1, $1, 1
	sw	$1, __fmt($0)

	slti	$1, $5, '0'
	bnez	$1, __conv_done
	sgti	$1, $5, '9'
	bnez	$1, __conv_done

	# compute n * 10
#	sw	$4, 0($sp)
#	addui	$1, $0, 10
#	sw	$1, 1($sp)
#	jal	multiply

	multui	$4, $4, 10
#	addu	$4, $1, $0

	# compute c - '0'
	subui	$5, $5, '0'
	# n = (n * 10) + (c - '0')
	addu	$4, $4, $5

	j	__conv_loop
	
__conv_done:
	lw	$1, __fmt($0)
	subi	$1, $1, 1
	sw	$1, __fmt($0)

	# Get the return value in $1	
	addu	$1, $4, $0
	
	lw	$4, 4($sp)
	lw	$5, 5($sp)
	lw	$ra, 6($sp)
	addui	$sp, $sp, 7

	jr	$ra
	
# void prtn(int base, unsigned int x, int cset)
# convert an integer to an ascii string
.bss
tmpbuf:	.space	16
.data
lc_digits:
	.asciiz	"0123456789abcdef"
uc_digits:
	.asciiz	"0123456789ABCDEF"
.text
prtn:
	subui	$sp, $sp, 10
	sw	$4, 4($sp)
	sw	$5, 5($sp)
	sw	$6, 6($sp)
	sw	$7, 7($sp)
	sw	$8, 8($sp)
	sw	$ra, 9($sp)

	lw	$4, 10($sp)	# Get the first parameter
	lw	$5, 11($sp)
	lw	$6, 12($sp)

	# cptr = tmpbuf
	la	$7, tmpbuf
prtn_divide_loop:
	# Compute x % base
	remu	$1, $5, $4
	
	# Get the address of the digit set to use
	la	$8, lc_digits
	beqz	$6, prtn_lower_case

	la	$8, uc_digits
	
prtn_lower_case:
	# Index into the array
	addu	$8, $8, $1
	# Get the character
	lw	$8, 0($8)
	# Store it into our buffer
	sw	$8, 0($7)
	# cptr++
	addui	$7, $7, 1

	# x /= b
	divu	$5, $5, $4

	bnez	$5, prtn_divide_loop

	lw	$8, __ptrbf($0)

	la	$5, tmpbuf
prtn_reverse_loop:
	# --cptr
	subi	$7, $7, 1
	lw	$1, 0($7)
	sw	$1, 0($8)
	addui	$8, $8, 1

	sgt	$1, $7, $5
	bnez	$1, prtn_reverse_loop

	sw	$8, __ptrbf($0)

	lw	$4, 4($sp)
	lw	$5, 5($sp)
	lw	$6, 6($sp)
	lw	$7, 7($sp)
	lw	$8, 8($sp)
	lw	$ra, 9($sp)
	addui	$sp, $sp, 10

	jr	$ra
	



# char *get_a_str(char *buf, char *bufp)
# Read a string from the terminal
get_a_str:
	subui	$sp, $sp, 9
	sw	$2, 4($sp)
	sw	$4, 5($sp)
	sw	$5, 6($sp)
	sw	$6, 7($sp)
	sw	$ra, 8($sp)

	lw	$5, 9($sp)	# buf
	lw	$6, 10($sp)	# bufp
	
get_a_str_loop:
	# c = getchar()
	jal	read_char
	addu	$4, $1, $0

	seqi	$1, $4, '\n'
	seqi	$2, $4, '\r'
	or	$1, $1, $2
	beqz	$1, get_a_str_not_newline

	# putchar('\n')
	addui	$1, $0, '\n'
	sw	$1, 0($sp)
	jal	putchar

	# *bufp = 0
	sw	$0, 0($6)

	# return(buf)
	addu	$1, $5, $0
	j	get_a_str_return
get_a_str_not_newline:	
	seqi	$1, $4, 0x8	# CTRL-H
	seqi	$2, $4, 0x7f	# DEL
	or	$1, $1, $2
	beqz	$1, get_a_str_not_delete

	# if (bufp > buf)
	sgt	$1, $6, $5
	beqz	$1, get_a_str_loop

	# bufp--
	subi	$6, $6, 1
	# putchar(CTRL-H)
	addui	$1, $0, 0x8
	sw	$1, 0($sp)
	jal	putchar
	# putchar(' ')
	addui	$1, $0, 32	# ' '
	sw	$1, 0($sp)
	jal	putchar
	# putchar(CTRL-H)
	addui	$1, $0, 0x8
	sw	$1, 0($sp)
	jal	putchar
	
	j	get_a_str_loop

get_a_str_not_delete:

	seqi	$1, $4, '\t'
	beqz	$1, get_a_str_not_tab

	addui	$4, $0, 32	# ' '

get_a_str_not_tab:

	sw	$4, 0($sp)
	jal	isprint

	# Compute &buf[LINESIZE-3]
	addui	$2, $5, 125
	slt	$2, $6, $2
	and	$1, $1, $2

	beqz	$1, get_a_str_no_room

	# *bufp++ = c
	sw	$4, 0($6)
	addui	$6, $6, 1

	# putchar(c)
	sw	$4, 0($sp)
	jal	putchar
	
	j	get_a_str_loop
get_a_str_no_room:

	# putchar(BELL)
	addui	$1, $0, 7	# Bell
	sw	$1, 0($sp)
	jal	putchar

	j	get_a_str_loop

get_a_str_return:

	lw	$2, 4($sp)
	lw	$4, 5($sp)
	lw	$5, 6($sp)
	lw	$6, 7($sp)
	lw	$ra, 8($sp)
	addui	$sp, $sp, 9

	jr	$ra

	
# char *gets(char *buf)
# Get a string from the user
gets:
	subui	$sp, $sp, 5
	sw	$ra, 4($sp)

	lw	$1, 5($sp)
	sw	$1, 0($sp)
	sw	$1, 1($sp)
	jal	get_a_str

	lw	$ra, 4($sp)
	addui	$sp, $sp, 5

	jr	$ra



# char *gets_noecho(char *buf)
# Read a string from the terminal without echo
gets_noecho:
	subui	$sp, $sp, 9
	sw	$2, 4($sp)
	sw	$4, 5($sp)
	sw	$5, 6($sp)
	sw	$6, 7($sp)
	sw	$ra, 8($sp)

	lw	$5, 9($sp)	# buf
	lw	$6, 9($sp)	# bufp
	
gets_noecho_loop:
	# c = getchar()
	jal	read_char
	addu	$4, $1, $0

	seqi	$1, $4, '\n'
	seqi	$2, $4, '\r'
	or	$1, $1, $2
	beqz	$1, gets_noecho_not_newline

	# *bufp = 0
	sw	$0, 0($6)

	# return(buf)
	addu	$1, $5, $0
	j	gets_noecho_return
gets_noecho_not_newline:	
	sw	$4, 0($sp)
	jal	isprint

	# Compute &buf[LINESIZE-3]
	addui	$2, $5, 125
	slt	$2, $6, $2
	and	$1, $1, $2

	beqz	$1, gets_noecho_return

	# *bufp++ = c
	sw	$4, 0($6)
	addui	$6, $6, 1
	
	j	gets_noecho_loop

gets_noecho_return:

	lw	$2, 4($sp)
	lw	$4, 5($sp)
	lw	$5, 6($sp)
	lw	$6, 7($sp)
	lw	$ra, 8($sp)
	addui	$sp, $sp, 9

	jr	$ra





