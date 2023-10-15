.global main

.align 4
.section .rodata
prompt: .asciz "Please enter two signed integers: "
response: .asciz "\nYou entered %d and %d from the keyboard, now some operations on those values!\n\n"
responseA: .asciz "        Sum of %d and %d is %d\n"
responseM: .asciz "    Product of %d and %d is %d\n"
responseAND: .asciz "Logical AND of %d and %d is %d\n"
responseOR: .asciz  " Logical OR of %d and %d is %d\n"
scanner: .asciz "%d %d"

.align 4
.data
value1: .word 0
value2: .word 0

.section .text
main:
	push {lr}
	ldr r4, =value1
	ldr r5, =value2
	ldr r0, =prompt
	bl printf


	ldr r0, =scanner
	mov r1, r4
	mov r2, r5
	bl scanf

	ldr r0, =response
	ldr r1, [r4]
	ldr r2, [r5]
	bl printf

	ldr r0, =responseA
	ldr r1, [r4]
	ldr r2, [r5]
	adds r3, r1, r2
	bl printf

	ldr r0, =responseM
	ldr r1, [r4]
	ldr r2, [r5]
	mul r3, r1, r2
	bl printf

	ldr r0, =responseAND
	ldr r1, [r4]
	ldr r2, [r5]
	and r3, r1, r2
	bl printf

	ldr r0, =responseOR
	ldr r1, [r4]
	ldr r2, [r5]
	orr r3, r1, r2
	bl printf
	mov r0, #0
	pop {pc}
