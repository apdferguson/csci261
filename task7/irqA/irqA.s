	;============================================-=
	; File:
	       .file "irqA.s" 
	; Behaviour: 
	;      Store in COUNT the  number of IRQs interrupts generated.
	; Assumptions:
	;      none
	; Board:
	;      CME11-E9-EVBU (with the PW link HACK)
	; Author:
	;      Peter Walsh
	;============================================-=
	  set irqBar, 0x00ee
	  set irqJmp, 0x7e
	  set irqSR, 0x00ef
  ;----------------------------------------------
	;            Text Section (code)
	;----------------------------------------------
	.sect .text
	.global _start

	;---------------------------------------------
	; Behaviour: 
	;    Interrupt Service Routine
	;    Store in COUNT the number of times this routine is invoked.
	; Assumptions:
	;    none
	; Restriction:
	;    none
	; Register and Memory Usage:
	;    Precondition:
	;    Postcondition:
	;       COUNT is incremented by 1
	;    Destroys:
  ;       none
  ; Author : Peter Walsh
  ; Modified by Aidan Ferguson to setupt jump table inside main
  ; of bats.script - Nov, 2018
	;---------------------------------------------
	irqCount:
	               ldaa COUNT
	               inca
	               staa COUNT
	xirqCount:     rti

	_start: 
	               lds #_stack    ; initialize SP
                 ldx #irqCount
                 stx irqSR
                 ldaa #irqJmp
                 staa irqBar
	               cli
	loop:	       jmp loop
	;-----------------------------------------
	;         Data Area

	;-----------------------------------------
	COUNT: .byte  0

	#set up dummy frame pointer
	.global _.frame
	_.frame: .word


	.end
