.MODEL  SMALL

        .STACK  100H

        .DATA
        
        Instring     DB  'ENTER A STRING:$',0AH, 0DH

        CapString    DB  'Capital Letter(s):$', 0AH, 0DH
        
        SmalString   DB  'Lower Case Letter(s):$', 0AH, 0DH

        NumString    DB  'Number(s):$', 0AH, 0DH

        SYString     DB  'Symbol(s):$', 0AH, 0DH

        CounterL     DB   0

        CounterC     DB   0

        CounterNum   DW   0

        CounterSY    DB   0

        Break        DB  0AH,0DH,'$'  ; new line

        Buffer       DB   100         ; max number(100) of chars expected

	Num          DB   ?           ; returns the number of chars typed

	Act_Buf      DB   100 DUP ('$') ; actual buffer w/ size=?max number?

.CODE

.STARTUP

MAIN    PROC FAR

        MOV  AX,@data

	MOV  DS,AX

        MOV  ES,AX

	MOV  AX,0000H

        MOV  CX,0000H
        
        ;MOV  CL, Num

        ;Display "ENTER A STRING"
        
        MOV DX, OFFSET Instring

        MOV AH,09H

        INT 21H

        ;Enter String

        MOV  AH,0AH

        MOV  DX,OFFSET Buffer

        INT 21H
        
        MOV  CL, Num

        ; Display  new line

        MOV DX, OFFSET Break

        MOV AH,09H

        INT 21H

        ;Display the entered string
        MOV DX, OFFSET Act_Buf

        MOV AH, 09H

        INT 21H

        ; Display  new line

        MOV DX, OFFSET Break

        MOV AH,09H

        INT 21H

        ;Code to sort through string

        MOV SI, OFFSET Act_Buf

L1:     MOV AL, [SI]

        ;compare al with lower case letters

        CMP AL, 61H          ;LOWER CASE a

        JB L2                ;If AL is below 'a' it Jumps to L2

        CMP AL, 7AH          ;LOWER CASE z

        JA L2                ;If AL is above 'z' it Jumps to L2

        INC CounterL
        
        JMP L5

        ; upper

L2:     CMP AL, 41H          ;CAPITAL A

        JB L3

        CMP AL, 5AH          ;CAPITAL Z

        JA L3

        INC CounterC
        
        JMP L5
        
L3:     ;compare al with numbers

        CMP AL, 30H          ;Number 0

        JB L4                ;If AL is below '0' it Jumps to L4

        CMP AL, 39H          ;Number 9

        JA L4                ;If AL is above '9' it Jumps to L4

        INC CounterNum
        
        JMP L5

L4:     ;spaces and tabs

        CMP AL,  20H        ;Spaces are ignored
        
        JE L5
        
        CMP AL,  09H        ;Tabs are ignored
        
        JE L5

        INC CounterSY

L5:     ; move forward



        INC SI

        DEC CL

        CMP CL, 0

        JE L6

        JMP L1



L6:     ;Display "Capital Letter(s)"

        MOV DX, OFFSET CapString

        MOV AH,09H

        INT 21H

        MOV DL, CounterC
        ADD DL, 30H 			;OUTPUT A CHARACTER TO THE SCREEN
        MOV		AH,2
        INT		21H

        ; Display  new line

        MOV DX, OFFSET Break

        MOV AH,09H

        INT 21H

        ;Display "Lower case letter(s)"

        MOV DX, OFFSET SmalString

        MOV AH,09H

        INT 21H


        MOV DL, CounterL
        ADD DL, 30H			;OUTPUT A CHARACTER TO THE SCREEN
        MOV		AH,2
        INT		21H
        
        ; Display  new line

        MOV DX, OFFSET Break

        MOV AH,09H

        INT 21H
        
        ;Display "Number(s)"

        MOV DX, OFFSET NumString

        MOV AH,09H

        INT 21H
        
        ;Convert CounterNum to hex value

        MOV AX, CounterNum

        AAM

        ADD AX, 3030H

        MOV DX, 0H

        MOV BX, AX

        MOV DL, BH

        MOV AH, 02H

        INT 21H

        MOV DL, BL
        
        MOV AH, 02H
        
        INT 21H

        ; Display  new line

        MOV DX, OFFSET Break

        MOV AH,09H

        INT 21H

        ;Display "Symbol(s)"

        MOV DX, OFFSET SYString

        MOV AH,09H

        INT 21H

        MOV DL, CounterSY

        ADD DL, 30H

        MOV AH, 02H
        
        INT 21H





.EXIT

MAIN    ENDP

END