			.8086
			.model small
			.stack 256
			
			.DATA
digit1 	DB 	13,10,"Input first number: ","$"
digit2 	DB 	13,10,"Input second number:","$"
crlf		DB	0AH, 0DH, "$"

NUM1		DW 	?
NUM2		DW  ?
NUM3		DW  0

dec1		DW  0
remainder 	DW 	0
array 	db 	6 dup(?)

PARA_LIST LABEL BYTE
MAX_LEN		DB	7
ACT_LEN		DB	?
KB_DATA		DB	7 dup(?)

			.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
		
		LEA 	DX, digit1
		MOV 	AH, 09H
		INT 	21H
		
		CALL 	clearReg
		CALL 	hexaDec
		MOV 	AX, dec1
		MOV 	NUM1, AX
		
		LEA 	DX, digit2
		MOV 	AH, 09H
		INT 	21H 
		
		CALL 	clearReg
		CALL 	hexaDec
		MOV 	AX, dec1
		MOV 	NUM2, AX
		
		MOV 	AX, NUM1
		MOV 	BX, NUM2
		OR		AX, BX
		MOV 	NUM3, AX

		CALL 	clearReg
		MOV 	AX, NUM3
		LEA 	SI,	array	; SI with address array
		CALL 	hexaString
		
		
		LEA 	DX, array
		MOV 	AH, 09H
		INT 	21H
		
		
EXIT:	MOV 	AX, 4C00H
		INT 	21H
		
MAIN 	ENDP

clearReg PROC	
		XOR 	AX, AX
		XOR 	BX, BX
		XOR 	CX, CX
		XOR 	DX, DX
		
		RET
		
clearReg ENDP

hexaDec	PROC
		MOV 	dec1, 0
		
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
		MOV 	AX, 10H			;not the first loop at this point
		MUL 	BX				;16^(x + 1)
		MOV 	BX, AX			;Store result back to DL
		JMP 	loop2			;skip firstTime
		
	firstTime:
		MOV 	BX, 1			;16^0
		LEA 	SI, KB_DATA
		ADD 	SI, CX			;SI now points to last char in KB_DATA
	loop2:
		MOV 	AL, [SI]		;SI = KB_DATA
		CMP 	AL, 41H
		JGE     alphabet
		SUB 	AL, 30H			;ASCII --> numeric
	back:
		MOV 	AH, 0			
		MUL 	BX				;AL * 16^x
		ADD 	dec1, AX			
		DEC 	SI				;pointer move foward
		DEC 	CX				;
		CMP 	CX, 0			;still got char to process?
		JGE 	loop1 			;jump if index >=0
		JMP 	endProc
		
	alphabet:
		SUB 	AL, 37H
		JMP 	back

	endProc:
		RET
		
hexaDec	ENDP

hexaString PROC	

	execute:
		MOV 	CX, 4		; Loop counter
		MOV 	BX, 1000H	; prepare BX to be divided
	
		
	nextChar:	
		MOV 	DX, 0
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
		RET
hexaString ENDP

END 	MAIN