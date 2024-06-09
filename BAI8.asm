.Model Small
.Stack 100h
.Data      

    TB1  DB 'Nhap vao so thap phan: $'
    TB2 DB 10, 13, 'So o he thap luc phan: $'
    NUM DW 10 DUP('$')
    SIXTEEN DW 16
    TEN DW 10

; CHI NHAP SO < 2^16
.Code
MAIN PROC
    MOV AX, @Data
    MOV DS, AX 
    
    LEA DX, TB1
    MOV AH, 9
    INT 21H 
    
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
    
    MOV BX, AX
    MOV AH, 9
    LEA DX, TB2
    INT 21H
    
    MOV CX, 0
    MOV AX, BX
PUSH_ST:
    INC CX
    XOR DX, DX
    DIV SIXTEEN
    PUSH DX
    CMP AX, 0
    JNE PUSH_ST

POP_ST:
    POP DX
    ADD DL, '0'
    CMP DL, '9'
    JG CHUYEN_SANG_CHU
    JMP IN1

CHUYEN_SANG_CHU:
    SUB DX, '9' + 1
    ADD DX, 'A'    
    
IN1:
    MOV AH, 2
    INT 21H
    LOOP POP_ST
    
    MOV AH, 4CH
    INT 21H           
ENDP 