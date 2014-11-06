DATA SEGMENT 
	STR1 		DB 	4 	DUP(?)
	STR2 		DB 	4 	DUP(?)

	STR_IN 		DB 	0AH , 0DH , "Input 4 bit num : $"	
	STR_OUT 	DB 	0AH , 0DH , "Resault is :  $"

DATA 	ENDS

CODE SEGMENT 

	ASSUME CS:CODE , DS:DATA

START :
	MOV 	AX , DATA 
	MOV 	DS , AX 

	LEA 	BX , [STR1]

	MOV 	CX , 4

	MOV 	AH , 9 
	LEA 	DX , [STR_IN]
	INT 	21H

IN_1:	MOV 	AH , 1
	INT 	21H
	SUB 	AL , 30H
	MOV 	[BX] , AL
	INC 	BX
	LOOP 	IN_1

	MOV 	AH , 9 
	LEA 	DX , [STR_IN]
	INT 	21H
	LEA 	BX , [STR2]
	MOV 	CX , 4

IN_2:	MOV 	AH , 1
	INT 	21H
	sub 	al , 30h
	MOV 	[BX] , AL
	INC 	BX
	LOOP 	IN_2

 	MOV 	CX , 4
	MOV 	DL , 0

	LEA 	SI , [STR1]
	LEA 	DI , [STR2]
	ADD 	SI , 3
	ADD 	DI , 3

ADJ:	MOV 	AL , [SI] 
	ADD 	AL , [DI]
	ADD 	AL , DL
	
	CMP 	AL , 0AH
	jge 	SET_CF
	MOV 	DL , 0
	PUSH 	AX
	
JUDG:	DEC 	CX 
	DEC 	DI 
	DEC 	SI
	cmp 	CX , 0
	JE 	SHOW_RES
	JMP 	ADJ
SET_CF:
	MOV 	DL , 1 					;设置是否进位
	mov 	ah , 0
	SUB 	AL , 10
	PUSH 	AX
	JMP 	JUDG 

SHOW_RES :
	push 	dx 
	MOV 	AH , 9 
	LEA 	DX , [STR_OUT]
	INT 	21H

	pop 	dx
	MOV 	CX , 4
	CMP 	DL , 1
	JE 	HIGH_BIT
	jmp 	SHOW_LOOP	
SHOW_LOOP:
	POP 	AX 
	MOV 	DL , AL 
	ADD 	DL , 30H
	MOV 	AH , 02H
	INT 	21H
	LOOP 	SHOW_LOOP
	JMP 	EXIT_CODE

HIGH_BIT :
	MOV 	DH , 0
	ADD 	DL , 30H
	MOV 	AH , 02H 
	INT 	21H
	
	JMP 	SHOW_LOOP

EXIT_CODE :
	MOV 	AX , 4C00H
	INT 	21H

CODE 	ENDS

	END START
