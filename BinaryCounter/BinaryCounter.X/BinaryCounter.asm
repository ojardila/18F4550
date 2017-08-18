LIST P=18F4550
INCLUDE <P18F4550.INC>
CONFIG XINST=ON
    
; Defining Special Bits   
STATUSLED   EQU 2
PUSHBUTTON  EQU 1
FAN	    EQU 4
	    
; General purpose Registers
CBLOCK 0x00
  COUNTER
  SET_POINT
ENDC
  
ORG 00
GOTO Start

;Main Program
Start
    CALL    CONFIGURATION	; Device configuration
    CLRF    COUNTER		; Clearing COUNTER Register
    CLRF    SET_POINT		; Clearing SET_POINT Register
    MOVLW   .5			; Moving 5 in decimal to W Register
    MOVWF   SET_POINT		; Moving from W to SET_POINT Register
MAIN
CHECK_TURN_ON_FAN
    BTFSS   PORTA,PUSHBUTTON	; If Bit 1 in PORTA is 1 skipe next line
    GOTO    CHECK_TURN_ON_FAN   ; Go to CHECK_TURN_ON_FAN label
    MOVF    W,COUNTER		; Move counter register into w register
    CPFSGT  SET_POINT           ; Check if  SET_POINT is greather than W register
    GOTO    TURN_ON_FAN		; Go TURN_ON_FAN Label 
    GOTO    INCREMENT_COUNTER	; Go to INCREMENT_COUNTER Label
    GOTO    MAIN		; Go to main
INCREMENT_COUNTER		
    INCF    COUNTER,1		; INCREMENT Counter register and set the new value into the same register
    GOTO    CHECK_TURN_ON_FAN   ; Go to CHECK_TURN_ON_FAN Label
TURN_ON_FAN
    BSF	    PORTB,FAN		; Set bit to 1 fourth register in PORTB Register
    GOTO    CHECK_TURN_OFF_FAN  ; Go to CHECK_TURN_OFF_FAN register
TURN_OFF_FAN
    BCF	    PORTB,FAN           ; Set bit to 0 fourth register in PORTB Register
    GOTO    CHECK_TURN_ON_FAN   ; Go to CHECK_TURN_ON_FAN register
CHECK_TURN_OFF_FAN
    BTFSS   PORTA,PUSHBUTTON	; If Bit 1 in PORTA is 1 SKIP next line
    GOTO    CHECK_TURN_OFF_FAN  ; GOTO CHECK_TURN_OFF_FAN label
    DECFSZ  COUNTER,1		; Decrement counter register and check if is zero, once it's zero skip next line
    GOTO CHECK_TURN_OFF_FAN	; GOTO CHECK_TURN_OFF_FAN label
    GOTO MAIN			; GOTO MAIN
    
CONFIGURATION
    ; Configuring Special Registers (SFR)
    CLRF    PORTA		; Clear PORTA register
    CLRF    PORTB		; Clear PORTB register
    CLRF    PORTC		; Clear PORTc register
    MOVLW   B'00000010'		; 0 outputs and 1 inputs
    MOVWF   TRISA		; Move from W register to PORTA register
    MOVLW   B'00000000'		; only outputs
    MOVWF   TRISB		; Move from W register to PORTA register
    MOVLW   B'00000000'		; Move from W register to PORTB register
    MOVWF   TRISC		; Move from W register to PORTC register
    MOVLW   B'00001111'		; 4 inputs 4 outputs
    MOVWF   ADCON1		; Move from W register to ADCON1 register
    MOVLW   B'10000000'		
    MOVWF   OSCTUNE		; Move from W register to ADCON1 register
    MOVLW   B'01101111'
    MOVWF   OSCCON		; Move from W register to OSCCON register
    CLRF    UCON		; Clear UCON Register
    CLRF    UCFG		; Clear UCFG Register
    RETURN
    END



