.MODEL MEDIUM
.STACK 266
.DATA

NUM     DB 0AH
RESULT  DB ?

.CODE
.STARTUP

MAIN    PROC FAR

        MOV AX,@data    ;initialize DS to address

        MOV DS, AX      ;of data segment

        MOV ES, AX      ; make es=ds

        MOV DX, 0000H

        MOV AX, 05ffH

        MOV BX, 1000H

        MOV CL, 05H

        MOV SI, offset NUM

        MOV DI, offset RESULT

        MOV AL, [SI]

        ADD AH, AL

        MOV [DI], AH

        MOV DX, offset SI

   ;     Mov BX, DX

        .Exit

MAIN    ENDP

END