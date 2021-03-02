;decimal value to hexa

 		.8086
		.model small
		.stack 64
			
		.DATA
welcome	db	"Hello, This is a program to convert dec to hexa$"
crlf	db	0AH, 0DH, "$"
num1 	dw	0AA66H
hex1	db	5 dup(?)
remainder 	dw 	?

		.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
			
		LEA 	DX, welcome
		MOV 	AH, 09H
		INT 	21H
		
		LEA 	DX, crlf
		INT 	21H
		
		XOR 	AX, AX 		; clear AX
		XOR		DX, DX		; clear DX
		
	execute:
		MOV 	CX, 4		; Loop counter
		LEA 	SI,	hex1	; DI with address hex1
		MOV 	BX, 1000H	; prepare BX to be divided
		MOV 	AX, num1	
		
	nextChar:	
		DIV 	BX 			; remainder at DX
		CMP 	AX, 10		
		JGE		greater
		ADD 	AX, 30h 	; convert quotient to ASCII
		
	continue:
		MOV  	[SI], AL	; store value to hex1
		INC 	SI			; increase offset location
		mov 	remainder, DX ; store DX
		MOV		AX, 10H
		XCHG 	AX, BX
		MOV 	DX, 0
		DIV		BX
		XCHG 	AX, BX
		mov 	AX, remainder
		DEC 	CX
		JNZ		nextChar		
		MOV WORD PTR [SI], 24H ; $ sign
		JMP     procEnd
		
	greater:
		ADD 	AX, 37H		;convert to alphabet
		JMP 	continue
		
	procEnd:
		LEA 	DX, hex1
		MOV 	AH, 09H
		INT  	21H

EXIT:	MOV 	AX, 4C00H
		INT 	21H
		
MAIN 	ENDP
END 	MAIN