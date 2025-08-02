

#define _screen		$BB80

	.zero
counter				.dsb 4

	.text

_main
	LDA #0
	STA counter
	STA counter+1
	STA counter+2
	STA counter+3

incr
	LDA counter+3
	CLC
	ADC #1
	STA counter+3
	LDX #3
.(
loop
	LDA counter-1,x
	ADC #0
	STA counter-1,x
	DEX
	BNE loop
.)
	JSR display
	JSR get
	; JMP incr
	CPX #27
	BNE incr
	RTS

display
.(
	LDX #4
	LDY #8
loop
	LDA counter-1,x
	PHA
	AND #%00001111
	JSR to_hex
	STA _screen+40*6+8,y
	DEY
	PLA
	AND #%11110000
	LSR
	LSR
	LSR
	LSR
	JSR to_hex
	STA _screen+40*6+8,y
	DEY
	DEX
	BNE loop
	RTS
.)

get
	LDA $02DF
	; BPL get
	AND #$7F
	LDX #0
	STX $02DF
	TAX
	RTS

; Expects a number between 0-15 in the accumulator
; Returns the equivalent 0-9/A-F character in the accumulator
to_hex
    CMP #$0A
    BCC case_09
    SEC
    SBC #$0A
    CLC
    ADC #"A"
    RTS
case_09
    CLC
    ADC #"0"
    RTS
