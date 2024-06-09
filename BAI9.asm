.Model Small
.Stack 100h
.Data      

    TB1  DB 'Nhap vao so nhi phan 8 bit: $'
    TB2 DB 10, 13, 'So o he thap luc phan: $'
    SIXTEEN DW 16

.Code
MAIN PROC
    MOV AX, @Data
    MOV DS, AX 
    
    LEA DX, TB1
    MOV AH, 9
    INT 21H 
    
    MOV DX, 0
    MOV BX, 0
NHAP_KY_TU:
    MOV AH, 7 ; NHAP VAO KY TU NHUNG KHONG IN RA MAN HINH   
    INT 21H
    CMP AL, '#'
    JE KTHUC_NHAP
    CMP AL, '0'
    JL NHAP_KY_TU
    CMP AL, '1'
    JG NHAP_KY_TU
    INC BX
    MOV AH, 2
    MOV DL, AL
    PUSH DX
    INT 21H
    CMP BX, 8
    JL NHAP_KY_TU
    
KTHUC_NHAP:
    MOV CL, 0
    MOV AX, 0

CHUYEN_SANG_THAP_PHAN:
    POP DX
    SUB DL, '0'
    SHL DL, CL
    ADD AX, DX 
    INC CL
    DEC BX
    CMP BX, 0
    JG CHUYEN_SANG_THAP_PHAN
    
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