#Program odejmuje dwie liczby, zakłada ze sa rownej dlugosci
#Wynik w gdb - x /5x $esp
.section .data
liczba1: #Pierwsza liczba (odjemna)
    .long 0x10000000, 0x7000000F, 0x10000000, 0x02510000
    liczba1_len = (.-liczba1) #Ilosc bajtow zajmowanych przez liczbe1
    liczba1_amount = liczba1_len/4; #Ilosc liczb 4 bajtowych w liczbie 1

liczba2: #Druga liczba (odjemnik)
    .long 0x00000000, 0x50000000, 0xF0000000, 0x01400000
    liczba2_len = (.-liczba2) #Ilosc bajtow zajmowanych przez liczbe2
    liczba2_amount = liczba2_len/4; #Ilosc liczb 4 bajtowych w liczbie 2

#WYNIKI CZASTKOWE DLA TYCH WARTOSCI:
# ffffffff | (taken) d0000000 | 2000000e | (taken) 20000000 | 1110000

.section .text
.global _start

#Deklaracje stalych
SYSEXIT = 1
EXIT_SUCCESS = 0
INTERUPT = 0x80

#entry point
_start:
    clc
    jmp F_MAIN_ADD

F_MAIN_ADD:
    #esi - Indexer zmiennej liczba1 i liczba2
    movl $liczba1_amount, %esi

    LOOP_BEG:
        #zmnijeszanie indexu
        decl %esi
        #odejmowanie z przeniesieniem podliczb
        movl liczba1(,%esi,4), %eax
    C1:
        sbbl liczba2(,%esi,4), %eax
        pushl %eax
    STACK_UPDATE:

        #jezeli koniec liczby to zobacz czy nie ma przeniesienia
        pushf
        cmpl $0, %esi
        je SUB_IF_OVERFLOW_EQUAL
        popf
        #inczej wracaj na poczatek petli
        jmp LOOP_BEG 

SUB_IF_OVERFLOW_EQUAL:
    #jezeli nie ma przeniesienia, zakoncz
    popf
    jnc END
    #zerowanie indexu
    xor %eax, %eax
    #dodanie przeniesienia jezeli jest
    movl $0xffffffff, %eax
    #wrzucenie wyniku na index 0 do zmiennej result
    OVERFLOW:
    pushl %eax
    #wywolanie bloku przerwania
    jmp END

#Konczy program
END:
    movl $SYSEXIT, %eax
    movl $EXIT_SUCCESS, %ebx
    int $INTERUPT
   
