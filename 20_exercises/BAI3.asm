.Model Small
.Stack 100H
.Data

    STR DB 100 DUP('$')
    TB1 DB 'Nhap vao chuoi ky tu: $'
    TB2 DB 10, 13, 'Chuoi ky tu vua nhap la: $'

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
    
    LEA DX, STR
    MOV AH, 10
    INT 21H
    
    PRINT_STR TB2
    
    MOV AH, 9
    LEA DX, STR + 2
    INT 21H
    
    MOV AH, 4CH
    INT 21H
ENDP