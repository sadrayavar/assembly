org 100h
.DATA ;data segment          
welcomeMessage db "Welcome to Sadra Yavarzadeh Herisi & Zahra Rostami's Assembly project$"
inputMessage   db "Type your desired text and press ENTER (Length <= 255):  $"
resultMessage   db "Sum of the texts are:  $"
continueMessage   db "Do you want to continue? (y/n)  $" 
byeMessage   db "Have a good luck.$" 
lineMessage db "---------------------------------------------------------$"

.CODE
;###################################################################  Macro 
pointerPrint macro pointer          ; chap reshteyi ke dar "pointer" bude va ba & tamam shode ast
    mov dx, pointer
    mov ah, 9
    int 21h
endm

stringPrint macro string            ; chap reshteye "string" ke dar axare an & mibashad
    lea dx, string
    pointerPrint dx
endm

getInput macro dest, maxLength      ; modiriate input  
    stringPrint inputMessage

    mov cx,dest                     ; dest --> di
    mov di,cx

    mov cx,maxLength                 
     
    call getString
    call newLine
endm 

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main code   

stringPrint welcomeMessage                  ; chap xoshamad va name aaza
call newLine
call newLine

main:
    getInput 0d00h, 10                      ; tebge macro getInput    
    getInput 0e00h, 255                     ; yek vurudi ba maximum tule 255 begir
    getInput 0f00h, 255                     ; va dar address gofte shode zaxire kon 
              
    call newLine

    stringPrint resultMessage
    pointerPrint 0d00h                      ; reshte nojud dar 0d00h ra chap kon
    pointerPrint 0e00h    
    pointerPrint 0f00h   

    call newLine
    call newLine

    ask:                                    ; porsesh baraye edame
        stringPrint continueMessage
        mov ah,1                            ; gereftan yek harf
        int 21h
        mov bl, al                          ; chon dasture zir(69) AL ra taqir midahad anra dar BL zaxire kardim
        call newLine                        

    cmp bl,79h                              ; agar vurudi "y" bud "tryAgain" ro ejra kon
    je tryAgain
    cmp bl,6eh
    je end                                  ; agar vurudi "n" bud "end" ro ejra kon
    jne ask                                 ; agar vurudi na "n" bud va na "y" anagah "ask" ro ejra kon
    
tryAgain:
    call border
    jmp main

end: 
    call border
    stringPrint byeMessage
    ret

;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Functions

newLine:            ; function baraye harekat be xatte jadid
    mov ah, 02h
     
    mov dx, 10      ; raftan be satre badi
    int 21h   
    
    mov dx, 13      ; raftan be avale satr
    int 21h
    ret  
                                                                                 
getString:                  ; tabeyi ke vurudi ra gerefte va dar axar an $ qarar midahad     
    mov ah,1                ; vurudi ro gerefte va dar dar AL beriz
    int 21h                              

    mov [di],al             ; AL ro be mahale DI beriz 
    
    inc di                  ; mahale zaxiresazi yedune jelo
    dec cx                  ; tule estefade shode yedune kam
    
    cmp cx,0                  
    je overflow             ; sharte1: agar tul=255 bepar be "overflow"

    cmp al, 0dh             
    je done                 ; sharte 2: agar vurudi=ENTER bud bepar be "done"

    jmp getString           ; agar hich kodam az shartha barqarar nabud: dobare vurudi begir

    done:     
        mov [di-1], '$'     ; be axare string $ ezafe kon
        ret
    overFlow:
        mov [di], '$'       ; be axare string $ ezafe kon
        ret 

border:                     ; yek xat dar terminal bekesh
    call newLine
    stringPrint lineMessage
    call newLine
    call newLine
    ret