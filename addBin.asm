;convert decimal string to numeric value
		.8086
		.model small
		.stack 64
			
		.DATA
msg1 	db 'Enter the first binary number: $'
msg2 	db 'Enter the second binary number: $'	
crlf	DB	0AH, 0DH, "$"
result 	db 'The result is: $'

holder 	dw  0
NUM1	dw	?
NUM2	dw 	?
NUM3	DW	0

bin1	db	18 dup(?)

PARA_LIST LABEL BYTE
MAX_LEN	DB	17
ACT_LEN	DB	?
KB_DATA	DB	17 dup(?)
	
		.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
		
		LEA 	DX, msg1
		MOV 	AH, 09H
		INT 	21H
		
		CALL 	clearReg
		CALL 	stringBin
		MOV 	AX, holder
		MOV 	NUM1, AX
		
		LEA 	DX, msg2
		MOV 	AH, 09H
		INT 	21H
		
		CALL 	clearReg
		CALL 	stringBin
		MOV 	AX, holder
		MOV 	NUM2, AX
		
		MOV 	AX, NUM1
		MOV 	BX, NUM2
		ADD 	AX, BX
		MOV 	NUM3, AX
		
		CALL 	clearReg
		LEA 	SI, bin1	; SI with address bin
		MOV 	AX, NUM3	
		CALL 	binString
		
		LEA 	DX, result
		MOV 	AH, 09H
		INT 	21H
		LEA 	DX, bin1
		INT 	21H
		
EXIT:	MOV 	AX, 4C00H
		INT 	21H
		
MAIN 	ENDP

clearReg PROC
		XOR		AX, AX
		XOR 	BX, BX
		XOR 	CX, CX
		XOR 	DX, DX
		
		RET
clearReg ENDP

stringBin	PROC
		MOV 	holder, 0		;important to reset holder value each time the function is called

		MOV 	AH, 0AH
		LEA		DX, PARA_LIST
		INT 	21H				;accept string input and store to KB_DATA
		LEA 	DX, crlf
		MOV 	AH, 09H
		INT 	21H
		
		XOR 	DX, DX			;clear DX
		LEA 	SI, PARA_LIST
		INC 	SI				;points to length of string
		MOV 	CL, [SI]		;CL = length of string
		DEC 	CX				;points to last char of string (length - 1)
		XOR		AX, AX			;clear AX
		
	loop1:
		CMP 	BX, 0			;is it the first loop?
		JE		firstTime
		MOV 	AX, 2H			;not the first loop at this point
		MUL 	BX				;2^(x + 1)
		MOV 	BX, AX			;Store result back to DL
		JMP 	loop2			;skip firstTime
		
	firstTime:
		MOV 	BX, 1			;2^0
		LEA 	SI, KB_DATA
		ADD 	SI, CX			;SI now points to last char in KB_DATA
	loop2:
		MOV 	AL, [SI]		;SI = KB_DATA
		SUB 	AL, 30H			;ASCII --> numeric
	back:
		MOV 	AH, 0			
		MUL 	BX				;AL * 2^x
		ADD 	holder, AX			
		DEC 	SI				;pointer move foward
		DEC 	CX				;
		CMP 	CX, 0			;still got char to process?
		JGE 	loop1 			;jump if index >=0
		JMP 	endProc
		
	endProc:
		RET
stringBin	ENDP

binString	PROC
	execute:
		MOV 	CX, 16		; Loop counter
		MOV 	BX, 8000H	; prepare BX to be divided	
		
	nextBit:	
		DIV 	BX 			; remainder at DX
		CMP 	CX, 8		; space at every 8 bit, easier to read
		JE 		spacing
	backN:
		add 	AL, 30h 	; convert quotient to ASCII
		MOV  	[SI], AL	; store value to bin1
		INC 	SI			; increase mem location
		MOV 	AX, DX		; mov and clear AX
		XOR 	DX, DX		; clear DX
		SHR		BX, 1		; essentially div BX by 2
		DEC 	CX
		JNZ		nextBit		
		MOV WORD PTR [SI], 24H ; $ sign
		JMP 	endFunc
		
	spacing:
		MOV		AH, 20H
		MOV		[SI], AH
		INC 	SI
		JMP 	backN
		
	endFunc:
		RET
		
binString ENDP
		
END 	MAIN