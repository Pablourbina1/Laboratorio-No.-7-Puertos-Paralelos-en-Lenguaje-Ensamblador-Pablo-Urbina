        AREA |.text|, CODE, READONLY, ALIGN=2
        THUMB
        REQUIRE8
        PRESERVE8

	
        EXPORT	LEDs_Init
		EXPORT	LED_Toggle
			
RCC		EQU		0x40021000
	
; Deben buscar el valor en el Reference Manual
GPIOE	EQU		0x48001000	; EvalBoard
GPIOB_K8 EQU		0x48000400	; K8
GPIOB   EQU		0x48000400	; G4
GPIOA	EQU		0x48000000 ; RE

AHB2ENR	EQU 	0x0000004C
	
; Deben buscar el valor en el Reference Manual
MODER   EQU		0x0	
ODR		EQU		0x14


LEDs_Init
	push {lr}
	
	;RCC->AHBENR |= (1<<1); 
	;**** Encender el puerto correspondiente de tu tarjeta ****
	
	ldr  r0, =RCC			;read
	ldr  r1, [r0,#AHB2ENR]
	movs r2, #0x02		;modify
	orrs r1, r1, r2
	str  r1, [r0,#AHB2ENR]	;write
	ldr  r1, [r0,#AHB2ENR]	; Espera del reloj
	
	;EvalBoard / Discovery
	;	GPIOE->MODER |= (1<<26);
	;	GPIOE->ODR &= ~(1<<13);
	;F303K8
	;	GPIOB->MODER &= ~(1<<7);			
	;	GPIOB->MODER |= (1<<6);
	;G431KB
	;	GPIOB->MODER &= ~(1<<17);
	;	GPIOB->MODER |= (1<<16);
	;F303RE
	;	GPIOA->MODER |= (1<<10);
	;	GPIOA->ODR &= ~(1<<5);		
	
	
	
	; G431KB: LED integrado en PB8
	ldr  r0, =GPIOB
	ldr  r1, [r0,#ODR]
	ldr  r2, =0x00000100
	bics r1, r1, r2          ; PB8 inicialmente en cero
	str  r1, [r0,#ODR]

	ldr  r1, [r0,#MODER]
	ldr  r2, =0x00030000
	bics r1, r1, r2          ; Limpia bits 17 y 16
	ldr  r2, =0x00010000
	orrs r1, r1, r2          ; Modo 01: salida
	str  r1, [r0,#MODER]

	pop {pc}

LED_Toggle
	push {lr}
	
	;GPIOE->ODR ^= 1<<13 EvalBoard / Disvovery
	;GPIOB->ODR ^= 1<<3 K8
	;GPIOB->ODR ^= 1<<8 G4
	;GPIOA->ODR ^= 1<<5 RE
	
	ldr  r0, =GPIOB
	ldr  r1, [r0,#ODR]
	ldr  r2, =0x00000100
	eors r1, r1, r2          ; Invierte PB8
	str  r1, [r0,#ODR]

	pop {pc}

	end
