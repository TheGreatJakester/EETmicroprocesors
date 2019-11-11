; By Jacob Moulton
#include "p16f887.inc"

; CONFIG1
; __config 0xE0F4
__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
__CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
org 0x00	;declare program placement
    
    
    
;===== Configure Micro controller ======
bsf STATUS, RPO ;select bank 3
bsf STATUS, RP1

CLRF ANSEL	 ; set all to digital
clrf ANSELH	 ; set all to digital
bsf ANSELH, 7    ; set ANS 8 to analog

bcf STATUS, RP1; select bank 1

clrf TRISB
bsf TRISB, 2 ; set RB2 as the only input
clrf TRISD ; set all of port D as output
clrf ADCON1; set left aligned, and vss and vdd for reference voltages

bcf STATUS, RPO ; select bank 0

clrf ADCON0
movlw b'00100011'
movwf ADCON0    ;set clock source,channel (ANS8), GO!, enable for  ATD
    
    

    
    
main:
    BTFSC ADCON0, GO
    goto $-1 ; Wait till GO is clear.
    
    movlw ADRESH
    movwf PORTD
    bsf ADCON0, GO
    goto main
