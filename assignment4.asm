; By Jacob Moulton
#include "p16f887.inc"

; CONFIG1
; __config 0xE0F4
__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
__CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
    org 0x00	;declare program placement

X equ H'0020'	    ; declare variable X at location H'0020'
Y equ H'0021'	    ; declare variable Y at location H'0021'
    
main:
    
    call init
    call loop
    
delay:
    nop
loop1:
    movlw d'210' ; set X to 194
    movwf X
loop2:
    movlw d'255' ; set Y to 255
    movwf Y
wait:
    nop ;wait a while
    nop
    nop
    nop
    nop
    decfsz Y, F; if Y is not yet 0, decrease it and wait again.
    goto wait
    decfsz X, F; if Y is zero, check to see if X is 0. If it is not, go back to reset Y and wait some more. 
    goto loop2
    return ; finish the delay
    
loop:
    bsf PORTB, 0 ; turn on blue light
    ;bcf PORTC, 0 ; turn off red light
    call delay ; go wait
    bcf PORTB, 0 ; turn off blue light
    ;bsf PORTC, 0 ; turn on red light
    call delay ; go wait
    goto loop ; do it again
    return ; should never hit
    
init:
    bsf STATUS, RP0
    bsf STATUS, RP1
    clrf ANSEL
    clrf ANSELH
    bsf STATUS, RP0
    bcf STATUS, RP1
    
    clrf TRISD
    comf TRISD
    clrf TRISB
    
    bcf STATUS, RP0
    bcf STATUS, RP1
    
    clrf PORTB
    return
    
    end
