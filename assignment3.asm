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

wait_input equ H'0020'	    ; declare variable X at location H'0020'
wait_helper equ H'0021'	    ; declare variable Y at location H'0021'
    
main:
    
    call init
    call loop
    
delay:
    nop
loop2:
    movlw d'255' ; set Y to 255
    movwf wait_helper
wait:
    nop ;wait a while
    nop
    nop
    nop
    nop
    decfsz wait_helper, F; if Y is not yet 0, decrease it and wait again.
    goto wait
    decfsz wait_input, F; if Y is zero, check to see if X is 0. If it is not, go back to reset Y and wait some more. 
    goto loop2
    return ; finish the delay
    
loop:
    bcf PORTB, 0 ; turn off blue light
    BTFSS PORTC, 0 ; start to look for hold if set, otherwise, rest
    goto loop
    
    movlw d'100' ; set X to 194
    movwf wait_input
    call delay
    
    BTFSS PORTC, 0 ; if still held, light the led, otherwise, goto loop
    goto loop
    
    
    bsf PORTB, 0 ; turn on blue light
    
    movlw d'250' ; set X to 194
    movwf wait_input
    call delay ; go wait
        
    goto loop ; do it again
    
    
    return ; should never hit
    
init:
    bsf STATUS, RP0 ; I would desperatly like to know what this does. 
    bsf STATUS, RP1
    clrf ANSEL
    clrf ANSELH
    bsf STATUS, RP0
    bcf STATUS, RP1
    bcf TRISB, 0
    bsf TRISC, 0
    bcf STATUS, RP0
    bcf STATUS, RP1
    return
    
    end
