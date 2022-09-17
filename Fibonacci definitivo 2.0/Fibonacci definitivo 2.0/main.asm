;
; Fibonacci definitivo 2.0.asm
;
; Created: 01/04/2022 10:23:37 a. m.
; Author : Johan Lee
;



	   .dseg 
serie:	.byte 0x20		;Reserva 32 espacios de memoria para el array de valores
cont:	.byte 1			;Reserva 1 espacio de memoria para el contador
semill:	.byte 1			;Reserva 1 espacio de memoria para el valor semilla
desp:	.byte 1			;Reserva 1 espacio de memoria para el valor desp
       .cseg


set_up:

    ldi r16, 1			;Carga el valor de 1 al R16
    sts semill, r16		;Carga el valor de R16 a la semilla 
    ldi r16, 16			;Carga el valor de 16 a R16
    sts cont, r16		;Carga el valor de R16 al contador
	ldi r16, 4			;Carga el valor de 4 a R16
    sts desp, r16		;Carga el valor de R16 al contador

main:
    ldi r26,low (serie)		;Inicializando el apuntador X
    ldi r27, high (serie)	
    clr r16					;Limpia R16
    st x+, r16				;Carga el valor del R16 al X lsb y luego aumenta 1 al R26 
    st x+, r16				;Carga el valor del R16 al X msb y luego aumenta 1 al R26
    dec r26					;Decrementa uno al R26 (dirección del puntero)
    lds r19, semill			;Le carga el valor de semill al R19
    lds r20, cont			;Le carga el valor de cont al R20
    dec r20					;Decrementa uno al R20 (cont)
	ld r0, x+				;Carga el valor de X lsb al R0, y luego aumenta 1 al R26
    add r0, r19				;Suma R0, y R2(semilla)
	st x+, r0				;Carga el valor del R0 al X lsb, y luego aumenta 1 al R26
    dec r20					;Decrementa uno al R20(cont)
	lds r18, desp			;Carga el valor de desp al R18


loop:
	
	ld r3, x				;Cargamos el MSB del segundo número
	dec r26					;Decrementa el valor de R26 (dirección del puntero)
	ld r2, x				;Cargamos el LSB del segundo número
	dec r26					;Decrementa el valor de R26 (dirección del puntero)
	ld r1, x				;Cargamos el MSB del primer número
	dec r26					;Decrementa el valor de R26 (dirección del puntero)
	ld r0, x				;Cargamos el LSB del primer número
	add r0, r2				;Hacemos la suma de los dos LSB
	adc r1, r3				;Hacemos la suma de los dos MSB
	add r26, r18			;Le sumamos R18 (4) al R26 (dirección del puntero), para poder escribir en los siguientes espacios de memoria
	st x+, r0				;Cargamos el valor del R0, al X LSB y luego aumenta 1
	st x, r1				;Cargamos el valor del R1, al X MSB
	dec r20					;Restamos uno al R20 (cont)
	brne loop				;Si se activa la flag Z debido al R20(cont), sale del loop
	rjmp main				;Brinca al main