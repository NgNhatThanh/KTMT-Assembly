.Model Small
.Stack 100H
.Data                   
    TB DB 'Nhap so luong phan tu: $'  
    TB1 DB 10, 13, 'Nhap cac phan tu: $'
    TB2 DB 10, 13, 'So luong so chia het cho 11 la: $'
    TB3 DB 10, 13, 'Tong cac so chia het cho 11 la: $'
    ENDL DB 10, 13, '$'
    NUM DW ?
    CNT DW ?
    SUM DW ?
    TEN DW 10
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
    CALL NHAP_SO
    MOV CX, NUM
    
    PRINT_STR TB1
NHAP_PHAN_TU:
    CALL NHAP_SO
    CALL KIEM_TRA_CHIA_HET
    LOOP NHAP_PHAN_TU
    
    PRINT_STR TB2
    MOV AX, CNT
    CALL IN_SO
    
    PRINT_STR TB3
    MOV AX, SUM
    CALL IN_SO
    
    MOV AH, 4CH
    INT 21H
ENDP


KIEM_TRA_CHIA_HET PROC
    MOV BX, 11
    MOV DX, 0
    MOV AX, NUM
    DIV BX
    CMP DX, 0
    JNE KT
    INC CNT
    MOV AX, NUM
    ADD SUM, AX
KT: RET
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
    PRINT_STR ENDL
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