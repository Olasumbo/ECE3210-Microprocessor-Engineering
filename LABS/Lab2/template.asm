.MODEL SMALL
.STACK 266
.DATA

; place data definitions here

.CODE
.STARTUP
MAIN    PROC FAR
        MOV AX,@data ;initialize DS to address
        MOV DS, AX ;of data segment
        MOV ES, AX ; make es=ds

        ; Place code here

        .Exit
MAIN    ENDP
END