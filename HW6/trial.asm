;PROGRAM 3 OF LAB 1
;FILENAME: Lab1c.asm
;FILE FORMAT: EXE

.MODEL MEDIUM

.STACK 100H

.DATA
		MESSAGE		DB '',0DH,0AH
					DB ' $'
		OUTMSG 		DB 0DH,0AH,'-45 $'
		INCHAR		DB ?
		NEWLINE		DB 0DH,0AH,'$'

.CODE
      .STARTUP					;INITIALIZE THE PROGRAM
	   MAIN PROC FAR
		LEA		 DX,MESSAGE      		;PRINT MESSAGE
		MOV		 AH,9
		INT		 21H

		MOV		 AH,1 			;READ A CHARACTER FROM KEYBOARD
		INT		 21H
		MOV		 INCHAR,AL

		LEA		 DX,OUTMSG			;PRINT A MESSAGE
		MOV		 AH,9	
		INT		 21H

		MOV		 DL,INCHAR			;OUTPUT A CHARACTER TO THE SCREEN
		MOV		 AH,2
		INT		 21H

		MOV		 DX,OFFSET NEWLINE
		MOV		 AH,9				;MOVE CURSOR TO NEXT LINE
		INT		 21H
		.EXIT

   MAIN ENDP

END