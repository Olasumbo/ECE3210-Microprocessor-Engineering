.MODEL MEDIUM
.STACK 100H
.DATA

k dw ?
p dw 500 dup (?)

.code
;to do
.STARTUP 

MAIN PROC FAR 
mov k, 0 
mov cx, 500 
mov si, 0 
start: mov ax, k
cmp k, 300 
jg minus
 
plus:
add p[si], ax 
jmp next
 
minus:
sub p[si], ax 

next: 
inc k ; k++
inc si 
inc si 
loop start 

.EXIT 
MAIN ENDP 

END