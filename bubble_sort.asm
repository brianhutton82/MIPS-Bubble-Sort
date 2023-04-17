# ----- PRINT STRING MACRO ----- #
.macro print_str %str
	.data
		msg: .asciiz %str
	.text
		la a0, msg
		li v0, 4
		syscall
.end_macro


# ----- GLOBAL CONSTANTS ----- #
.eqv SIZE 5
.eqv LAST_INDEX 4

# ----- GLOBAL VARIABLES ----- #
.data
	arr: .byte 0 0 0 0 0


# ----- MAIN FUNCTION ----- #
.text
.globl main
main:
	jal print_arr
	jal print_newline
	jal pop_arr
	jal print_newline
	jal print_arr
	jal bubble_sort
	jal print_arr
	jal print_newline
	jal exit


# ----- PRINT ARRAY FUNCTION ----- #
print_arr:
	push ra
	push s0
	print_str "arr: {"
	la t0, arr
	li s0, 0
	_loop:
		add t1, t0, s0
		lb a0, (t1)
		li v0, 1
		syscall
		beq s0, LAST_INDEX, _skip
		print_str ", "
		_skip:
		add s0, s0, 1
		blt s0, SIZE, _loop
	print_str "}\n"
	pop s0
	pop ra
	jr ra


# ----- POPULATE FUNCTION ----- #
pop_arr:
	push ra
	push s0
	li s0, 0
	la t0, arr
	_loop:
		add t1, t0, s0
		print_str "enter a number: "
		li v0, 5
		syscall
		sb v0, (t1)
		add s0, s0, 1
		blt s0, SIZE, _loop
	pop s0
	pop ra
	jr ra


# ----- SORT ARRAY FUNCTION ----- #
sort_arr:
	push ra
	push s0
	push s1
	li s0, 0
	li s1, 1
	la t0, arr
	_loop:
		add t1, t0, s0
		add t2, t0, s1
		lb t3, (t1)
		lb t4, (t2)
		bgt t4, t3, _skip_swap
			sb t4, (t1)
			sb t3, (t2)
		_skip_swap:
		add s0, s0, 1
		add s1, s1, 1
		ble s1, LAST_INDEX, _loop
	pop s1
	pop s0
	pop ra
	jr ra


# ----- BUBBLE SORT ----- #
bubble_sort:
	push ra
	push s0
	push s1
	
	li s0, 0
	la s1, arr
	_loop:
		jal sort_arr
		add s0, s0, 1
		blt s0, SIZE, _loop
	pop s1
	pop s0
	pop ra
	jr ra


# ----- PRINT NEWLINE FUNCTION ----- #
print_newline:
	push ra
	li a0, '\n'
	li v0, 11
	syscall	
	pop ra
	jr ra


# ----- EXIT FUNCTION ----- #
exit:
	print_str "----- GOODBYE! -----\n"
	li v0, 10
	syscall