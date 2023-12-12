.global main

.align 4
.section .rodata
output:  .asciz  "Your values are %d, %d, %d, %d, %d, and %d\n"

.align 4
.text
main:
	push {lr}
        ldr R0, =output
        mov R1, #10
        mov R2, #23
        mov R3, #17
        mov R4, #30
        mov R5, #45
        mov R6, #33
        push { R4-R6 }
        bl printf
        add sp, sp, #12
	pop {pc}
