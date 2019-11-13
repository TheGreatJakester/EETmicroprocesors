


; By Jacob Moulton
#include "p16f887.inc"

; CONFIG1
; __config 0xE0F4
__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
__CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
org 0x00	;declare program placement
current_count equ h'0022'
    
init:
    bsf STATUS, RP0 ; select bank 3
    bsf STATUS, RP1

    CLRF ANSEL	 ; set all to digital
    clrf ANSELH	 ; set all to digital
    
    bcf STATUS, RP1; select bank 1

    clrf TRISD ; set all of port D as output
    
    clrf OPTION_REG
    movlw b'10000111'
    movwf OPTION_REG    ;disable pull ups, set to highest prescaler

    clrf OSCCON
    movlw b'01000111'
    movwf OSCCON    ;slow down system clock (1MHz)
    
    bcf STATUS, RP0 ; select bank 0
    clrf PORTD
    comf PORTD

    
main:
    movf TMR0, 0
    movwf current_count ;copy TMR0 onto current_count
    
    movlw d'98'
    subwf current_count ;subtract 98 from current count (see calculations)
    
    btfsc STATUS, C
    goto toggle ; if more than 0, toggle light
    goto main
    
    
toggle:
    clrf TMR0 ; reset timer
    btfss PORTD, 0 ; if on, turn off. If off, turn on
    goto light_on
    goto light_off
    
light_on:
    bsf PORTD, 0; turn on light
    goto main
    
light_off:
    bcf PORTD, 0; turn off light
    goto main
    
    
    end ;should never hit
    
    
