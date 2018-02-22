
                                                                     
                                                                     
                                             
;LAB 4 PROGRAM
;FILENAME: lab4.asm
;FILE TYPE: EXE
.MODEL MEDIUM
.STACK 1024
.DATA
     Buffer   DB 20
     NUM      DB ?
     ACT_BUF  DB 20 DUP('$')
     MSG      DB 0DH,0AH,'Enter an algebraic command line:',0DH,0AH,'$'
     NEWLINE  DB 0DH,0AH,'$'
     ERROR    DB 'Error, invalid input',0DH,0AH,'Input format: Operand1 Operator Operand2',0DH,0AH,'Operand: decimal numbers',0DH,0AH,'Operator: + - * / %$',0DH,0AH
     RES_MSG  DB 'The result is: ',0DH,0AH,'$'
     DIV_ZERO DB 'Divisor cannot be zero!',0DH,0AH,'$'

     ; TO DO :
     ;  Add your data structure to hold the input parameters :
     ;  Operand1, sign of Operand1, Operator, Operand2 , sign of Operand2, results
     sign1        DB '+'
     operand1     DB 4 dup('$')
     operand1_hex DW 0000h

     operator     DB '+'

     sign2        DB '+'
     operand2     DB 4 dup('$')
     operand2_hex DW 0000h

     results      DB 0
     ; ==Hint== What  did you  do in Lab3 to  store your counters !!

     MULT1        DW 0000h
     HEX_RES      DW 0000h
     ASC_RES      DB 7 dup(0)
     RES_SIGN     DB '+'

.CODE
     .STARTUP
MAIN PROC FAR
          MOV AX,@DATA         ;startup
          MOV DS,AX
          MOV ES,AX

          LEA DX,MSG           ;display prompt message
          MOV AH,09h
          INT 21h

          ; - TO DO - Add your code here to
          ; Read input  string form Keybaord ; example : -12 / -3
          MOV  AH,0AH
          MOV  DX,OFFSET Buffer
          INT 21H

          ; Validate Data
          LEA si, ACT_BUF
          LEA di, sign1
          CALL readSign
          LEA di, operand1
          CALL readValue
          LEA di, operator
          CALL readOp
          LEA di, sign2
          CALL readSign
          LEA di, operand2
          CALL readValue

toOper:
          MOV SI, OFFSET operand1
          CALL ASC2HEX
          MOV AX, [MULT1]
          MOV [operand1_hex], AX

          MOV MULT1, 0000h

          MOV SI, OFFSET operand2
          CALL ASC2HEX
          MOV AX, [MULT1]
          MOV [operand2_hex], AX

          MOV BX, operand1_hex
          CMP sign1,'-'
          JE checkNegMag
          CMP sign1,'+'
          JE checkPosMag

two:
          MOV BX, operand2_hex
          CMP sign2,'-'
          JE twocheckNegMag
          CMP sign2,'+'
          JE twocheckPosMag

checkPosMag:
          CMP BL, 79h
          JA fail
          JMP two
checkNegMag:
          CMP BL, 80h
          JA fail
          JMP two

twocheckPosMag:
          CMP BL, 79h
          JA fail
          JMP continue
twocheckNegMag:
          CMP BL, 80h
          JA fail
          JMP continue

continue:
          MOV AH, sign1
          MOV AL, sign2

          LEA SI, operand1_hex
          LEA DI, operand2_hex

          JMP HOP

print:
          ;Convert result back to ASCII and output
          MOV AX,[HEX_RES]
          LEA BX,ASC_RES
          CALL HEX2ASC

          MOV DX, OFFSET NEWLINE
          MOV AH,09H
          INT 21H

          MOV DX, OFFSET RES_MSG
          MOV AH,09H
          INT 21H

          MOV DL, [RES_SIGN]
          MOV AH,02H
          INT 21H

          MOV DX,OFFSET ASC_RES
          MOV AH,09H
          INT 21H

          MOV DX, OFFSET NEWLINE
          MOV AH,09H
          INT 21H
          
          JMP quit

fail:
          MOV DX, OFFSET ERROR
          MOV AH,09H
          INT 21H

quit:

   .EXIT
MAIN ENDP

ReadSign  PROC NEAR
          CLD
          LODSB
          CMP AL, 20H
          JE finish
          CMP AL, 0DH
          JE finish
          CMP AL, '-'
          JNE notNeg
          STOSB

finish:   ret

notNeg:   DEC SI
          JMP finish

ENDP

ReadValue PROC NEAR

          CLD
again:    LODSB
          CMP AL, 20H
          JE finish
          CMP AL, 0DH
          JE finish

          CMP AL, 30H
          JB failNum
          CMP AL, 39H
          JA failNum
          
          CMP DI,OFFSET operand1+3
          JE failNum
          CMP DI,OFFSET operand2+3
          JE failNum

          STOSB

          JMP again

failNum:  MOV DX, OFFSET ERROR
          MOV AH,09H
          INT 21H

   .EXIT

ENDP

ReadOp PROC NEAR
          CLD
opAgain:  LODSB
          CMP AL, 20H
          JE finish
          CMP AL, 0DH
          JE finish

          CMP AL, 2AH
          JE close

          CMP AL, 2BH
          JE close

          CMP AL, 2DH
          JE close

          CMP AL, 2FH
          JE close

          CMP AL, 25H
          JE close

          JMP failOp

close:    STOSB

          JMP opAgain

failOp:   MOV DX, OFFSET ERROR
          MOV AH,09H
          INT 21H
   .EXIT

ENDP

ASC2HEX PROC NEAR

       PUSH AX
       PUSH DX
       SUB 	DI,DI 		;CLEAR DI FOR THE BINARY(HEX) RESULT
       SUB	CX,CX		;clear register CX
AL1:   MOV	CL,[SI]         ; move first ASCII vlaue
       INC	SI
       CMP	CL,24H          ; CHECK IF EMPTY
       JE	FINISH1
       SUB	CL,30H          ; FROM ASCII TO BCD /HEX/Binary
       MOV	AX,10           ;
       MUL	MULT1           ; Place holder FOR THE RESULT , initially =0
       ADD	AX,CX
       MOV	MULT1,AX
       JMP	AL1

FINISH1  :
	POP DX
	POP AX
	RET

ASC2HEX ENDP

RET_HOP PROC NEAR
        
        JMP print

RET_HOP ENDP

HEX2ASC PROC NEAR

        MOV CX,0
        PUSH 10
        MOV CX,10
L1:     MOV DX,0
        DIV CX
        PUSH DX
        CMP AX,0
        JNZ L1
L2:     POP DX
        CMP DX, 10
        JE L4
        ADD DL, 30H
        CMP DL, 39H
        JBE L3
        ADD DL, 7
L3:     MOV [BX], DL
        INC BX
        JMP L2
L4:     MOV BYTE PTR[BX],'$'
        ret

HEX2ASC ENDP

HOP PROC NEAR

          CMP operator,'+'
          JE DO_ADD
          CMP operator,'-'
          JE DO_SUB
          CMP operator,'*'
          JE HOP_MUL
          CMP operator,'/'
          JE HOP_DIV
          CMP operator,'%'
          JE HOP_MOD
          ret

HOP ENDP

DO_ADD PROC NEAR

            CMP AH,AL
            JE addition

            MOV BH,[SI]
            MOV BL,[DI]
            CMP BH,BL
            JB bigDI

            JMP bigSI

bigDI:      MOV AH, AL
            MOV BX, 0000h
            ADD BX, [DI]
            SUB BX, [SI]
            JMP add_fin

bigSI:      MOV AL, AH
            MOV BX, 0000h
            ADD BX, [SI]
            SUB BX, [DI]
            JMP add_fin

addition:   MOV BX, 0000h
            ADD BX,[SI]
            ADD BX,[DI]

add_fin:    MOV [HEX_RES], BX
            MOV RES_SIGN, AL
            JMP RET_HOP

DO_ADD ENDP

HOP_MUL PROC NEAR

        JMP DO_MUL

HOP_MUL ENDP

HOP_DIV PROC NEAR

        JMP DO_DIV

HOP_DIV ENDP

HOP_MOD PROC NEAR

        JMP DO_MOD

HOP_MOD ENDP

DO_SUB PROC NEAR

            CMP AH,AL
            JNE subtraction

            MOV BH,[SI]
            MOV BL,[DI]
            CMP BH,BL
            JB dbigDI

            JMP dbigSI

dbigDI:     MOV AH, AL
            MOV BX, 0000h
            ADD BX, [DI]
            SUB BX, [SI]
            
            CMP AH, '+'
            JE sMakeNeg

            JMP sMakePos

sMakeNeg:   MOV AH, '-'
            JMP dadd_fin

sMakePos:   MOV AH, '+'
            JMP dadd_fin

dbigSI:     MOV AL, AH
            MOV BX, 0000h
            ADD BX, [SI]
            SUB BX, [DI]
            JMP dadd_fin

subtraction:MOV BX, 0000h
            ADD BX,[SI]
            ADD BX,[DI]

dadd_fin:   MOV [HEX_RES], BX
            MOV RES_SIGN, AH
            JMP RET_HOP

DO_SUB ENDP

DO_MUL PROC NEAR
       
       PUSH AX

       MOV DX, 0000h

       MOV AX, [SI]
       MOV BX, [DI]
       IMUL BX

       MOV [HEX_RES], AX
       POP AX
       
       CMP AH, AL
       JNE mNeg
       
       JMP RET_HOP

mNeg:  MOV RES_SIGN,'-'
       JMP RET_HOP

DO_MUL ENDP

DO_DIV PROC NEAR

       PUSH AX
       MOV DX, 0000h
       
       CMP WORD PTR [DI], 0000h
       JE dZero

       MOV AX, [SI]
       MOV BX, [DI]
       IDIV BX

       MOV [HEX_RES], AX
       POP AX

       CMP AH, AL
       JNE dNeg

       JMP RET_HOP

dNeg:  MOV RES_SIGN,'-'
       JMP RET_HOP

dZero: LEA DX,DIV_ZERO
       MOV AH,09h
       INT 21h

       .EXIT

DO_DIV ENDP

DO_MOD PROC NEAR

       PUSH AX
       MOV DX, 0000h
       
       CMP WORD PTR [DI], 0000h
       JE oZero

       MOV AX, [SI]
       MOV BX, [DI]
       IDIV BX

       MOV [HEX_RES], DX
       POP AX

       CMP AH, AL
       JNE oNeg

       JMP RET_HOP

oNeg:  MOV RES_SIGN,'-'
       JMP RET_HOP

oZero: LEA DX,DIV_ZERO
       MOV AH,09h
       INT 21h

       .EXIT
DO_MOD ENDP


END
