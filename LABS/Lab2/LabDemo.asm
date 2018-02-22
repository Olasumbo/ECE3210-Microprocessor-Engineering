.MODEL SMALL
.STACK 266
.DATA

Buffer DB 80                                        ;max number(80)of chars expected
Num DB ?                                              ; returns the number of chars typed
Act_Buf              DB 80 DUP (?)                  ; actual buffer w/ size=“max number”

.CODE
.STARTUP
MAIN    PROC FAR
        MOV AX,@data ;initialize DS to address
        MOV DS, AX ;of data segment
        MOV ES, AX ; make es=ds

                MOV DX,         offset Buffer
                MOV AH,         0Ah
                INT             21h

        .Exit
MAIN    ENDP
END