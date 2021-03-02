;convert decimal string to numeric value
		.8086
		.model small
		.stack 64
			
		.DATA

crlf		DB	0AH, 0DH, "$"
dec1		DW 	0
PARA_LIST LABEL BYTE
MAX_LEN		DB	7
ACT_LEN		DB	?
KB_DATA		DB	7 dup(?)
	
		.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
		XOR 	CX, CX			;clear CX
		
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
		MOV 	AX, dec1
		
EXIT:	MOV 	AX, 4C00H
		INT 	21H
		
MAIN 	ENDP
END 	MAIN