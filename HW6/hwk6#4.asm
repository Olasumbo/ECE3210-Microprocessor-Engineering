.MODEL MEDIUM
.STACK 100H
.DATA

x db 100 dup (?)
y db 100 dup (?)

.CODE

.STARTUP

MAIN PROC FAR

mov cx, 100

lea si, x

lea di, y

begin: mov al, [si]

cmp al, 0

;jg l1 ;if doesn't work comment out this line

; or if doesn't work uncomment lines below

test al, 80h

jz l1

neg al

l1: mov [di], al 

inc si 

inc di 

loop begin 

.EXIT 

MAIN ENDP



END