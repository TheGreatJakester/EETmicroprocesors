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

