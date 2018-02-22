.MODEL MEDIUM
.STACK 100H
.DATA
NUM1      DB 23H
NUM2      DB 35       
NUM3      DW 4545H  
MESSAGE   DB 'HELLO WORLD!','$', 0DH, 0AH
.CODE
.STARTUP        
MAIN  PROC FAR
        MOV   AX,@data    
        MOV DS,AX       
        MOV AX,0000H    
        MOV AL,NUM1   
        MOV AH,NUM2
        MOV AX,NUM3   
        MOV AX,offset NUM3  
        MOV BX,0000H
        MOV CX,0000H
        MOV DX,0000H
        MOV SI,offset MESSAGE   
        MOV BX,SI     
        MOV BX,[SI]    
        MOV CL,[SI]
        MOV CL,[SI+1]   
        MOV DL,[SI]    
        MOV DX,[SI]   
        .EXIT
MAIN    ENDP
        END