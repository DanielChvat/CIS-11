.global main
.equ LOW, 0
.equ HIGH, 1
.equ INPUT, 0
.equ OUTPUT, 1
.equ WALK_BUTTON, 1
.equ END_BUTTON, 4
.equ STREET_GREEN_LED, 25
.equ STREET_YELLOW_LED, 24
.equ STREET_RED_LED, 23
.equ WALK_GREEN_LED, 22
.equ WALK_RED_LED, 21

.align 4
.section .text

my_delay:
	push {r4, r5, lr}
	mov r4, r0 // R4 is number of seconds to delay
	mov r0, #0
	bl time
	mov r5, r0 // R5 is beginning number of seconds from January 1 1970
do_while_r0_lt_r5:
	mov r0, #END_BUTTON
	bl digitalRead
	cmp r0, #HIGH
	bleq reset_state
	moveq r0, #0
	bleq exit

	mov r0, #0
	bl time
	sub r0, r0, r5

	cmp r0, r4
	bge end_do_while_r0_lt_r5
	bal do_while_r0_lt_r5
end_do_while_r0_lt_r5:
	pop {r4, r5, pc}

initialize_pins:
	push {lr}
	bl wiringPiSetup

	mov r0, #STREET_GREEN_LED
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #STREET_YELLOW_LED
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #STREET_RED_LED
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #WALK_GREEN_LED
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #WALK_RED_LED
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #WALK_BUTTON
	mov r1, #INPUT
	bl pinMode

	mov r0, #END_BUTTON
	mov r1, #INPUT
	bl pinMode
	pop {pc}

//Ensure No LEDS Are On
reset_state:
	push {lr}

	mov r0, #STREET_GREEN_LED
	mov r1, #LOW
	bl digitalWrite

	mov r0, #STREET_YELLOW_LED
	mov r1, #LOW
	bl digitalWrite

	mov r0, #STREET_RED_LED
	mov r1, #LOW
	bl digitalWrite

	mov r0, #WALK_GREEN_LED
	mov r1, #LOW
	bl digitalWrite

	mov r0, #WALK_RED_LED
	mov r1, #LOW
	bl digitalWrite
	pop {pc}

set_traffic_state:
	push {lr}
	bl reset_state

	mov r0, #STREET_GREEN_LED
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #WALK_RED_LED
	mov r1, #HIGH
	bl digitalWrite
	pop {pc}

set_walk_state:
	push {lr}
	bl reset_state

	mov r0, #STREET_RED_LED
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #WALK_GREEN_LED
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #10
	bl my_delay

	bl end_walk_flash
	pop {pc}

end_walk_flash:
	push {r4, lr}
	mov r4, #0
while_r4_lt_10:
	cmp r4, #5
	bge end_while_r4_lt_10

	mov r0, #1
	bl my_delay

	mov r0, #STREET_GREEN_LED
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #STREET_YELLOW_LED
	mov r1, #HIGH
	bl digitalWrite

	mov r0, #1
	bl my_delay

	mov r0, #STREET_GREEN_LED
	mov r1, #LOW
	bl digitalWrite

	mov r0, #STREET_YELLOW_LED
	mov r1, #LOW
	bl digitalWrite

	add r4, #1
	bal while_r4_lt_10
end_while_r4_lt_10:
	pop {r4, pc}

main:
	push {lr}
	bl initialize_pins
	bl set_traffic_state

while_loop:
	mov r0, #END_BUTTON
	bl digitalRead
	cmp r0, #HIGH
	beq end_while_loop

	mov r0, #WALK_BUTTON
	bl digitalRead
	cmp r0, #HIGH
	bleq set_walk_state
	bl set_traffic_state
	bal while_loop

end_while_loop:
	bl reset_state
	mov r0, #0
	pop {pc}
