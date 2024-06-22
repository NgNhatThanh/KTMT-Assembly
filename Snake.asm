.Model Small
.Stack 100h
.Data
    ;main menu
    t0 DB "   _____ _   _          _  ________ "
    t1 DB "  / ____| \ | |   /\   | |/ /  ____|"
    t2 DB " | (___ |  \| |  /  \  | ' /| |__   "
    t3 DB "  \___ \| . ` | / /\ \ |  < |  __|  "
    t4 DB "  ____) | |\  |/ ____ \| . \| |____ "
    t5 DB " |_____/|_| \_/_/    \_\_|\_\______|"
    main1 DB "Press any key to start..."
    ;bild
    hlths DB "Lives:",3,3,3
    ;ingame
    letadd DW ? ; dia chi cua *
    hlth DB 6 ; /2 la luong mau
    ;Snake Info            
    start_position equ 1000 ; vi tri o giua man hinh
    sadd DW start_position, 100 Dup(0) ;dia chi cac ky tu cua ran tren console
    snake DB '@',100 Dup(0) ; cac ky tu cua ran
    snakel DB 1 
    ;end 
    
    sc DB "Score: $"
    score DB 0
    gmov DB "Game Over"
    endtxt DB "Restart ? (y / n)"
    
    two DW 2
    map DW 1755
    et DW 80
    

.Code
start:
    MOV AX, @Data
    MOV DS, AX
    
    MOV AX, 0b800h
    MOV ES, AX 
    
    MOV AH, 0
    MOV AL, 0
    INT 10h ; set man hinh 40 x 25
    
    CLD ;clear direction flag
    
    ;hide text cursor
    MOV AH, 1
    MOV CH, 2BH
    MOV CL, 0BH
    INT 10h  
    
    CALL main_menu
    
    startag:
    CALL clearall
    
    MOV sadd, start_position ; dat ran o vi tri bat dau      
    CALL bild 
    
    XOR CL, CL 
    XOR DL, DL ; xoa ky tu cu o buffer
    read: ; kiem tra input
        MOV AH, 1
        INT 16H
        JZ left
        MOV AH, 0
        INT 16H ; lay input tu buffer
        AND AL, 0dfh  ; chuyen ky tu nhap vao in thuong -> in hoa
        MOV DL,AL
    
    left:
        CMP DL, 'A'
        JNE right
        CALL ml
        MOV CL, DL
        JMP read
    
    right:
        CMP DL, 'D'
        JNE up
        CALL mr
        MOV CL, DL
        JMP read
    
    up:
        CMP DL, 'W'
        JNE down
        CALL mu 
        MOV CL, DL
        JMP read
    
    down:
        CMP DL, 'S'
        JNE read1
        CALL md
        MOV CL, DL
        JMP read
    
    read1:
        MOV DL, CL
        JMP read
    
    
    ext:
        MOV AH, 4CH
        INT 21h     
ends 


main_menu PROC
    MOV DI, 482
    LEA SI, t0
    MOV CX, 36
    d0:
        movsb
        INC DI
        LOOP d0
    
    MOV DI, 562
    LEA SI, t1
    MOV CX, 36
    d1:
        movsb
        INC DI
        LOOP d1
    
    MOV DI, 642
    LEA SI, t2
    MOV CX, 36
    d2:
        movsb
        INC DI
        LOOP d2 
    
    MOV DI, 722
    LEA SI, t3
    MOV CX, 36
    d3:
        movsb
        INC DI
        LOOP d3 

    MOV DI, 802
    LEA SI, t4
    MOV CX, 36
    d4:
        movsb
        INC DI
        LOOP d4
    
    MOV DI, 882
    LEA SI, t5
    MOV CX, 36
    d5:
        movsb
        INC DI
        LOOP d5
        
    MOV DI, 1134
    LEA SI, main1
    MOV CX, 25
    m1:
        movsb
        INC DI
        LOOP m1
        
    MOV AH, 7
    INT 21h
    RET 
main_menu ENDP



;Game screen 
bild PROC ; ve border, score, lives, ran va * len man hinh
    ;start point
    CALL border 

    CALL print_score
    
    LEA SI, hlths
    MOV DI, 60
    MOV CX, 9
    loph:
        MOVSB
        INC DI 
        LOOP loph
        
        
    XOR DX, DX 
    MOV DI, sadd ; vi tri bat dau cua ran (o giua man hinh)
    MOV DL, snake 
    ES: MOV [DI], DL  ; dat ran len man hinh
        
    CALL place_food
    RET
bild ENDP  

;snake move:
;left:
ml PROC ; di chuyen sang trai
    PUSH DX 
    CALL shift_addrs
    SUB sadd,2
    
    CALL eat
    
    CALL move_snake
    POP DX
RET    
ENDP
;right:
mr PROC ; di chuyen sang phai
    PUSH DX 
    CALL shift_addrs
    ADD sadd,2
    
    CALL eat
    
    CALL move_snake 
    
    POP DX
    
RET    
ENDP
;up:
mu PROC ; di chuyen len tren
    PUSH DX 
    CALL shift_addrs
    SUB sadd,80
    
    CALL eat
    
    CALL move_snake
    POP DX
RET    
ENDP
;down:
md PROC ; di chuyen xuong duoi
    PUSH DX 
    CALL shift_addrs
    ADD sadd,80
    
    CALL eat
    
    CALL move_snake
    POP DX
RET    
ENDP

shift_addrs PROC
    PUSH AX
    XOR CH, CH
    XOR BH, BH
    MOV CL, snakel
    INC CL 
    MOV AL, 2
    MUL CL
    MOV BL, AL
    
    XOR DX, DX
    
    shiftsnake:
        MOV DX, sadd[BX-2]
        MOV sadd[BX], DX
        SUB BX, 2 ; cac phan tu trong sadd cach nhau 2
                  ; vi sadd co kieu du lieu la DW
        LOOP shiftsnake:
    POP AX
    RET
ENDP

eat PROC ; kiem tra ran co va cham voi border, *, hay tu an chinh no khong
    PUSH AX 
    PUSH CX 
    
    MOV DI, sadd 
    ES: CMP [DI], 0 
    JZ no
    ES: CMP [DI], 20h
    JZ wall
    ES: CMP [DI], '*'
    JE addf
    JNE wallk ; ran tu an minh

    addf:
        INC score
        MOV letadd, 0 
        XOR BH,BH
        MOV BL,snakel
        MOV snake[BX],'o'
        ES: MOV [DI], 0
        ADD snakel,1 
        CALL print_score
        CALL place_food
        JMP no
    wall:
        CMP DI, 160 
        JBE wallk ; cham tuong tren
        CMP DI, 1920
        jae wallk  ; cham tuong duoi
        MOV AX, DI
        MOV BL, 80
        DIV BL
        CMP AH, 0
        JZ wallk ; cham tuong trai
        MOV AX, DI
        ADD AX, 2
        MOV BL, 80
        DIV BL
        CMP AH,0
        JZ wallk ; cham tuong phai
        JMP no
    wallk:
        XOR BH, BH
        MOV BL, hlth
        SUB hlth, 2
        CMP hlth, 0
        JNZ rest
        ES: MOV [BX+72], 0
        POP CX
        POP AX
        CALL game_over 
    rest:
        ES: MOV [BX+72], 0 
        MOV hlths[BX+2], 0
        POP CX
        POP AX
        CALL restart
    no:
        POP CX
        POP AX
RET
ENDP 


place_food PROC ; dat * o vi tri ngau nhien
    PUSH AX
    PUSH DX
    lap:    
        MOV AH, 00h
        INT 1AH ; lay system time, luu o DX
        
        MOV AX, DX
        XOR DX, DX
        DIV map
        ADD DX, 162
        MOV BX, DX 
        
        MOV AX, DX  
        XOR DX, DX
        DIV two
        CMP DX, 0
        JNE lap
        
    XOR DX, DX 
    MOV AX, BX
    DIV et
    CMP DX, 0
    JE inleft
    
    XOR DX, DX    
    MOV AX, BX
    ADD AX, 2
    DIV et
    CMP DX, 0
    JE inright

    inleft:
        ADD BX, 2
        JMP spawn
        
    inright:
        SUB BX, 2
        
    spawn:    
        ES:MOV [BX], '*'
        MOV letadd, BX
    POP DX
    POP AX 
    RET
place_food ENDP



move_snake PROC
    XOR CH, CH
    XOR SI, SI
    XOR DL, DL
    MOV CL, snakel
    XOR BX, BX
    l1mr:
        MOV DI, sadd[SI]
        MOV DL, snake[BX]
        ES: MOV [DI], DL
        ADD SI, 2
        INC BX
        LOOP l1mr
    MOV DI, sADD[SI] 
    ES:MOV [DI],0
    RET
move_snake ENDP

border PROC ; ve border
    MOV AH, 0
    MOV AL, 0
    INT 10h  ; chuyen man hinh -> 40 x 25
    
    MOV AH, 6
    MOV AL, 0 
    MOV BH, 0ffh ; mau cua border
    
    MOV CH, 1
    MOV CL, 0
    MOV DH, 1
    MOV DL, 39
    INT 10h ; tren
  
    MOV CH, 1
    MOV CL, 0
    MOV DH, 24
    MOV DL, 0
    INT 10h ; trai
   
    MOV CH, 24
    MOV CL, 0
    MOV DH, 24
    MOV DL, 39
    INT 10h ; duoi
    
    MOV CH, 1
    MOV CL, 39
    MOV DH, 24
    MOV DL, 39
    INT 10h ; phai

RET
ENDP



print_score PROC
    MOV AH, 2
    MOV DH, 0
    MOV DL, 0
    MOV BH, 0
    INT 10h ; di chuyen con tro ve vi tri (0, 0)
    
    MOV AH, 9
    LEA DX, sc
    INT 21h
    
    MOV AX, 0
    MOV AL, score
    MOV CX, 0
    MOV BX, 10
    PUSH_STACK:
        MOV DX, 0
        DIV BX
        INC CX
        PUSH DX
        CMP AX, 0
        JNE PUSH_STACK
        
    POP_STACK:
        POP AX  ; AX = Stack.top() ; Stack.pop()
        MOV DL, AL
        ADD DL, '0'
        MOV AH, 2
        INT 21h
        LOOP POP_STACK 
    RET
print_score ENDP



restart PROC
    CALL clearall
    MOV snakel, 1
    MOV BX, start_position
    MOV sadd, BX  
    MOV snake[0],'@'
    JMP startag

ENDP


game_over PROC
    MOV hlths[6], 3
    MOV hlths[7], 3
    MOV hlths[8], 3
    MOV score, 0
    MOV hlth, 6
    MOV snakel, 1
    
    MOV DI, 992
    LEA SI, gmov
    MOV CX, 9
    loop1:
        movsb 
        INC DI
        LOOP loop1
        
    MOV DI, 1064
    LEA SI,endtxt
    MOV CX,17
    loop2:
        movsb 
        INC DI
        LOOP loop2 
        
    option:         
        MOV AH, 7
        INT 21h
        CMP AL, 'y'   
        JE startag
        CMP AL, 'n'
        JE ext
        JMP option
ENDP

clearall PROC
    XOR CX, CX
    MOV DH, 24
    MOV DL, 39
    MOV BH, 7
    MOV AX, 700h
    INT 10h 
RET

ENDP    

