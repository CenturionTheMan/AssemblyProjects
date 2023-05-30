all: integral

integral: integralCaller.c integral.s
	gcc -no-pie -m64 integral.s integralCaller.c -o integral -fPIE
