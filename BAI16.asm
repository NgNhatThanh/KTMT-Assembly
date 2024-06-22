.Model Small
.Stack 100H
.Data                   
    TB DB 'a = $'  
    TB1 DB 10, 13, 'b = $'
    TB2 DB 10, 13, 'a + b = $'
    ENDL DB 10, 13, '$'
    NUM DW ?
    N1 DW ?
    N2 DW ?
    TEN DW 10
.Code

PRINT_STR MACRO STR
    MOV AH, 9
    LEA DX, STR
    INT 21H
ENDM

; CHI CONG 2 SO NGUYEN KHONG AM 16 BIT
MAIN PROC
    MOV AX, @Data
    MOV DS, AX
    
    PRINT_STR TB
    CALL NHAP_SO
    MOV AX, NUM
    MOV N1, AX
    
    PRINT_STR TB1
    CALL NHAP_SO
    MOV AX, NUM
    MOV N2, AX
    
    PRINT_STR TB2
    CALL TINH_TONG
    
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
    PRINT_STR ENDL
    RET
ENDP

TINH_TONG PROC
    XOR CX, CX
    XOR SI, SI; LAM BIEN DU
LAP:
    CMP N1, 0
    JNE TT
    CMP N2, 0
    JE XONG
TT:
    INC CX
    XOR DX, DX
    MOV AX, N1
    DIV TEN
    MOV BX, DX
    MOV N1, AX
    XOR DX, DX
    MOV AX, N2
    DIV TEN
    MOV N2, AX
    ADD DX, BX
    ADD DX, SI
    XOR SI, SI
    CMP DX, 10
    JB KHONG_DU 
    INC SI
    SUB DX, 10
KHONG_DU:
    PUSH DX
    JMP LAP
    
XONG:
    CMP SI, 0
    JE IN_SO
    PUSH SI
    INC CX
    
IN_SO:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP IN_SO
    RET
ENDP