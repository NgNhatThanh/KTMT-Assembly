.Model Small
.Stack 100h
.Data      

    TB1  DB 'Nhap vao so thap phan: $'
    TB2 DB 10, 13, 'So o he nhi phan: $'
    NUM DW 10 DUP('$')
    TWO DW 2
    TEN DW 10

; CHI NHAP SO < 2^16
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
    
    LEA DX, NUM
    MOV AH, 10
    INT 21H
    
    LEA SI, NUM + 2
    MOV AX, 0
DUYET_KY_TU:
    MUL TEN
    MOV BL, [SI]
    SUB BL, '0'
    MOV BH, 0
    ADD AX, BX
    INC SI
    CMP [SI], 13
    JNE DUYET_KY_TU
    
    PRINT_STR TB2
    INT 21H
    
    MOV CX, 0
    MOV AX, BX
PUSH_ST:
    INC CX
    XOR DX, DX
    DIV TWO
    PUSH DX
    CMP AX, 0
    JNE PUSH_ST

POP_ST:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP POP_ST
    
    MOV AH, 4CH
    INT 21H           
ENDP 