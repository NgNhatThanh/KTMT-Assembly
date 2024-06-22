.Model Small
.Stack 100H
.Data                   
    TB DB 'Nhap vao chuoi: $'  
    TB2 DB 10, 13, 'So lan xuat hien cua 'ktmt' la: $'
    ENDL DB 10, 13, '$'
    SAMP DB 'ktmt'
    NUM DW ?
    CNT DW 0
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
    MOV SI, 0
    MOV AH, 1
NHAP_KY_TU:
    INT 21H
    CMP AL, 13
    JE END_INP
    CMP AL, SAMP[SI]
    JE TRUNG1
    MOV SI, 0
    JMP NHAP_KY_TU
    
TRUNG1:
    CMP SI, 3
    JE TRUNG_HET
    INC SI
    JMP NHAP_KY_TU

TRUNG_HET:
    INC CNT
    MOV SI, 0
    JMP NHAP_KY_TU
    
END_INP:
    PRINT_STR TB2
    MOV AX, CNT
    CALL IN_SO
    
    MOV AH, 4CH
    INT 21H
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