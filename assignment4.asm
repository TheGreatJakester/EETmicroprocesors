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
sub_flags equ H'0022'
    
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
    
    
clear:
    clrf sub_flags
    clrf PORTB
    return
    

loop:
    call delay
    BTFSC PORTC, 4
    goto sub_1
    BTFSC PORTC, 5
    goto sub_2
    BTFSC PORTC, 6
    goto sub_3
    goto clear_and_wait
    
    sub_1:
	btfss sub_flags, 0
	call clear
	bsf sub_flags, 0
	call flash_in_unison
	goto loop
	
    sub_2:
	btfss sub_flags, 1
	call clear
	bsf sub_flags, 1
	call binary_count
	goto loop
    
    sub_3:
	btfss sub_flags, 2
	call clear
	bsf sub_flags, 2
	call flow
	goto loop
    clear_and_wait:
	call clear
	goto loop
    
    
    
    return ; should never hit
    
flash_in_unison:
    BTFSS PORTB, 0
    goto turn_on
    goto turn_off
    turn_off:
	bcf PORTB, 0
	bcf PORTB, 1
	bcf PORTB, 2
	return
    turn_on:
	bsf PORTB,0
	bsf PORTB,1
	bsf PORTB,2
	return
    
binary_count:
    BTFSS PORTB, 0 ;skip if 1 is set
    goto flip_1
    BTFSS PORTB, 1 ; skip if 2 is set
    goto flip_12
    ;BTFSS PORTB, 2 ; skip if 3 is set
    ;goto flip_123
    goto flip_123; clears or counts
    
    flip_123:
    	BTFSS PORTB, 2
	bsf PORTB, 2
	bcf PORTB, 2
    
    flip_12:
    	BTFSS PORTB, 1
	bsf PORTB, 1
	bcf PORTB, 1
    
    flip_1:
	BTFSS PORTB, 0
	bsf PORTB, 0
	bcf PORTB, 0
	
    return
    
    
flow:
    BTFSC PORTB, 0
    goto one_to_two;found in 1
    BTFSC PORTB, 1
    goto two_to_three ;found in 2
    BTFSC PORTB, 2
    goto three_to_one;found in 3
    
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
