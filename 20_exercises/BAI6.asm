.Model Small
.Stack 100h
.Data      
    
    TB1  DB 'Nhap vao chuoi: $'
    TB2 DB 10, 13, 'Chuoi ky tu nguoc: $'

.Code

PRINT_STR MACRO STR
    MOV AH, 9
    LEA DX, STR
    INT 21H 
ENDM

MAIN PROC
    MOV AX, @Data
    MOV DS, AX 
    
    PRINT_STR TB1
     
    MOV CX, 0 ; DEM SO KY TU
    MOV AH, 1
NHAP_KY_TU:
    INC CX 
    INT 21H
    PUSH AX
    CMP AL, '#'
    JNE NHAP_KY_TU
    
    PRINT_STR TB2

POP_ST:
    POP AX
    MOV DL, AL
    MOV AH, 2
    INT 21H
    LOOP POP_ST
    
    MOV AH, 4CH
    INT 21H           
ENDP 