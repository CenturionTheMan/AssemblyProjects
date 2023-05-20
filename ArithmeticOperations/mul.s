#Program mnozy dwie liczby

#print /x (long[]) wynik
.section .data
#Przyklady
#1) 0x000000a0, 0x10000001 X 0x00000900, 0x10020000 = 5a09a 02402900 10020000
#2) 0xab5329fe, 0x97eaf79e, 0x803610a2, 0x014f2379 X 0x987de98a, 0x65f7e9a3, 0x012f4e8a = 660DA4D5 FBCEC56E 83192B2D 109E0533 45204D6B 19619770 CDAEFD3A

liczba1: #Pierwsza liczba
    .long 0x00000002
    liczba1_len = (.-liczba1) #Ilosc bajtow zajmowanych przez liczbe1
    liczba1_amount = liczba1_len/4; #Ilosc liczb 4 bajtowych w liczbie 1

liczba2: #Druga liczba
    .long 0x00000008
    liczba2_len = (.-liczba2) #Ilosc bajtow zajmowanych przez liczbe2
    liczba2_amount = liczba2_len/4; #Ilosc liczb 4 bajtowych w liczbie 2


.section .bss
wynik:
    .space liczba1_len + liczba2_len

.section .text
.global _start

#Deklaracje stalych
SYSEXIT = 1
EXIT_SUCCESS = 0
INTERUPT = 0x80

#entry point
#esi - licznik zew
#edi - licznik wew
#mul -> wynik to 
_start:
    #index zew edx - eax
    movl $liczba2_amount, %esi

LOOP_OUT:
    cmpl $0, %esi
    je END
    decl %esi
    #index wew
    movl $liczba1_amount, %edi
    LOOP_IN:
        cmpl $0, %edi
        je LOOP_OUT
        decl %edi
        movl liczba2(,%esi,4), %eax
        movl liczba1(,%edi,4), %edx
        clc 
        mull %edx
        jmp YOUNGER_ADD

#licznik dodawanie ecx
YOUNGER_ADD:
    movl %esi, %ecx
    addl %edi, %ecx
    incl %ecx
    temp:
    adcl %eax, wynik(,%ecx,4)
OLDER_ADD:
    decl %ecx
    adcl %edx, wynik(,%ecx,4)
    jc ADD_UNTIL_NO_CARRY
    jnc LOOP_IN

ADD_UNTIL_NO_CARRY:
    decl %ecx
    addl $1, wynik(,%ecx,4)
    jc ADD_UNTIL_NO_CARRY
    jnc LOOP_IN

#Konczy program
END:
    hlt
    movl $SYSEXIT, %eax
    movl $EXIT_SUCCESS, %ebx
    int $INTERUPT
   
