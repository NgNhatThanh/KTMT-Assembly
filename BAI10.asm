.Model Small
.Stack 100H
.Data                   
    TB DB 'Nhap vao chuoi: $'  
    TB1 DB 10, 13, 'Do dai chuoi da cho la: $'
    STR DB 100 DUP('$')
.Code
MAIN PROC
    MOV AX, @Data
    MOV DS, AX
    
    MOV AH, 9
    LEA DX, TB
    INT 21H
    
    MOV AH, 10
    LEA DX, STR
    INT 21H
    
    MOV AX, 0
    MOV AL, STR + 1
    MOV CX, 0
    MOV BX, 10
    
    PUSH_STACK:
        MOV DX, 0
        DIV BX
        PUSH DX      
        INC CX
        CMP AX, 0    
        JNE PUSH_STACK
             
    MOV AH, 9
    LEA DX, TB1
    INT 21H         
    
    POP_STACK:
        POP DX 
        ADD DX, '0'   
        MOV AH, 2
        INT 21H
        LOOP POP_STACK
        
    MOV AH, 4CH
    INT 21H
ENDP