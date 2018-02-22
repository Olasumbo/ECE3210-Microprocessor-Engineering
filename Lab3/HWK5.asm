.MODEL	MEDIUM
.STACK	1024
.DATA

     Instring     DB   'BYTEAREA:$',0AH, 0DH
     Break        DB   0AH,0DH,'$'  ; new line
     Buffer       DB   100         ; max number(100) of chars expected
     Num          DB   ?           ; returns the number of chars typed
     Act_Buf      DB   100 DUP ('$') ; actual buffer w/ size=?max number?
     byteArea     DB   1024 DUP('$')
     MSG          DB   0DH,0AH,' Enter Input String:',0DH,0AH,'$'
     byte1        DB   100
     stringIN     DB   100
     New_line     DB   0DH, 0AH, '$'

.code
.startup
MAIN PROC FAR
     Mov DI, offset byteArea
     Mov cx, 00H

T1:

   ; Print out MSG
     Mov dx, offset MSG
     Mov ah, 09H
     int 21H

     Mov dx, offset stringIN
     mov ah, 09H
     int 21H

     ;Enter String
     Mov  ah, 0AH
     Mov  dx, offset Buffer
     INT  21H

     ;Comparing the input string and finding $
     Mov bx, offset ACT_BUF
     CMP byte ptr[BX], '$'
     JE Done

     Mov si, offset ACT_BUF
     Mov cl, Num
     REP MOVSB

     Mov byte ptr[DI], 0DH
     INC DI
     Mov byte ptr[DI], 0AH
     INC DI

     ;Display Newline
     Mov dx, offset New_line
     mov ah, 09h
     int 21H

     Mov dx, offset byteArea
     mov ah, 09h
     int 21h
     jmp T1

Done:
       Mov dx, offset byteAREA
       Mov ah, 09h
       int 21h

       ;TODO: Display the entered string
       MOV DX, Offset Buffer
       MOV AH, 0AH
       INT 21H

        ;Display  "Byte Area" string
        ;MOV DX, OFFSET Instring
        ;MOV AH,09H
        ;INT 21H

        ;MOV DX, Offset Buffer
        ;MOV AH, 0AH
        ;INT 21H


       .Exit
MAIN ENDP
END