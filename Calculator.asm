.Model Small
.Stack 100H
.Data

titlee DB "            _            _       _             ", 13, 10 
      DB "           | |          | |     | |            ", 13, 10
      DB "   ___ __ _| | ___ _   _| | __ _| |_ ___  _ __ ", 13, 10
      DB "  / __/ _` | |/ __| | | | |/ _` | __/ _ \| '__|", 13, 10
      DB " | (_| (_| | | (__| |_| | | (_| | || (_) | |   ", 13, 10
      DB "  \___\__,_|_|\___|\__,_|_|\__,_|\__\___/|_|   ", 13, 10, '$'

tb DB 13, 10, "Ung dung nay chi nhan input la so nguyen trong doan [-32767, 65535],", 13, 10
   DB "ket qua dau ra se chinh xac neu nam trong doan [-32767, 32767]", 13, 10, '$'

scan1Tb DB 13, 10, 13, 10, "Nhap so thu nhat: $"
scanOprTb DB 13, 10, "Nhap toan tu (+, -, *, /, %, ^): $"
scan2Tb DB 13, 10, "Nhap so thu hai: $"
ansTB DB 13, 10, 13, 10, 'Ket qua cua phep toan la: $'
overflow_errorTb DB 'ket qua nam ngoai pham vi [-32767, 32767]$'
dbz_errorTB DB 'loi khi chia cho so 0$'
sign_exp_errorTb DB 'khong the tinh toan so mu am$'
doneTb DB 13, 10, 13, 10, 'Ban co muon tiep tuc tinh toan khong ? (y/n) $'

precision equ 7 ; so chu so sau dau phay cua so thap phan
opr DB ?
num1 DW ?
num2 DW ?

enter_key DB 0DH
backspace_key DB 8

.Code

print_str MACRO str
    PUSH AX
    MOV AH, 9
    LEA DX, str
    INT 21H
    POP AX
ENDM

print_char MACRO char
    PUSH AX
    MOV AL, char
    MOV AH, 0EH
    INT 10H
    POP AX
ENDM

main proc
MOV AX, @Data
MOV DS, AX   

start:
    print_str titlee
    print_str tb
    
    print_str scan1Tb
    CALL scan_num
    MOV num1, CX

    print_str scanOprTb
scan_opr:    
    MOV AH, 1
    INT 21H ; nhap toan tu
    CMP AL, '+'
    JE next_num
    CMP AL, '-'
    JE next_num
    CMP AL, '*'
    JE next_num
    CMP AL, '/'
    JE next_num
    CMP AL, '%'
    JE next_num
    CMP AL, '^'
    JE next_num
    ; nhap vao sai toan toan tu
    print_char backspace_key
    print_char ' '
    print_char backspace_key ; xoa toan tu sai vua nhap 
    JMP scan_opr
    MOV opr, AL
    
next_num:    
    print_str scan2Tb
    CALL scan_num
    MOV num2, CX
    
    print_str ansTb
    CMP AL, '+'
    JE plus
    CMP AL, '-'
    JE minus
    CMP AL, '*'
    JE multiply
    CMP AL, '/'
    JE divide
    CMP AL, '%'
    JE modulo
    CMP AL, '^'
    JE exponentiation

done:
    print_str doneTb
scan_key:
    MOV AH, 1
    INT 21H
    CMP AL, 'y'
    JE restart
    CMP AL, 'n'
    JE end
    print_char backspace_key
    print_char ' '
    print_char backspace_key
    JMP scan_key

end:
    MOV AH, 4CH
    INT 21H 
    
restart:
    MOV DX, 0
    MOV CX, 0
    MOV BX, 0
    MOV AX, 3
    INT 10H ; xoa sach man hinh console
    JMP start
main endp



plus:
    MOV DX, 0
    MOV AX, num1
    ADD AX, num2
    JC num_overflow
    JO num_overflow
    CALL print_num
    JMP done


minus:
    MOV DX, 0
    MOV AX, num1
    SUB AX, num2
    JO num_overflow
    CALL print_num
    JMP done
    
    
multiply:
    MOV AX, num1
    IMUL num2
    CMP DX, 0
    JNE num_overflow
    CALL print_num
    JMP done
    
    
divide:
    MOV DX, num2
    CMP DX, 0
    JE divide_by_zero
    MOV DX, 0 ; DX se luu phan du cua phep chia
    MOV AX, num1
    IDIV num2 ; AX = (DX AX) / num2
    CALL print_num
    JMP done
    
modulo:
    MOV DX, 0
    MOV AX, num1
    IDIV num2 ; DX luu phan du cua num1 / num2
    MOV AX, DX ; chuyen phan du sang AX de in ra
    MOV DX, 0
    CALL print_num
    JMP done
    
exponentiation:
    MOV CX, num2
    CMP CX, 0
    JS sign_exp
    JE zero_exp
    DEC CX
    MOV DX, 0
    MOV AX, num1
    MOV BX, num1; ban sao cua num1
    lap:
        MOV DX, 0
        IMUL BX
        CMP DX, 0
        JNE num_overflow
        LOOP lap
    CALL print_num
    JMP done
    zero_exp:
        print_char '1'
        JMP done
    
    
sign_exp:
    print_str sign_exp_errorTb
    JMP done

divide_by_zero:
    print_str dbz_errorTb
    JMP done

num_overflow:
    print_str overflow_errorTb
    JMP done


; Ham nhap vao so nguyen va luu vao thanh ghi CX
scan_num proc
    PUSH DX
    PUSH AX
    PUSH SI
    
    MOV CX, 0
    MOV CS:minus_flag, 0
next_digit: ; nhap ky tu va luu vao AL, in ra ky tu do
    MOV AH, 1
    INT 21H
    
    CMP AL, '-'
    JE set_minus
    
    CMP AL, enter_key; kiem tra ky tu la phim Enter
    JNE not_enter_key
    JMP stop_input
    
not_enter_key:
    CMP AL, backspace_key; kiem tra phim BACKSPACE
    JNE backspace_checked
    MOV DX, 0
    MOV AX, CX ; AX = so truoc do nhap vao
    DIV CS:ten ; AX = (DX AX) / 10 (DX luu phan du)
    MOV CX, AX
    print_char ' '
    print_char backspace_key 
    JMP next_digit
    
backspace_checked:
    CMP AL, '0'
    JB remove_invalid_digit
    CMP AL, '9'
    JA remove_invalid_digit
    JMP valid_digit
    
remove_invalid_digit:
    print_char backspace_key
    print_char ' '
    print_char backspace_key
    JMP next_digit
    
valid_digit:
    PUSH AX
    MOV AX, CX
    MUL CS:ten  ; (DX AX) *= 10
    MOV CX, AX
    POP AX
    
    CMP DX, 0 ; kiem tra neu so nhap vao khong nam trong
              ; doan [-32767, 65535]
    JNE too_big
    
    SUB AL, 30H ; chuyen ky tu so -> so
    MOV AH, 0
    MOV DX, CX ; ban sao cua CX
    ADD CX, AX
    JC too_big2
    JMP next_digit
 
too_big2: ; big2 dat truoc big vi deu can xoa ky tu vua nhap
    MOV CX, DX ; tra lai gia tri ban sao da luu cho CX
    MOV DX, 0 
        
too_big:
    MOV AX, CX
    DIV ten ; loai bo so vua nhap, AX = (DX AX) /= 10
    MOV CX, AX
    print_char backspace_key  ; loai bo ky tu vua nhap
    print_char ' '            ; va di chuyen con tro nhap
    print_char backspace_key  ; den vi tri cu
    JMP next_digit
    
set_minus:
    MOV CS:minus_flag, 1
    JMP next_digit
    
stop_input:
    CMP CS:minus_flag, 0
    JE not_minus
    NEG CX ; dao dau CX
    
not_minus:
    POP SI
    POP AX
    POP DX
    RET
minus_flag DB ? ; dung lam flag danh dau so am
scan_num endp


ten DW 10 ; dung lam so chia de loai bo ky tu cuoi


print_num proc   
    PUSH DX
    PUSH AX
    
    CMP AX, 0
    JNZ not_zero
    
    print_char '0'
    JMP fraction_check
    
not_zero:
    CMP AX, 0
    JNS positive
    NEG AX
    print_char '-'
    
positive:
    CALL print_num_uns
    
fraction_check:
    CMP DX, 0
    JE printed
    CALL print_fractional_part
    
printed:
    POP AX
    POP DX
    RET
print_num endp




print_num_uns proc
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 1
    
    MOV BX, 10000
    
    CMP AX, 0
    JE print_zero
    
begin_print:
    CMP BX, 0
    JE end_print
    
    CMP CX, 0
    JE calc
    
    CMP AX, BX
    JB skip
    
calc:
    MOV CX, 0
    
    MOV DX, 0
    DIV BX ; AX = (DX AX) / BX (DX luu phan du)
    
    ADD AL, 30H  ; chuyen so -> ky tu so
    print_char AL
    
    MOV AX, DX
    
skip:
    PUSH AX
    MOV DX, 0
    MOV AX, BX
    DIV CS:ten
    MOV BX, AX
    POP AX
    
    JMP begin_print
    
print_zero:
    print_char '0'
    
end_print:
    POP DX
    POP CX
    POP BX
    POP AX
    RET  
print_num_uns endp



print_fractional_part proc
    MOV CX, precision
    MOV BX, num2

    print_char ','
next_fraction:    
    CMP CX, 0
    JE print_extend
    DEC CX
    
    CMP DX, 0
    JE end_pr
    
    MOV AX, DX
    MOV DX, 0

    IMUL CS:ten ; (DX AX) = AX * 10
    IDIV BX  ; AX = (DX AX) / num2
    PUSH DX
    MOV DX, AX
    CMP DX, 0
    JNS not_sig
    NEG DX
    
not_sig:
    ADD DL, 30H
    print_char DL
    POP DX
    
    JMP next_fraction

print_extend:
    mov al, '.'
    mov ah, 0eh
    int 10h 
    int 10h
    int 10h
    
end_pr: RET
print_fractional_part endp