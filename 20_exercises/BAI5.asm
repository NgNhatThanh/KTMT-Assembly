.Model Small
.Stack 100h
.Data      

    TB  DB 'Nhap vao chuoi: $'
    STR DB 100 DUP('$')
    TB1 DB 10, 13, 'Chuyen sang chuoi in thuong: $'
    TB2 DB 10, 13, 'Chuyen sang chuoi in hoa: $'  

.Code

PRINT_STR MACRO STR 
    MOV AH, 9
    LEA DX, STR
    INT 21H 
ENDM

MAIN PROC
    MOV AX, @Data
    MOV DS, AX 
    
    PRINT_STR TB
     
    LEA DX, STR
    MOV AH, 10
    INT 21H    
    
    PRINT_STR TB1
    CALL INTHUONG
    
    PRINT_STR TB2
    CALL INHOA
    
    MOV AH, 4CH
    INT 21H           
ENDP 

INTHUONG PROC
    LEA SI, STR + 2
    LAP1:
        CMP [SI], 13
        JE IN1
        OR [SI], 20H ; CHUYEN KY TU -> THUONG
        INC SI
        JMP LAP1
    IN1:    
        MOV AH, 9
        LEA DX, STR + 2
        INT 21H
    RET
ENDP

INHOA PROC
    LEA SI, STR + 2
    LAP2:
        CMP [SI], 13
        JE IN2
        AND [SI], 0DFH ; CHUYEN KY TU -> HOA
        INC SI
        JMP LAP2
    IN2:
        MOV AH, 9
        LEA DX, STR + 2
        INT 21H
    RET
ENDP