.Model Small
.Stack 100H
.Data                   
    TB DB 'So luong phan tu cua mang: $'  
    TB1 DB 10, 13, 'Nhap cac phan tu: $'
    TB2 DB 10, 13, 'Tong cac phan tu la: $'
    ENDL DB 10, 13, '$'
    NUM DW ?
    SUM DW 0
    TEN DW 10
.Code

MAIN PROC
    MOV AX, @Data
    MOV DS, AX
    
    MOV AH, 9
    LEA DX, TB
    INT 21H
    CALL NHAP_SO
    MOV CX, NUM
    
    MOV AH, 9
    LEA DX, TB1
    INT 21H
    
NHAP_MANG:
    CALL NHAP_SO
    MOV AX, NUM
    ADD SUM, AX
    LOOP NHAP_MANG
    
    MOV AH, 9
    LEA DX, TB2
    INT 21H
    
    MOV AX, SUM
    CALL IN_SO

    MOV AH, 4CH
    INT 21H
ENDP


NHAP_SO PROC ; NHAP VAO SO, LUU VAO NUM
    MOV DX, 0
    MOV BX, 0
INP:   
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE END_INP
    MOV BL, AL
    MOV AX, DX
    MUL TEN
    SUB BL, '0'
    ADD AX, BX
    MOV DX, AX
    JMP INP
END_INP:
    MOV NUM, DX
    LEA DX, ENDL ; XUONG DONG SAU KHI NHAP
    MOV AH, 9
    INT 21H
    RET
ENDP



IN_SO PROC ; IN RA SO DANG DUOC LUU O AX
    MOV CX, 0
PUSH_ST:
    MOV DX, 0
    DIV TEN
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PUSH_ST
    
POP_ST:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP POP_ST
    RET
ENDP