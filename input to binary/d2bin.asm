;numeric value to binary

 		.8086
		.model small
		.stack 64
			
		.DATA
welcome	db	"Hello, This is a program to convert dec to binary$"
crlf	db	0AH, 0DH, "$"
num1 	dw	000FH
bin1	db	18 dup(?)

		.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
		
		LEA 	DX, welcome
		MOV 	AH, 09H
		INT 	21H
		
		LEA 	DX, crlf
		INT 	21H
		
		XOR 	AX, AX 	; clear AX
		XOR		DX, DX	; clear DX
			
	execute:
		MOV 	CX, 16		; Loop counter
		LEA 	SI, bin1	; SI with address bin
		MOV 	BX, 8000H	; prepare BX to be divided
		MOV 	AX, num1	
		
	nextBit:	
		DIV 	BX 			; remainder at DX
		CMP 	CX, 8		; space at every 8 bit, easier to read
		JE 		spacing
	back:
		add 	AL, 30h 	; convert quotient to ASCII
		MOV  	[SI], AL	; store value to bin1
		INC 	SI			; increase mem location
		MOV 	AX, DX		; mov and clear AX
		XOR 	DX, DX		; clear DX
		SHR		BX, 1		; essentially div BX by 2
		DEC 	CX
		JNZ		nextBit		
		MOV WORD PTR [SI], 24H ; $ sign
		JMP 	endProc
		
	spacing:
		MOV		AH, 20H
		MOV		[SI], AH
		INC 	SI
		JMP 	back
		
	endProc:
		LEA 	DX, bin1
		MOV 	AH, 09H
		INT  	21H


EXIT:	MOV 	AX, 4C00H
		INT 	21H
		
MAIN 	ENDP
END 	MAIN