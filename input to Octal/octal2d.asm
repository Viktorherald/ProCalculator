;octal string to numeric value 
 		.8086
		.model small
		.stack 64
			
		.DATA
welcome	db	"Hello, This is a program to convert octal string to numeric value$"
crlf	db	0AH, 0DH, "$"
oct1 	dw 	0
PARA_LIST LABEL BYTE
MAX_LEN		DB	20
ACT_LEN		DB	?
KB_DATA		DB	20 dup('$')
		.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
			
		LEA 	DX, welcome
		MOV 	AH, 09H
		INT 	21H
		LEA 	DX, crlf
		INT 	21H
		
		MOV 	AH, 0AH
		LEA		DX, PARA_LIST
		INT 	21H				;accept string input and store to KB_DATA
		LEA 	DX, crlf
		MOV 	AH, 09H
		INT 	21H
		
		XOR 	AX, AX
		XOR 	DX, DX

		LEA 	SI, PARA_LIST
		INC 	SI				;points to length of string
		MOV 	CL, [SI]		;CL = length of string
		DEC 	CX				;points to last char of string (length - 1)
		XOR		AX, AX			;clear AX
		
	loop1:
		CMP 	BX, 0			;is it the first loop?
		JE		firstTime
		MOV 	AX, 8			;not the first loop at this point
		MUL 	BX				;8^(x + 1)
		MOV 	BX, AX			;Store result back to DL
		JMP 	loop2			;skip firstTime
			
	firstTime:
		MOV 	BX, 1			;8^0
		LEA 	SI, KB_DATA
		ADD 	SI, CX			;SI now points to last char in KB_DATA
	loop2:
		MOV 	AL, [SI]		;SI = KB_DATA
		SUB 	AL, 30H			;ASCII --> numeric
		MOV 	AH, 0			
		MUL 	BX				;AL * 8^x
		ADD 	oct1, AX		
		DEC 	SI				;pointer move foward
		DEC 	CX				;
		CMP 	CX, 0			;still got char to process?
		JGE 	loop1 			;jump if index >=0
		
		MOV 	AX, oct1		
			
EXIT:	MOV 	AX, 4C00H
		INT 	21H
		
MAIN 	ENDP
END 	MAIN