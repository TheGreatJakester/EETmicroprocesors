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
sub_flags equ H'0022' ; set state flags so change detaction is posible
    
main:
    
    call init
    call loop
    
delay: ; copied delay subroutine from previous labs
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
    
    
clear:
    clrf sub_flags ;clear flags
    clrf PORTB ;turn off all lights
    return
    

loop:
    call delay ; hang in previous state, then read dip
    BTFSC PORTC, 4 ; if switch one is flipped, goto sub_1
    goto sub_1
    BTFSC PORTC, 5 ; if switch two is flipped, goto sub_2
    goto sub_2
    BTFSC PORTC, 6 ; if switch three is filled, goto sub_3
    goto sub_3
    goto clear_and_wait ; if no switch is flipped, clear
    
    sub_1:
	btfss sub_flags, 0 ; if sub one flag is set, assume no change, otherwise reset
	call clear
	bsf sub_flags, 0
	call flash_in_unison ; call the first subroutine then read dip
	goto loop
	
    sub_2:
	btfss sub_flags, 1 ; if sub two flag is set, assume no change, otherwise reset
	call clear
	bsf sub_flags, 1
	call reverse_flow ; call second subroutine then read dip
	goto loop
    
    sub_3:
	btfss sub_flags, 2 ; if sub three flag is set, assume no change, otherwise reset
	call clear
	bsf sub_flags, 2
	call flow ; call thrid subroutine then read dip
	goto loop
    clear_and_wait:
	call clear
	goto loop
    
    
    
    return ; should never hit
    
flash_in_unison:
    BTFSS PORTB, 0 ; check if lights are on
    goto turn_on ; if on, turn off
    goto turn_off; if off, turn on
    turn_off:
	bcf PORTB, 0 ; turn off lights
	bcf PORTB, 1
	bcf PORTB, 2
	return
    turn_on:
	bsf PORTB,0 ; turn on lights
	bsf PORTB,1
	bsf PORTB,2
	return
    
reverse_flow:
    BTFSC PORTB, 0 ; if light 1 is on
    goto one_to_three ; turn it off and turn on 3
    BTFSC PORTB, 1 ; if light 2 is on,
    goto two_to_one ; turn it off and turn on 1
    BTFSC PORTB, 2; if light 3 is on,
    goto three_to_two; turn it off and turn 2 on
    
    bsf PORTB, 0 ;if no lights are on, turn on light 1
    return
    
    two_to_one:
	bcf PORTB, 1
	bsf PORTB, 0
	return
    three_to_two:
    	bcf PORTB, 2
	bsf PORTB, 1
	return
    one_to_three:
    	bcf PORTB, 0
	bsf PORTB, 2
	return
    
    
flow:
    BTFSC PORTB, 0 ;if light one is on
    goto one_to_two ; turn it off and turn on light 2
    BTFSC PORTB, 1 ; if light 2 is on,
    goto two_to_three ;turn if off and turn on 3
    BTFSC PORTB, 2; if light 3 is on,
    goto three_to_one; turn it off and turn on light 1
    
    bsf PORTB, 0 ;else
    return
    
    one_to_two:
	bcf PORTB, 0
	bsf PORTB, 1
	return
    two_to_three:
    	bcf PORTB, 1
	bsf PORTB, 2
	return
    three_to_one:
    	bcf PORTB, 2
	bsf PORTB, 0
	return
    
    
init:
    bsf STATUS, RP0
    bsf STATUS, RP1
    clrf ANSEL ;all digitial
    clrf ANSELH
    bsf STATUS, RP0
    bcf STATUS, RP1
    
    clrf TRISC ;set port C as input
    comf TRISC 
    clrf TRISB ; set port B as output
    
    bcf STATUS, RP0
    bcf STATUS, RP1
    
    clrf PORTB; turn off the lights
    return
    
    end
