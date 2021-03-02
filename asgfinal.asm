			.8086
			.model large
			.stack 256
			
			.DATA
CRLF		DB	0DH, 0AH, '$'

loginPage LABEL BYTE
user 		db 	"taruc"
password 	db 	"12345"
welcome		db 	"Welcome to ProCalculator, please enter your username: $"
errorMsg 	db 	"Error, user name not match. $"
errorPsd 	db	"Error, password not match. $"
gratz 		db 	"Congratulations! Now you can start using Procalculator.$"
msgPass		db	"Please enter your password: $"
msg2		db 	"Press any key to continue$"
passLength	db	0
passArray	db 	12 dup(?)

temporaryValue LABEL BYTE
remainder 	dw 	?
tempNum		DW 	0
hex1		db	6 dup(?)
bin1 		db 	19 dup(?)
oct1		db 	7 dup(?)
dec1 		db 	6 dup(?)

basePage LABEL BYTE
msgBase		DB	"Choose your base number: $"
op1			DB 	"A. Hexa $"
op2			DB 	"B. Binary $"
op3 		DB 	"C. Decimal $"
op4			DB 	"D. Octa $"
msgFirst	DB 	"Enter first number: $" 
msgSecond	DB 	"Enter second number: $" ;
BASEOPTION	DB 	?
errMsg 		Db 	'Invalid choice!! please try again: $'

operationPage LABEL BYTE
msg4  	db 	"Number 1: $"
msgOps	db 	"Choose an operation: $"
ops1	db	"A. Add$"
ops2 	db 	"B. Subtraction$"
ops3 	db  "C. Multiply$"
ops4	db 	"D. Division$"
ops5 	db 	"E. AND$"
ops6 	db	"F. OR$"
ops7 	db 	"G. NOT$"
ops8 	db  "H. XOR$"
ops9	db	"I. Shift Left$"
ops10 	db  "J. Shift Right$"
ops11	db 	"K. Convert$" 
optionChosen db ?

result LABEL BYTE
num1 		dw	1
num2		dw 	1
result1		dw	?
divRemainder	dw 	?
msgResult	db 	'Result: $'
msgQuotient	db 	"Quotient: $"
msgRemainder db	" Remainder: $"
msgConvert 	db 	"Converted Number: $"

continuePage LABEL BYTE
msgMoreOption 	db "Choose an option: $"
msgCont 		db "1. Continue$"
msgNew			db "2. New calculation$"
msgEnd			db "3. End$"
toContinue		db ?

programEnding LABEL BYTE
progUsedCounter dB 30H
msgUsedTimes 	db "Number of times you have used Procalculator: $"
msgEndProg		DB 		"Your calculation is completed.", 10, 13
				DB		"Thank you for using Proclaculator.", 10, 13
				DB		"Come back anytime!!$"
Thankyou     db     "   __________________________________________________________________________ ",10,13
			 db		"  |                                                                          |",10,13
			 db		"  |   ***********    **      **       ****        ***       **  **     **    |",10,13
			 db		"  |        **        **      **     **    **      **  *     **  **    **     |",10,13
			 db		"  |        **        **      **    **      **     **   *    **  **   **      |",10,13
			 db		"  |        **        ** **** **    ** **** **     **    *   **  *******      |",10,13
			 db		"  |        **        **      **    **      **     **     *  **  **    **     |",10,13
			 db		"  |        **        **      **    **      **     **       ***  **     **    |",10,13
			 db		"  |        **        **      **    **      **     **       ***  **      **   |",10,13
			 db		"  |                                                                          |",10,13
			 db		"  |                **        **     **********     **        **              |",10,13
			 db		"  |                **        **     **      **     **        **              |",10,13
			 db		"  |                **       **      **      **     **        **              |",10,13
			 db     "  |                  **    **       **      **     **        **              |",10,13
			 db     "  |                    ****         **      **     **        **              |",10,13
			 db     "  |                     **          **      **     **        **              |",10,13
			 db     "  |                     **          **      **      **      **               |",10,13
			 db     "  |                     **          **********       ********                |",10,13
			 db     "  |__________________________________________________________________________|$"
 			 

PARA_LIST LABEL BYTE
MAX_LEN		DB	17
ACT_LEN		DB	?
KB_DATA		DB	17 dup(?)

			.CODE
MAIN	PROC	FAR
		MOV 	AX, @data
		MOV 	DS, AX
		
	retryLogin:
		CALL 	FAR PTR clearReg
		CALL 	FAR PTR printLoginPage
	
	newCalc:		;new calculation
		CALL 	FAR PTR clearReg
		MOV 	AX, 0003H
		INT		10H     		;clear screen
		CALL 	FAR PTR printBaseOption    ;print base option
		
		CALL 	FAR PTR clearReg
		CALL 	FAR PTR input1		;input number 1
		
		MOV 	AX, 2H
		INT 	10H
		CALL    FAR PTR SetCursorColor
	continueCalc:
		CALL 	FAR PTR clearReg
		CALL 	FAR PTR optionPage	;display operation menu, and input operation choice
		
		MOV 	AH, 02H
		MOV 	DX, 1000H
		INT 	10H					;set cursor to appropriate location
		
		CMP 	optionChosen, 'G'	;some operation doesnt need to have second number input
		JE 		noSecondInput
		CMP 	optionChosen, 'I'
		JE 		noSecondInput
		CMP 	optionChosen, 'J'
		JE 		noSecondInput
		CMP 	optionChosen, 'K'
		JE 		noSecondInput
		
		LEA 	DX, msgSecond
		MOV 	AH, 09H
		INT 	21H
		CALL 	FAR PTR clearReg
		CALL 	FAR PTR input2		;input number 2
		
		MOV 	BX, num2
	noSecondInput:
		MOV 	AX, num1			
		CALL 	FAR PTR chooseOperation	;perform appropriate operation, at the function
		MOV 	result1, AX
		
		LEA 	DX, crlf
		MOV 	AH, 09H
		INT 	21H		
		
		CMP 	optionChosen, 'D' 	;check if divison operation is choosed or not
		JNE 	normal
		
		ADD 	progUsedCounter, 1	;used one time of calculator when the program reached result screen
		LEA		DX, msgQuotient
		MOV 	AH, 09H
		INT 	21H
		CALL 	FAR PTR clearReg
		MOV 	AX, result1			;parameter for output procedure, store output at AX
		CALL 	FAR PTR output		;print result
		
		LEA 	DX, msgRemainder
		MOV 	AH, 09H
		INT 	21H
		CALL 	FAR PTR clearReg
		MOV 	AX, divRemainder			
		CALL 	FAR PTR output	
		JMP 	howToContinue 
		
	normal:			;normal operation
		LEA		DX, msgResult
		MOV 	AH, 09H
		INT 	21H
		CALL 	FAR PTR clearReg
		
		MOV 	AX, result1			
		CALL 	FAR PTR output		;print result
		
	howToContinue:
		ADD 	progUsedCounter, 1	;used one time of calculator when the program reached continue screen
		CALL 	FAR PTR clearReg
		CALL 	FAR PTR chooseContinue ;continue operation will be in the function
		
		
		LEA 	DX, msgUsedTimes
		MOV 	AH, 09H
		INT 	21H
		MOV 	DL, progUsedCounter
		MOV 	AH, 02H
		INT 	21H
		
		LEA 	DX, crlf
		MOV 	AH, 09H
		INT 	21H
		LEA 	DX, msgEndProg
		INT 	21H
		LEA 	DX, crlf
		INT 	21H
		LEA 	DX, Thankyou
		INT 	21H
		
EXIT:	MOV 	AX, 4C00H
		INT 	21H						
		
MAIN 	ENDP

printLoginPage PROC
			MOV 	AX, 03
			INT 	10H
			CALL    FAR PTR SetCursorColor
			LEA 	DX, welcome		;display welcome 
			MOV 	AH, 09H
			INT 	21H
			
			LEA 	DX, PARA_LIST	;get paralist from user 
			MOV 	AH, 0AH
			INT 	21H
		
			LEA 	SI, KB_DATA					;
			LEA 	DI, user
			MOV 	AH, 0
			MOV 	CX, 5
			CMP 	CL, ACT_LEN
			JNE		inputErr		;length mismatch
			MOV	 	AH, 09H 
			LEA		DX, crlf
			INT 	21H 

		L1:
			MOV 	AL, [SI]		;USER INPUT	
			MOV 	BL, [DI]		;data in the prog
			INC 	SI
			INC 	DI				;program counter +1
			DEC		CX
			CMP 	CX, 0
			JL		enterPassword
			CMP 	AL, BL
			JE		L1
			JMP 	inputErr
	
	inputErr:
			LEA 	DX, crlf
			MOV 	AH, 09H
			INT 	21H
			LEA 	DX, errorMsg
			INT 	21H
			LEA  	DX, msg2
			INT 	21H
			MOV 	AH, 01H			;press any key to try again
			INT 	21H
			JMP 	retryLogin

	enterPassword:
			LEA 	DX, msgPass		;prompt user enter password
			MOV 	AH, 09H
			INT 	21H 
			LEA 	DI, passArray	;prepare DI to receive input
		cont:			;continue char input
			MOV     AH,	07H			;no-echo char input
			INT 	21H
			CMP 	AL, 13
			JE 		inputDone
			MOV 	[DI], AL
			INC 	DI
			ADD 	passLength, 1
			JMP 	cont
		inputDone:
			CMP 	passLength, 5 ;password in code is length 5
			JNE 	errPsd
			MOV 	CX, 5
		L2:
			LEA 	SI, passArray
			LEA 	DI, password
			MOV 	AL, [SI]		;USER INPUT	
			MOV 	BL, [DI]		;data in the prog
			INC 	SI
			INC 	DI				;program counter +1
			DEC		CX
			CMP 	CX, 0
			JL		complete2
			CMP 	AL, BL
			JE		L2
			
		errPsd:
			MOV 	passLength, 0	;reset password length
			
			LEA 	DX , crlf
			MOV 	AH, 09H
			INT 	21H
			LEA 	DX, errorPsd
			INT 	21H
			LEA  	DX, msg2
			INT 	21H
			MOV 	AH, 01H
			INT 	21H
			JMP 	retryLogin

	complete2:
			LEA     DX, crlf
			MOV     AH, 09H
			INT     21H
			LEA     DX, gratz
			INT     21H
		    LEA     DX, crlf
			INT     21H
			LEA  	DX, msg2
			INT 	21H
			MOV 	AH, 01H
			INT 	21H
			
			RET
printLoginPage ENDP

input1 PROC
	check:
		CMP 	baseOption, 'A'		;check which base number user chosed
		JE 		iHexa
		CMP 	baseOption, 'B'
		JE		iBinary
		CMP 	baseOption, 'C'
		JE 		iDecimal
		CMP 	baseOption, 'D'
		JE		iOctal
		
	iback:				
		MOV 	AX, tempNum			;store converted number to num1, which is general purpose variable
		MOV 	num1, AX
		RET
		
	iHexa:
		CALL 	FAR PTR hexaNum		;convert String to numeric 
		JMP 	iback				;jump up to iBack
	iBinary:
		CALL 	FAR PTR binNum		
		JMP 	iback
	iDecimal:
		CALL 	FAR PTR decNum
		JMP 	iback
	iOctal:
		CALL 	FAR PTR octalNum
		JMP 	iback
input1 ENDP

input2 PROC							
	check2:
		CMP 	baseOption, 'A'			;similiar to input1 for second number
		JE 		iHexa2
		CMP 	baseOption, 'B'
		JE		iBinary2
		CMP 	baseOption, 'C'
		JE 		iDecimal2
		CMP 	baseOption, 'D'
		JE		iOctal2
		
	iback2:
		MOV 	AX, tempNum	
		MOV 	num2, AX
		RET
		
	iHexa2:
		CALL 	FAR PTR hexaNum
		JMP 	iback2
	iBinary2:
		CALL 	FAR PTR binNum		
		JMP 	iback2
	iDecimal2:
		CALL 	FAR PTR decNum
		JMP 	iback2
	iOctal2:
		CALL 	FAR PTR octalNum
		JMP 	iback2
input2 ENDP

output PROC		
		CMP 	baseOption, 'A'		;print the thing in AX, which is result1 with respective base number
		JE 		oHexa
		CMP 	baseOption, 'B'
		JE		oBinary
		CMP 	baseOption, 'C'
		JE 		oDecimal
		CMP 	baseOption, 'D'
		JE		oOctal
		
	oBack:
		MOV 	AH, 09H
		INT  	21H
		RET			;exit procedure

		
	oHexa:
		LEA 	SI,	hex1			;prepare array to pass in to the function to print number
		CALL 	FAR PTR numHexa
		LEA 	DX, hex1			;load and jump back to print the output
		JMP 	oBack
	oBinary:
		LEA 	SI,	bin1	
		CALL 	FAR PTR numBin
		LEA 	DX, bin1
		JMP 	oBack
	oDecimal:
		LEA 	SI,	dec1	
		CALL 	FAR PTR numDec
		LEA 	DX, dec1
		JMP 	oBack
	oOctal:
		LEA 	SI,	oct1	
		CALL 	FAR PTR numOctal
		LEA 	DX, oct1
		JMP 	oBack
output ENDP


clearReg PROC
		XOR 	AX, AX
		XOR 	BX, BX
		XOR 	CX, CX
		XOR 	DX, DX
		
		RET
clearReg ENDP

printBaseOption PROC	
		CALL    FAR PTR SetCursorColor
		MOV		AH,09H 
		LEA		DX, msgBase
		INT		21H 
		CALL    FAR PTR clearReg	
		MOV		AH, 02H 
		MOV 	DX, 0204H 
		INT 	10H 
		
		MOV 	AH, 09H 
		LEA 	DX, OP1
		INT 	21H 
			
		MOV		AH, 02H 
		MOV 	DX, 0304H 
		INT 	10H 
			
		MOV 	AH, 09H 
		LEA 	DX, OP2
		INT 	21H 
			
		MOV		AH, 02H 
		MOV 	DX, 0404H 
		INT 	10H 
			
		MOV 	AH, 09H 
		LEA 	DX, OP3
		INT 	21H 
			
		MOV		AH, 02H 
		MOV 	DX, 0504H 
		INT 	10H 
			
		MOV 	AH, 09H 
		LEA 	DX, OP4
		INT 	21H 
			
		MOV		AH, 02H 
		MOV 	DX, 0019H 
		INT 	10H 
		
	retry:
		MOV 	AH, 01H 		;get base number and store at baseOption
		INT 	21H 
		MOV 	baseOption, AL 
		
		CMP 	baseOption, 'A'		;checking for error
		JE 		continue
		CMP 	baseOption, 'B'
		JE		continue
		CMP 	baseOption, 'C'
		JE 		continue
		CMP 	baseOption, 'D'
		JE		continue
		
	errorr:		;if does not jump, means there is error
		MOV 	DX, 0H
		MOV 	AH, 02H
		INT 	10H
		LEA 	DX, errMsg
		MOV 	AH, 09H
		INT 	21H
		JMP 	retry
		
	continue:
		MOV		AH, 02H 
		MOV 	DX, 0700H 
		INT 	10H 
		
		MOV	 	AH, 09H 
		LEA		DX, msgFirst
		INT 	21H 

		RET
printBaseOption ENDP

hexaNum PROC
		CALL 	FAR PTR parameter
		
	hL1:
		CMP 	BX, 0			;is it the first loop?
		JE		hFirstTime
		MOV 	AX, 10H			;not the first loop at this point
		MUL 	BX				;16^(x + 1)
		MOV 	BX, AX			;Store result back to DL
		JMP 	hL2			;skip firstTime
		
	hfirstTime:
		MOV 	BX, 1			;16^0
		LEA 	SI, KB_DATA
		ADD 	SI, CX			;SI now points to last char in KB_DATA
	hL2:
		MOV 	AL, [SI]		;SI = KB_DATA
		CMP 	AL, 41H
		JGE     alphabet
		SUB 	AL, 30H			;ASCII --> numeric
	hBack:
		MOV 	AH, 0			
		MUL 	BX				;AL * 16^x
		ADD 	tempNum, AX			
		DEC 	SI				;pointer move foward
		DEC 	CX				;
		CMP 	CX, 0			;still got char to process?
		JGE 	hL1 			;jump if index >=0
		JMP 	hEnd
		
	alphabet:
		SUB 	AL, 37H
		JMP 	hBack

	hEnd:
		RET
		
hexaNum ENDP

numHexa PROC 
		MOV 	CX, 4		; Loop counter
		MOV 	BX, 1000H	; prepare BX to be divided
		
	hNextChar:	
		MOV 	DX, 0
		DIV 	BX 			; remainder at DX
		CMP 	AX, 10		
		JGE		greater
		ADD 	AX, 30h 	; convert quotient to ASCII
		
	hContinue:
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
		JNZ		hNextChar		
		MOV WORD PTR [SI], 24H ; $ sign
		JMP     hProcEnd
		
	greater:
		ADD 	AX, 37H		;convert to alphabet
		JMP 	hContinue
		
	hProcEnd:
		RET
		
numHexa ENDP

binNum PROC 
		CALL 	FAR PTR parameter
		
	bL1:
		CMP 	BX, 0			;is it the first loop?
		JE		bFirstTime
		MOV 	AX, 2H			;not the first loop at this point
		MUL 	BX				;2^(x + 1)
		MOV 	BX, AX			;Store result back to DL
		JMP 	bL2			;skip firstTime
		
	bFirstTime:
		MOV 	BX, 1			;2^0
		LEA 	SI, KB_DATA
		ADD 	SI, CX			;SI now points to last char in KB_DATA
	bL2:
		MOV 	AL, [SI]		;SI = KB_DATA
		SUB 	AL, 30H			;ASCII --> numeric
		MOV 	AH, 0			
		MUL 	BX				;AL * 2^x
		ADD 	tempNum, AX			
		DEC 	SI				;pointer move foward
		DEC 	CX				;
		CMP 	CX, 0			;still got char to process?
		JGE 	bL1 			;jump if index >=0

		RET
binNum ENDP

numBin 	PROC 
		MOV 	CX, 16		; Loop counter
		MOV 	BX, 8000H	; prepare BX to be divided
		
	nextBit:	
		DIV 	BX 			; remainder at DX
		CMP 	CX, 8		; space at every 8 bit, easier to read
		JE 		spacing
	bBack:
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
		JMP 	bBack
		
	endProc:
		RET
numBin 	ENDP

decNum 	PROC
		CALL 	FAR PTR parameter
		
	dL1:
		CMP 	BX, 0			;is it the first loop?
		JE		dFirstTime
		MOV 	AX, 10			;not the first loop at this point
		MUL 	BX				;10^(x + 1)
		MOV 	BX, AX			;Store result back to DL
		JMP 	dL2			;skip firstTime
		
	dFirstTime:
		MOV 	BX, 1			;10^0
		LEA 	SI, KB_DATA
		ADD 	SI, CX			;SI now points to last char in KB_DATA
	dL2:
		MOV 	AL, [SI]		;SI = KB_DATA
		SUB 	AL, 30H			;ASCII --> numeric
		MOV 	AH, 0			
		MUL 	BX				;AL * 10^x
		ADD 	tempNum, AX			
		DEC 	SI				;pointer move foward
		DEC 	CX				;
		CMP 	CX, 0			;still got char to process?
		JGE 	dL1 			;jump if index >=0

		RET
decNum ENDP

numDec 	PROC 
		MOV 	CX, 5		; Loop counter
		MOV 	BX, 2710H	; prepare BX to be divided
		
	dNextChar:	
		DIV 	BX 			; remainder at DX	
		ADD 	AX, 30h 	; convert quotient to ASCII
		
		MOV  	[SI], AL	; store value to array1
		INC 	SI			; increase offset location
		mov 	remainder, DX ; store DX
		MOV		AX, 10
		XCHG 	AX, BX		
		MOV 	DX, 0
		DIV		BX			; 10^(x-1)
		XCHG 	AX, BX
		MOV 	AX, remainder
		DEC 	CX
		JNZ		dNextChar
		
		MOV WORD PTR [SI], 24H ; $ sign
		RET
numDec 	ENDP
		
octalNum PROC
		CALL 	FAR PTR parameter
		
	oL1:
		CMP 	BX, 0			;is it the first loop?
		JE		oFirstTime
		MOV 	AX, 8			;not the first loop at this point
		MUL 	BX				;8^(x + 1)
		MOV 	BX, AX			;Store result back to DL
		JMP 	oL2				;skip firstTime
			
	oFirstTime:
		MOV 	BX, 1			;8^0
		LEA 	SI, KB_DATA
		ADD 	SI, CX			;SI now points to last char in KB_DATA
	oL2:
		MOV 	AL, [SI]		;SI = KB_DATA
		SUB 	AL, 30H			;ASCII --> numeric
		MOV 	AH, 0			
		MUL 	BX				;AL * 8^x
		ADD 	tempNum, AX		
		DEC 	SI				;pointer move foward
		DEC 	CX				;
		CMP 	CX, 0			;still got char to process?
		JGE 	oL1				;jump if index >=0
		
		RET
octalNum ENDP

numOctal PROC 
		MOV 	CX, 6		; Loop counter
		MOV 	BX, 8000H	; prepare BX to be divided
		
	oNextChar:	
		DIV 	BX 			; remainder at DX	
		ADD 	AX, 30h 	; convert quotient to ASCII
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
		JNZ		oNextChar		
		MOV WORD PTR [SI], 24H ; $ sign
		
		RET
numOctal ENDP

parameter PROC
		MOV 	tempNum, 0
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
		MOV 	CH, 0
		DEC 	CX				;points to last char of string (length - 1)
		XOR		AX, AX			;clear AX
		RET
parameter ENDP

optionPage PROC
		LEA 	DX, msgOps
		MOV 	AH, 09H 
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0204H
		INT 	10H
		LEA 	DX, ops1
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0304H
		INT 	10H
		LEA 	DX, ops2
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0404H
		INT 	10H
		LEA 	DX, ops3
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0504H
		INT 	10H
		LEA 	DX, ops4
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0704H
		INT 	10H
		LEA 	DX, ops5
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0804H
		INT 	10H
		LEA 	DX, ops6
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0904H
		INT 	10H
		LEA 	DX, ops7
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0A04H
		INT 	10H
		LEA 	DX, ops8
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0C04H
		INT 	10H
		LEA 	DX, ops9
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0D04H
		INT 	10H
		LEA 	DX, ops10
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 0F04H
		INT 	10H
		LEA 	DX, ops11
		MOV 	AH, 09H
		INT 	21H
	
		CMP 	toContinue, '1'
		JNE		noChange		;formatting purpose only
		MOV 	DX, 0115H
		JMP 	continueOperate
	noChange:
		MOV 	DX, 0015H
	continueOperate:
		MOV 	AH, 02H
		INT 	10H
		
	retryy:
		MOV 	AH, 01H
		INT 	21H
		MOV 	optionChosen, AL
		
		CMP 	optionChosen, 'A'	;check what operation user chosed
		JE 		return
		CMP 	optionChosen, 'B'	
		JE 		return
		CMP 	optionChosen, 'C'	
		JE 		return
		CMP 	optionChosen, 'D'	
		JE 		return
		CMP 	optionChosen, 'E'	
		JE 		return
		CMP 	optionChosen, 'F'	
		JE 		return
		CMP 	optionChosen, 'G'	
		JE 		return
		CMP 	optionChosen, 'H'	
		JE 		return
		CMP 	optionChosen, 'I'	
		JE 		return
		CMP 	optionChosen, 'J'	
		JE 		return
		CMP 	optionChosen, 'K'
		JE 	 	return
		
		MOV 	DX, 0000H
		MOV 	AH, 02H
		INT 	10H
		LEA		DX, errMsg	;didnt jump means error
		MOV 	AH, 09H
		INT 	21H
		JMP 	retryy;
		
	return:		
		RET
optionPage ENDP

chooseOperation PROC
		CMP 	optionChosen, 'A'	;check what operation user chosed
		JE 		addition
		CMP 	optionChosen, 'B'	
		JE 		subtraction
		CMP 	optionChosen, 'C'	
		JE 		multiply
		CMP 	optionChosen, 'D'	
		JE 		division
		CMP 	optionChosen, 'E'	
		JE 		opAND
		CMP 	optionChosen, 'F'	
		JE 		opOR
		CMP 	optionChosen, 'G'	
		JE 		opNOT
		CMP 	optionChosen, 'H'	
		JE 		opXOR
		CMP 	optionChosen, 'I'	
		JE 		shiftLEFT
		CMP 	optionChosen, 'J'	
		JE 		shiftRIGHT
		CMP 	optionChosen, 'K'
		JE		conversion 	

	addition:
		ADD 	AX, BX
		RET
	subtraction:
		SUB 	AX, BX
		RET
	multiply:
		MUL  	BX
		RET
	division:
		DIV 	BX
		MOV 	divRemainder, DX
		RET
	opAND:
		AND 	AX, BX
		RET
	opOR:
		OR 		AX, BX
		RET
	opNOT:
		NOT 	AX
		RET
	opXOR:
		XOR 	AX, BX
		RET
	shiftLEFT:
		SHL		AX, 1
		RET		
	shiftRIGHT:
		SHR 	AX, 1
		RET
	conversion:
		CALL 	FAR PTR clearReg
		MOV 	AX, 0003H
		INT		10H     
		LEA 	DX, msg4
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AX, num1
		MOV 	result1, AX		;store result if user want to continue use calculator
		CALL 	FAR PTR output			;output is based on the base option user choosed
		CALL 	FAR PTR printBaseOption	;at here, user will choose base option
		
		LEA 	DX, crlf
		MOV 	AH, 09H
		INT 	21H
		LEA 	DX, msgConvert	
		INT 	21H
	
		CALL 	FAR PTR clearReg
		MOV 	AX, num1
		CALL 	FAR PTR output			;at this point base option is changed to aother base
		
		JMP 	howToContinue
		
chooseOperation ENDP

chooseContinue PROC
		LEA 	DX, crlf
		MOV 	AH, 09H
		INT 	21H
		LEA 	DX, msgMoreOption
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 1404H
		INT 	10H
		LEA 	DX, msgCont
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 1504H
		INT 	10H
		LEA 	DX, msgNew
		MOV 	AH, 09H
		INT 	21H
		
		MOV 	AH, 02H
		MOV 	DX, 1604H
		INT 	10H
		LEA 	DX, msgEnd
		MOV 	AH, 09H
		INT 	21H
		
		CMP 	optionChosen, 'G'	;
		JE 		niceFormat
		CMP 	optionChosen, 'I'
		JE 		niceFormat
		CMP 	optionChosen, 'J'
		JE 		niceFormat
		CMP 	optionChosen, 'K'
		JE 		niceFormat
		
		MOV 	DX, 1312H
		JMP 	skippp
	niceFormat:
		MOV 	DX, 1212H
	skippp:
		MOV 	AH, 02H
		INT 	10H
		MOV 	AH, 01H
		INT 	21H
		MOV 	toContinue, AL
		
		CMP 	toContinue, '2'
		JNE 	skipp	
		
		MOV 	AX, 02H		;clear screen
		INT 	10H
		CALL    FAR PTR SetCursorColor
		
		JMP 	newCalc     ; 2 kind of jump to prevent jump out of range
	skipp:
		CMP 	toContinue, '3'
		JE 		exitProc
		
	;if didnt jump, means user choose to continue calculation
		MOV 	AX, result1
		MOV 	num1, AX
		
		MOV 	AX, 02H
		INT 	10H
		CALL    FAR PTR SetCursorColor
		LEA 	DX, msg4  	;display "number 1:"
		MOV 	AH, 09H
		INT 	21H
		
		
		CALL 	FAR PTR clearReg
		MOV 	AX, num1
		CALL 	FAR PTR output

		LEA 	DX, crlf
		MOV 	AH, 09H
		INT 	21H
		JMP 	continueCalc
		
	exitProc:
		MOV 	AX, 02H		;clear screen
		INT 	10H
		CALL    FAR PTR SetCursorColor
		RET
chooseContinue ENDP

SetCursorColor PROC
			MOV     AX,0600H
			MOV     BH,0EH			;yellow
			MOV     CX,0000H		
			MOV     DX,0580H		;row 0 to 5
			INT     10H
			MOV     AX,0600H
			MOV     BH,0AH			;light green
			MOV     CX,0600H		
			MOV     DX,1980H		;row 6 to 19
			INT     10H
			MOV     AX,0600H
			MOV     BH,0DH			;Magnenta(pink)
			MOV     CX,2000H		
			MOV     DX,2580H		;last 5 rows
			INT 	10H	
			RET
SetCursorColor ENDP

END 	MAIN