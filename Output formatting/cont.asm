			.8086
			.model small
			.stack 256
			
			.DATA
msgMoreOption 	db "Choose an option: $"
msgCont 		db "1. Continue$"
msgNew			db "2. New calculation$"
msgEnd			db "3. End$"
optionEnd		db "Your Option: $"
crlf 			db 10, 13, '$'
toContinue		db ?

			.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
	
		MOV 	AX, 0003H
		INT 	10H
		
		LEA 	DX, crlf
		MOV 	AH, 09H
		INT 	21H
		LEA 	DX, msgMoreOption
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0304H
		INT 	10H
		LEA 	DX, msgCont
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0404H
		INT 	10H
		LEA 	DX, msgNew
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0504H
		INT 	10H
		LEA 	DX, msgEnd
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0112H
		INT 	10H
		MOV 	AH, 01H
		INT 	21H
		MOV 	toContinue, AL
		
		MOV 	AH, 02H
		MOV 	DX, 0700H
		INT 	10H
		LEA 	DX, optionEnd
		MOV 	AH, 09H
		INT 	21H
		MOV 	DL, toContinue
		MOV 	AH, 02H
		INT 	21H
		
		
EXIT:	MOV 	AX, 4C00H
		INT 	21H
MAIN 	ENDP
END 	MAIN