.Model Small
.Stack 100H
.Data                   
    TB DB 'So luong phan tu cua mang: $'  
    TB1 DB 10, 13, 'Nhap cac phan tu: $'
    TB2 DB 10, 13, 'Gia tri lon nhat la: $'
    TB3 DB 10, 13, 'Gia tri nho nhat la: $'
    ENDL DB 10, 13, '$'
    MAX DW 0
    MIN DW 65535
    NUM DW ?
    TEN DW 10
.Code

; CHI NHAP SO KHONG AM < 2^16
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
    CALL SO_SANH
    LOOP NHAP_MANG
    
    MOV AH, 9
    LEA DX, TB2
    INT 21H
    MOV AX, MAX
    CALL IN_SO
    
    MOV AH, 9
    LEA DX, TB3
    INT 21H
    MOV AX, MIN
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


SO_SANH PROC ; SO SANH NUM VOI MAX, MIN
    MOV AX, NUM
    CMP AX, MAX
    JA NEW_MAX
SSS: 
    CMP AX, MIN
    JB NEW_MIN
    RET
NEW_MAX:
    MOV MAX, AX
    JMP SSS
NEW_MIN:
    MOV MIN, AX
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