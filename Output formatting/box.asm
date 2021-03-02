;create border for box

			.8086
			.model small
			.stack 256
			
			.DATA
border 	db 	'l'

			.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX

		;clear screen
		MOV 	AH, 0H
		MOV 	AL, 03H
		INT 	10H
		
		
		MOV 	CX, 20 		; box with length 20
							; initial cursor will be at (1, 1) after clr scn
							; r = row, c = column
	row:					; all numbers used refers to position. I.E, 1 = 1st, 20 = 2nd etc..
		CALL 	printBorder
		DEC 	CX			; print 20 times in a row
		JNZ		row	
	; row END 
		
		MOV 	CX, 18		; box with height 20(1 + 18 + 1)
		MOV 	DH, 01D		
		MOV 	DL, 00D 	; initialize (r, c) = (2, 1)
	column:
		MOV 	DL, 00D		; make sure c is 1 for every loop
		CALL 	setCursor
		CALL 	printBorder	
		MOV 	DL, 19D		; c = 20
		CALL 	setCursor
		CALL 	printBorder
		INC 	DH			; r += 1
		DEC 	CX			
		CMP		CX, 0		; if CX == 0, then r == 19 at that point
		JE		lastRow		; r == 19, jump to lastRow
		JMP 	column
	
	lastRow:	
		MOV 	DH, 19D		
		MOV 	DL, 00D 	; initialize (r, c) = (20, 0)	
		CALL 	setCursor
		
		MOV 	CX, 20		; loop for row printing
	print:
		CALL 	printBorder
		DEC 	CX			; x += 1
		JNZ		print
		;row END

EXIT:	MOV 	AX, 4C00H
		INT 	21H
MAIN 	ENDP



printBorder PROC NEAR
		MOV 	AH, 02h
		MOV 	DL, border
		INT 	21H
		RET
printBorder ENDP

setCursor	PROC NEAR
		MOV 	AH, 02H
		INT 	10H
		RET
setCursor ENDP
	
END 	MAIN