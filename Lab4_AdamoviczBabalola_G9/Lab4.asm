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

     AGAIN    DB 'Again? press y for yes, any other key to exit:$'

     OPERAND1 DB 'Operand1:$'

     OPERAND2 DB 'Operand2:$'

     OPERATOR DB 'Operator:$'

     RESULTS  DB 'Result:$'

     N1_A  DB 4 DUP ('$')

     N2_A   DB 4 DUP ('$')

     N1_H      DB 0

     N2_H      DB 0

     OPT       DB ?

     Result_H  DW 0

     Result_A  DB 20 DUP ('$')

     choice    DB 0


.CODE

     .STARTUP

MAIN PROC FAR

START:    MOV AX,@DATA         ;startup
          MOV DS,AX
          MOV ES,AX

          LEA DX,MSG           ;display prompt message
          MOV AH,09h
          INT 21h


          ;Enter String
          MOV  AH,0AH
          MOV  DX,OFFSET Buffer
          INT 21H

          ;Display  new line
          MOV DX, OFFSET NEWLINE
          MOV AH,09H
          INT 21H

          ;Display the entered string
          MOV DX, OFFSET ACT_BUF
          MOV AH, 09H
          INT 21H

          ; Display  new line
          MOV DX, OFFSET NEWLINE
          MOV AH,09H
          INT 21H

          LEA DI, N1_A
          LEA SI, Act_Buf

          MOV CX, 0000H
          MOV CL, NUM

T:        CLD
          LODSB
          CMP AL, 20H
          ;JNE E                          ;error check jump
          JE T2
          CMP AL, 0DH
          ;JNE E                          ;error check jump
          JE T3
          MOV [DI], AL
          INC DI
          LOOP T

T2:       LODSB
          MOV OPT, AL
          ADD SI, 1
          LEA DI, N2_A
          SUB CX, 1
          LOOP T

T3:       MOV SI, OFFSET N1_A         ;ASCII to Hex conversion
          CALL A2H
          MOV N1_H, BL


          MOV SI, OFFSET N2_A
          CALL A2H
          MOV N2_H, BL
          MOV AX, 0000H
          MOV AL, N1_H
          MOV BX, 0000H
          MOV BL, N2_H

          JMP OPERATE

E:        MOV DX, OFFSET ERROR
          MOV AH,09H
          INT 21H
          JMP OPTION

OPERATE:  ;COMPUTATIONS
          CMP OPT, '+'
          JE PLUS

          CMP OPT, '-'
          JE MINUS

          CMP OPT, '*'
          JE MULT

          CMP OPT, '/'
          JE QUOTIENT

          CMP OPT, '%'
          JE MODULUS

PLUS:     ADD AX, BX
          MOV Result_H, AX
          JMP HEX

MINUS:    SUB AX, BX
          MOV Result_H, AX
          JMP HEX

MULT:     IMUL BX
          MOV Result_H,AX
          JMP HEX

QUOTIENT: MOV DX, 0000H
          IDIV BX
          MOV Result_H, AX
          JMP HEX

MODULUS:  MOV DX, 0000H
          IDIV BX
          MOV Result_H, DX
          JMP HEX

START1:   JMP START

HEX:      MOV SI, OFFSET Result_H              ;call hex 2 ascii proc
          CALL H2A

          MOV DX, OFFSET NEWLINE
          MOV AH,09H
          INT 21H

          MOV DX, OFFSET OPERAND1
          MOV AH,09H
          INT 21H

          MOV DX, OFFSET N1_A
          MOV AH, 09H
          INT 21H

          MOV DX, OFFSET NEWLINE
          MOV AH,09H
          INT 21H

          MOV DX, OFFSET OPERAND2
          MOV AH,09H
          INT 21H

          MOV DX, OFFSET N2_A
          MOV AH, 09H
          INT 21H

          MOV DX, OFFSET NEWLINE
          MOV AH,09H
          INT 21H

          MOV DX, OFFSET OPERATOR
          MOV AH,09H
          INT 21H

          MOV DL, OPT
          MOV AH, 02H
          INT 21H

          MOV DX, OFFSET RESULTS
          MOV AH,09H
          INT 21H

          MOV DX, OFFSET Result_A
          MOV AH,09H
          INT 21H

          MOV DL, OPT
          MOV AH, 02H
          INT 21H

OPTION:   MOV DX, OFFSET NEWLINE
          MOV AH,09H
          INT 21H

          MOV DX, OFFSET AGAIN
          MOV AH,09H
          INT 21H

          MOV AH, 1
          INT 21H
          MOV choice, AL

          CMP AL, 'y'
          JE  START1


   .EXIT

MAIN ENDP

A2H PROC NEAR
          MOV BL, 00H
BEGIN:    MOV CL, [SI]
          CMP CL, '$'
          JE  exit
          SUB CL, 30H
          MOV AX, 10
          MUL BX
          ADD AX, CX
          MOV BX, AX
          INC SI
          JMP BEGIN
exit:
    RET
A2H ENDP

H2A PROC NEAR
           LEA BX, Result_A
           Mov CX, 10
           Push CX
           Mov AX, Result_H

L1:        Mov DX, 0      ;Diving ASCII Number
           DIV CX
           PUSH DX
           CMP AX, 0
           JNZ L1

L2:        POP DX
           CMP DX, CX
           JE L4
           ADD DL, 30H

L3:        MOV [BX], DL
           INC BX
           JMP L2

L4:        MOV byte ptr[BX], '$'


RET
H2A ENDP


END