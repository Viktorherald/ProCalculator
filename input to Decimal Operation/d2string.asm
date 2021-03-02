;numeric value to decimal string
			.8086
			.model small
			.stack 256
			
			.DATA
num1		dw 	0AA23H
remainder 	dw ?
array		db	7 dup('$')

			.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
			
		XOR 	AX, AX
		XOR 	DX, DX
		
	execute:
		MOV 	CX, 5		; Loop counter
		LEA 	SI,	array	; DI with address array
		MOV 	BX, 2710H	; prepare BX to be divided
		MOV 	AX, num1	
		
	nextChar:	
		DIV 	BX 			; remainder at DX	
		CMP 	AX, 10
		JGE		character
		ADD 	AX, 30h 	; convert quotient to ASCII
		
	back:
		MOV  	[SI], AL	; store value to array1
		INC 	SI			; increase offset location
		mov 	remainder, DX ; store DX
		MOV		AX, 10
		XCHG 	AX, BX		
		MOV 	DX, 0
		DIV		BX			; 10^(x-1)
		XCHG 	AX, BX
		MOV 	AX, remainder
		DEC 	CX
		JNZ		nextChar		
		MOV WORD PTR [SI], 24H ; $ sign
		JMP 	endProc
		
	character:
		ADD 	AX, 37H		; convert values to character
		JMP 	back
		
	endProc:
		LEA 	DX, array
		MOV 	AH, 09H
		INT  	21H
		
EXIT:	MOV 	AX, 4C00H
		INT 	21H
		
MAIN 	ENDP
END 	MAIN
		
	