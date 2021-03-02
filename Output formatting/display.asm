;cursor manipulation

			.8086
			.model small
			.stack 256
			
			.DATA
msg 	db 	"Enter a char: $"
output 	db 	"Output: $"

			.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX

		;clear screen
		mov 	ah, 0H
		mov 	al, 03H
		int 	10h
		
		;read msg address & print
		LEA 	DX, msg
		MOV 	AH, 09H
		INT 	21H
		
		;set cursor position (r, c) = (DH, DL)
		MOV 	AH, 02H
		MOV 	DH, 12D
		MOV 	DL, 10D 	;(r, c) = (13, 11)
		INT 	10H
		
		;read and store input
		MOV 	AH, 01H
		INT 	21H
		
		;set cursor position 
		MOV 	AH, 02H
		MOV 	DH, 14D
		MOV 	DL, 15D 	
		INT 	10H
		
		;read output address & print
		LEA 	DX, output
		MOV 	AH, 09H
		INT 	21H
		
		;print the char I entered
		MOV 	DL, AL
		MOV 	AH, 02H
		INT 	21H
		
EXIT:	MOV 	AX, 4C00H
		INT 	21H
MAIN 	ENDP
END 	MAIN