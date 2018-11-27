;============================================-=
; File:
       .file "wave.s" 
; Behaviour: 
;      Generates a 1KHz square wave with a 30% duty cycle on PA6
;      using interupts to advantage  
; Assumptions:
;      none
; Board:
;      CME11-E9-EVBU
; Author/Date:
;      Peter Walsh 2002
;      Modified to use interupts by Aidan Ferguson Nov,2018 
;      
;==========================================-=

;----------------------------------------------
;            Text Section (code and data)
;----------------------------------------------
.sect .text 
.global _start

set regbase, 0x1000
set porta, 0x0
set tcnt, 0x0e
set tflg1, 0x23
set tmsk1, 0x22
set tctl1, 0x20
set toc2, 0x18

set highTicks, 600             ; 300 us
set lowTicks, 1400             ; 700 us

set toggle, 0x40
set oc2, 0x40
set clear, 0x40
set oc2T, 0x00dc                ;beginning of interupt jump table
set Jump, 0x7e                  ;Jump command
set oc2Sr, 0x00dd               ;subroutine location in jump table



_start:
  sei                           ;disable interupts
  lds #_stack

	ldx #tickCheck                ;set up jumptable
  stx oc2Sr                     ;""
  ldaa #Jump                    ;""
  staa oc2T                     ;""

  ldx #regbase                  

  bset porta,x oc2             
  ldaa #toggle
  staa tctl1,x

  bset tmsk1,x oc2              ;set up clock interupt

  ldd tcnt,x
  addd #highTicks
  std toc2,x

  ldaa #clear
  staa tflg1,x


  cli                           ;renable interupts


mainloop: jmp mainloop

tickCheck:                      ;Interupt Sub Routine,checks to see if the previous tick was low or high
	  ldaa LorH
	  adda control
	  beq high
	  


low:                            
	  ldaa #clear
	  staa tflg1,x
	  ldd toc2,x
	  addd #highTicks
	  std toc2,x

	  ldaa control                ;set up for next tickcheck
	  staa LorH
    bra cleanup


high:
	  ldaa #clear
	  staa tflg1,x

	  ldd toc2,x
	  addd #lowTicks
	  std toc2,x

	  ldaa LorH                   ;set up for next tickcheck
	  inca
	  staa LorH

cleanup:                        ;clear timer flag and return to mainloop
  ldaa #clear
  staa tflg1,x
  rti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   DATA AREA                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LorH: .byte 0
control:  .byte 0

#set up dummy frame pointer
.global _.frame
_.frame: .word

.end
