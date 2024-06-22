.Model Small
.Stack 100H
.Data                   
    TB DB 'Nhap xau A: $'  
    TB1 DB 10, 13, 'Nhap xau B: $'
    TB2 DB 10, 13, 'So lan xuat hien cua xau B trong A la $'
    S1 DB 100 DUP('$')
    S2 DB 99 DUP('$')
    TEN DW 10
    OKE DB 0
.Code

IN_CHUOI MACRO STR
    MOV AH, 9
    LEA DX, STR
    INT 21H
ENDM

NHAP_CHUOI MACRO S
    MOV AH, 10
    LEA DX, S
    INT 21H
ENDM

MAIN PROC
    MOV AX, @Data
    MOV DS, AX
    
    IN_CHUOI TB
    NHAP_CHUOI S1
    
    IN_CHUOI TB1
    NHAP_CHUOI S2
    
    XOR CX, CX
    MOV CL, S1 + 1
    SUB CL, S2 + 1
    INC CX
    
    XOR BX, BX
    MOV SI, 2
LAP:
    MOV OKE, 0
    CALL KIEM_TRA_XAU_CON
    ADD BL, OKE
    INC SI
    LOOP LAP
    
    IN_CHUOI TB2
    MOV AX, BX
    CALL IN_SO
    
    MOV AH, 4CH
    INT 21H
ENDP


KIEM_TRA_XAU_CON PROC
    PUSH SI
    PUSH CX
    PUSH BX
    
    XOR CX, CX
    MOV CL, S2 + 1
    MOV BX, 2
LAP2:
    MOV AL, S1[SI]
    CMP AL, S2[BX]
    JNE KTHUCC
    INC SI
    INC BX
    LOOP LAP2  
    
    MOV OKE, 1

KTHUCC:    
    POP BX
    POP CX
    POP SI
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