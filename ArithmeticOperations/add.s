#Program dodaje dwie liczby, zakłada ze sa rownej dlugosci
#Wynik w gdb - x /5x $esp
.section .data
liczba1: #Pierwsza liczba
    .long 0x10304008, 0x701100FF, 0x45100020, 0x08570030
    liczba1_len = (.-liczba1) #Ilosc bajtow zajmowanych przez liczbe1
    liczba1_amount = liczba1_len/4; #Ilosc liczb 4 bajtowych w liczbie 1

liczba2: #Druga liczba
    .long 0x0040500C, 0x00220026, 0xF21000CB, 0x04520031
    liczba2_len = (.-liczba2) #Ilosc bajtow zajmowanych przez liczbe2
    liczba2_amount = liczba2_len/4; #Ilosc liczb 4 bajtowych w liczbie 2

#WYNIKI CZASTKOWE DLA TYCH WARTOSCI:
# (1 ovf)1,00709014 | 70330125 + (1 ovf) = 70330126 | (1 ovf)1,372000eb | ca90061

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
        #dodawanie z przeniesieniem podliczb
        movl liczba1(,%esi,4), %eax
    C1:
        adcl liczba2(,%esi,4), %eax
        pushl %eax
    STACK_UPDATE:

        #jezeli koniec liczby to zobacz czy nie ma przeniesienia
        pushf
        cmpl $0, %esi
        je F_ADD_IF_OVERFLOW_EQUAL
        popf
        #inczej wracaj na poczatek petli
        jmp LOOP_BEG 

F_ADD_IF_OVERFLOW_EQUAL:
    #jezeli nie ma przeniesienia, zakoncz
    popf
    jnc F_END
    #zerowanie indexu
    xor %eax, %eax
    #dodanie przeniesienia jezeli jest
    movl $1, %eax
    #wrzucenie wyniku na index 0 do zmiennej result
    OVERFLOW:
    pushl %eax
    #wywolanie bloku przerwania
    jmp F_END

#Konczy program
F_END:
    movl $SYSEXIT, %eax
    movl $EXIT_SUCCESS, %ebx
    int $INTERUPT
   
