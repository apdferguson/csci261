.include "buff.h"

;============================================-=
; File:
       .file "buff.s"
; Behaviour:
;      Library of Buffalo Monitor Routines.
; Assumptions:
;      Routines only modify registers and the stack.
; Board:
;      CME11-E9-EVBU (with the PW link HACK)
; Author:
;      Peter Walsh Oct 19 2018
;============================================-=

;----------------------------------------------
;            Text Section (code and data)
;----------------------------------------------
.sect .text

;======================
; Buff routine stubs
;======================

set INCHAR, 0xffcd
set OUTA, 0xffb8
set OUTSTRGO, 0xffca
set OUTCRLF, 0xffc4


; INCHAR returns value in a
; C expects return value in b 

getc:   psha

        jsr INCHAR

        psha
        pulb
        pula
        rts

; C provides input parameter in b
; OUTA expects input parameter in a

putc:   psha
        pshb
        pula

        jsr OUTA


        pula
        rts

wcrlf:  jsr OUTCRLF
        rts

; C provides input parameter in d
; OUTSTRGO  expects input parameter in x

wstr:   pshx     ; save x 
        xgdx
        pshx     ; save d

        tpa      ; save ccr
        psha

        jsr OUTSTRGO

        pula
        tap      ; restore ccr

        pulx     ; restore d
        xgdx
        pulx     ; restore x
xwstr:  rts

.end
