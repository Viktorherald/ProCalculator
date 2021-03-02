;inferior input style

			.8086
			.model small
			.stack 256
			
			.DATA
msg1 	db  20 dup(?) 			; only works for 19 char
msg2 	db 	"The message you entered is: $"
crlf	db	0DH, 0AH, "$"

			.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
		
		LEA 	SI, msg1
		CALL 	ReadString
		
		LEA 	DX, msg2
		MOV 	AH, 09H
		INT 	21H
		
		LEA 	DX, msg1
		INT 	21H
		
		
EXIT:	MOV 	AX, 4C00H
		INT 	21H
		
MAIN 	ENDP

ReadString PROC NEAR

	Read: 
		MOV 	AH, 01H
		INT 	21H
		CMP 	AL, 13
		JE		Done
		MOV 	[SI], AL
		INC		SI
		JMP 	Read
		
	Done:
		MOV WORD PTR [SI], 24H
		RET
ReadString ENDP

END 	MAIN
		
	
	
	
	
	