.Model Small
.Stack 100H
.Data

    TV DB 'Xin chao$'
    TA DB 10, 13, 'Hello$'

.Code
MAIN PROC
    MOV AX, @Data
    MOV DS, AX
    
    MOV AH, 9
    LEA DX, TV
    INT 21H
    
    LEA DX, TA
    INT 21H    
    
    MOV AH, 4CH
    INT 21H
ENDP