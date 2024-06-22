.Model Small
.Stack 100H
.Data

    TB1 DB 'Nhap vao ky tu: $'
    TB2 DB 10, 13, 'Ky tu vua nhap: $'

.Code

PRINT_STR MACRO STR
    MOV AH, 9
    LEA DX, STR
    INT 21H
ENDM

MAIN PROC
    MOV AX, @Data
    MOV DS, AX
    
    PRINT_STR TB1
    
    MOV AH, 1
    INT 21H
    MOV CL, AL
    
    PRINT_STR TB2
    
    MOV DL, CL
    MOV AH, 2
    INT 21H    
    
    MOV AH, 4CH
    INT 21H
ENDP