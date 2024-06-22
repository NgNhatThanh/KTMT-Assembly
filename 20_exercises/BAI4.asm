.Model Small
.Stack 100H
.Data

    TB1 DB 'Nhap vao ky tu viet thuong: $'
    TB2 DB 10, 13, 'In ra ky tu viet hoa: $'

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
    AND CL, 0DFH ; CHUYEN KY TU THUONG -> HOA
    
    PRINT_STR TB2
    
    MOV DL, CL
    MOV AH, 2
    INT 21H    
    
    MOV AH, 4CH
    INT 21H
ENDP