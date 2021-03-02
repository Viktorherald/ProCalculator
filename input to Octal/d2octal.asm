;numeric value to octal string
 		.8086
		.model small
		.stack 64
			
		.DATA
welcome	db	"Hello, This is a program to convert numeric value to octal string$"
crlf	db	0AH, 0DH, "$"
num1 	dw 	0FFE0H
remainder dw ?
oct1	db	7 dup(?)

		.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
			
		LEA 	DX, welcome
		MOV 	AH, 09H
		INT 	21H
		LEA 	DX, crlf
		INT 	21H
		
		XOR 	AX, AX
		XOR 	DX, DX
		
	execute:
		MOV 	CX, 6		; Loop counter
		LEA 	SI,	oct1	; DI with address oct1
		MOV 	BX, 8000H	; prepare BX to be divided
		MOV 	AX, num1	
		
	nextChar:	
		DIV 	BX 			; remainder at DX	
		ADD 	AX, 30h 	; convert quotient to ASCII
		
	continue:
		MOV  	[SI], AL	; store value to oct1
		INC 	SI			; increase offset location
		mov 	remainder, DX ; store DX
		MOV		AX, 8
		XCHG 	AX, BX
		MOV 	DX, 0
		DIV		BX
		XCHG 	AX, BX
		MOV 	AX, remainder
		DEC 	CX
		JNZ		nextChar		
		MOV WORD PTR [SI], 24H ; $ sign
		
		LEA 	DX, oct1
		MOV 	AH, 09H
		INT  	21H
			
EXIT:	MOV 	AX, 4C00H
		INT 	21H
		
MAIN 	ENDP
END 	MAIN