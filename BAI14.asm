.Model Small
.Stack 100H
.Data                   
    TB DB 'Nhap so thu nhat: $'  
    TB1 DB 10, 13, 'Nhap so thu hai: $'
    TB2 DB 10, 13, 'UCLN = $'
    TB3 DB 10, 13, 'BCNN = $'
    ENDL DB 10, 13, '$'
    NUM DW ?
    N1 DW ?
    N2 DW ?
    UCLN DW ? 
    BCNN DW ?
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
    MOV AX, NUM
    MOV N1, AX
    
    PRINT_STR TB1
    CALL NHAP_SO
    MOV AX, NUM
    MOV N2, AX
    
    PRINT_STR TB2
    CALL UCLN_CAL
    MOV AX, UCLN
    CALL IN_SO
    
    PRINT_STR TB3
    CALL BCNN_CAL
    MOV AX, BCNN
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
    PRINT_STR ENDL
    RET
ENDP


UCLN_CAL PROC
    PUSH N1 ; LUU LAI GIA TRI N1, N2 VAO STACK
    PUSH N2
LAP:
    CMP N2, 0
    JE KT
    MOV AX, N1
    MOV BX, N2
    MOV DX, 0
    DIV N2
    MOV N2, DX
    MOV N1, BX
    JMP LAP
KT:
    MOV AX, N1
    MOV UCLN, AX
    POP N2 ; LAY LAI GIA TRI BAN DAU 
    POP N1
    RET
ENDP


BCNN_CAL PROC
    PUSH N1 ; LUU LAI GIA TRI N1, N2 VAO STACK
    PUSH N2
    MOV AX, N1
    MUL N2
    DIV UCLN
    MOV BCNN, AX
    POP N2 ; LAY LAI GIA TRI BAN DAU 
    POP N1
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