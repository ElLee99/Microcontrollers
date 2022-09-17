; Practica1.1.asm
; Created: 02/03/2022 11:21:52 a. m.
; Author : Johan Manuel García Zúñiga 19310416


start:

   ;Guardar los datos en los siguientes registros
   ;r20 = LSB V1
   ;r21 = MSB V1
   ;r22 = V2

   clr r20 ;Limpio registro 20
   clr r21 ;Limpio registro 21
   clr r22 ;Limpio registro 22
   ldi r20, 0b00011000 ;LSB V1
   ldi r21, 0b1 ;MSB V1
   ldi r22, 0b10100 ;LSB V2
   sts 0x0100, r20 ;En la dirección de memoria 0x0100 se guarda el valor de LSB V1
   sts 0x0101, r21 ;En la dirección de memoria 0x0101 se guarda el valor de MSB V1
   sts 0x0102, r22 ;En la dirección de memoria 0x0102 se guarda el valor de LSB V2

   ;Suma 
    lds r16, 0x0100 ;LSB V1
	lds r17, 0x0101 ;MSB V1
	lds r18, 0x0102 ;LSB V2
	ldi r19, 0 ;MSB V2
	add r16, r18 ;LSB SUMA
	adc r17, r19 ;MSB SUMA
	sts 0x0108, r16 ;Resultado LSB Suma
    sts 0x0109, r17 ;Resultado MSB Suma
	clc ;Limpio Carry

	;Resta
	lds r16, 0x0100 ;LSB V1
	lds r17, 0x0101 ;MSB V1
	lds r18, 0x0102 ;LSB V2
	ldi r19, 0 ;MSB V2
	sub r16, r18 ;LSB Resta
	sbc r17, r19 ;MSB Resta
    sts 0x0111, r17 ;Resultado MSB Resta
	sts 0x0110, r16 ;Resultado LSB Resta
	clc ;Limpio Carry

	;Multiplicación
	lds r16, 0x0100 ;LSB V1
	lds r17, 0x0101 ;MSB V1
	lds r18, 0x0102 ;LSB V2
	ldi r19, 0 ;MSB V2
	mul r16, r18
	clr r20
	clr r21
	tst r1
	tst r17
	brne var16true ;Si encuentra una variable de 16bits da un salto a var16true
	sts 0x0118, r0
	sts 0x0119, r1
	tst r1
	tst r17
	breq var8True ;Si encuentra una variable de 8bits da un salto a var16true

var16True:
	mov r20, r0
	mov r21, r1
	mul r17, r18
	add r21, r0
	sts 0x0118, r20
	sts 0x0119, r21

var8True:

	;Division
	lds r16, 0x0100 ;LSB V1
	lds r17, 0x0101 ;MSB V1
	lds r20, 0x0102 ;LSB V2
	clr r18 
	clr r19
	clr r21
	clr r22
	clr r23
	clr r24
	ldi R25,8 ;Guardar en el R25 el tamaño de bits menos 1 "V1-1" 
recorrerloop:
	lsl r16
	rol r17
	rol r18
	cp r17, r20
	cpc r18, r21
	brcs noResta ;En caso de que el divisor sea mayor al numero rotado a dividir, brinca a noResta
	sub r17, r20
	sbc r18, r21
	sec
	rjmp unoResult
noResta: 
	clc
unoResult:
	rol r22 ;Se guarda el valor del resultado en el registro r22
	rol r23 ;Se guarda el valor del resultado en el registro r23, en caso de que no alcance el r22
	rol r24 ;Se guarda el valor del resultado en el registro r24, en caso de que no alcance el r23
	dec r25 ;El numero de ciclos que se repetirá que es el mismo del número de bits de V1
	brne recorrerloop ;En el caso de que no haya un cero, se repite el ciclo
	sts 0x0120, r22 ;Guarda el resultado en la direccion de memoria 0x0120
	sts 0x0121, r23 ;Guarda el resultado en la direccion de memoria 0x0121


    rjmp start
