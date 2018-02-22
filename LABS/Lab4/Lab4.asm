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

     Op1      DW 0
     
     Op1Sign  DB 0
     
     Operator DB 0
     
     Op2      DW 0
     
     OP2Sign  DB 0
     
     Results  DW 0
     

     ; TO DO :

     ;  Add your data structure to hold the input parameters :

     ;  Operand1, sign of Operand1, Operator, Operand2 , sign of Operand2, results

     ; ==Hint== What  did you  do in Lab3 to  store your counters !!





     



.CODE

     .STARTUP

MAIN PROC FAR

          MOV AX,@DATA         ;startup

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

          ; - TO DO - Add your code here to 

          ; 1. Read input  string form Keybaord ; example : -12 / -3 

          ; 2. Print  the enteretd string on screen

          ; 3. Highlight Operand1&2, sign of Operand1&2, Operator, and results in memory, see Figure 4-1 in lab4 Assignment sheet.

          



       



          

   .EXIT

MAIN ENDP

END