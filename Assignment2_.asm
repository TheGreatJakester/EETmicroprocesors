; Kaycee Etchart, Jacob Moulton
; First PIC assembly language program
; connect LED, 180 ohm resistor to pin 33
; PIC 16F887

#include "p16f887.inc"

; CONFIG1
; __config 0xE0F4
__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
__CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
    org 0x00	;declare program placement
    
main:
    
    call init
    
loop:
    bsf PORTB, 0    ;set RB0 to 1
    nop
    nop
    nop
    nop
    nop
    bcf PORTB, 0    ;set RB0 to 0
    nop
    nop
    nop
    nop
    nop
    goto loop
    
init:
    bsf STATUS, RP0
    bsf STATUS, RP1
    clrf ANSEL
    clrf ANSELH
    bsf STATUS, RP0
    bcf STATUS, RP1
    bcf TRISB, 0
    bcf STATUS, RP0
    bcf STATUS, RP1
    return
    
    end


    
    ;; Kaycee Etchart, Jacob Moulton
;; Second PIC assembly language program
;; connect LED, 180 ohm resistor to pin 33
;; add delay subroutine to LED blink program
;; PIC 16F887
;
;#include "p16f887.inc"
;
;; CONFIG1
;; __config 0xE0F4
;__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
;; CONFIG2
;; __config 0xFFFF
;__CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
;    
;    org 0x00	    ; declare program placement
;
;X equ H'0020'	    ; declare variable X at location H'0020'
;Y equ H'0021'	    ; declare variable Y at location H'0021'
;
;init:
;    bsf STATUS, RP0 ; bit set STATUS 
;    bsf STATUS, RP1 ; bit set STATUS
;    clrf ANSEL	    ; clear ANSEL
;    clrf ANSELH	    ; clear ANSELH
;    bsf STATUS, RP0 ; 
;    bcf STATUS, RP1 ; 
;    clrf TRISC	    ; clear TRISC
;    bcf STATUS, RP0 ; bit clear STATUS
;    bcf STATUS, RP1 ; bit clear STATUS
;    clrf TRISC	    ; clear TRISC
;    return	    ; return to line after init label
; 
;main:
;    bsf PORTC, 0    ; bit set PORTC bit 0
;    bsf PORTC, 1    ; bit set PORTC bit 1
;    call delay	    ; call subroutine "delay"
;    bcf PORTC, 0    ; bit clear PORTC bit 0
;    bcf PORTC, 1    ; bit clear PORTC bit 1
;    call delay	    ; call subroutine "delay"
;    goto main	    ; go to main label
;
;delay:
;    movlw d'255'    ; move literal decimal number 255 to W
;    movwf X	    ; move W to value X, assign 255 to variable X
;here:
;    movlw d'255'    ; move literal decimal 255 to W
;    movwf Y	    ; move W to value Y, assign 255 to variable Y
;loop:
;    nop		    ; no operation, wait x5
;    nop
;    nop
;    nop
;    nop
;    
;    decfsz Y, F	    ; decrement variable Y by 1, skip if zero
;    goto loop	    ; go to loop label unless Y equals zero
;    decfsz X, F	    ; decrement variable X by 1, skip if zero
;    goto here	    ; get out of loop
;    
;    return	    ; return to line after loop label
;    
;    end		    ; end subroutine

