.Model Small
.Stack 100H
.Data                   
    TB DB 'Nhap so n: $'  
    TB1 DB 10, 13, 'n! = $'
    ENDL DB 10, 13, '$'
    NUM DW ?
    TEN DW 10
.Code

MAIN PROC
    MOV AX, @Data
    MOV DS, AX
    
    MOV AH, 9
    LEA DX, TB
    INT 21H
    CALL NHAP_SO
    
    MOV AH, 9
    LEA DX, TB1
    INT 21H
    
    CALL GIAI_THUA
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

GIAI_THUA PROC ; TINH GIAI THUA CUA NUM, LUU VAO AX
    MOV CX, NUM
    MOV BX, 1
    MOV AX, 1
LAP:
    MUL BX
    INC BX
    LOOP LAP
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