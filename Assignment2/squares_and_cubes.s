.global main

.align 4
.section .rodata
prompt:         .asciz "Enter largest integer to display in chart (range of valid values: 1 to 25): "
scnstr:         .asciz "%u"
errorm:         .asciz "ERROR - Input must be between 1 and 25...\n"
newlin:         .asciz "\n"

header1:        .asciz "            Number    Number\n"
header2:        .asciz "  Number    Squared   Cubed\n"

dashes:         .asciz "------------------------------\n"
output1:        .asciz "%8u   %8u   %8u\n"
output2:        .asciz "    Sums   %8u   %8u\n"


.align 4
.section .data

value: .word 0

.align 4
.text
main:
  push {lr}

  ldr r5, =value //Maximum Number
  mov r4, #1 //Loop Counter
  mov r6, #0 //Sum of Squares
  mov r7, #0 //Sum of Cubes

do_r5_lo_1_OR_r5_hi_25:
  //Print Input Prompt
  ldr r0, =prompt
  bl printf
  
  ldr r0, =scnstr
  mov r1, r5
  bl scanf

  //Check if we need to print error message and branch
  ldr r1, [r5]
  cmp r1, #1
  blo print_error

  cmp r1, #25
  bhi print_error

  //Print Table Header
  ldr r0, =newlin
  bl printf
  ldr r0, =header1
  bl printf
  ldr r0, =header2
  bl printf
  ldr r0, =dashes
  bl printf

  ldr r5, [r5]
  //Print the Table
while_r4_ls_r5:
  cmp r4, r5
  bhi exit_while_r4_ls_r5

  mov r1, r4
  mul r2, r1, r1
  mul r3, r1, r1
  mul r3, r2, r1

  add r6, r6, r2
  add r7, r7, r3

  ldr r0, =output1
  bl printf


  add r4, r4, #1
  b while_r4_ls_r5

exit_while_r4_ls_r5:
  //Return 0 and Exit The Program
  ldr r0, =dashes
  bl printf
  ldr r0, =output2
  mov r1, r6
  mov r2, r7
  bl printf
  mov r0, #0
  pop {pc}

print_error: 
  ldr r0, =errorm
  bl printf
  b do_r5_lo_1_OR_r5_hi_25

