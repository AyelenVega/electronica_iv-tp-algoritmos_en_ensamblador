/* En este archivo escribirás tu solución.
 * Para ello deberás completar las rutinas en código
 * ensamblador.
 * Puedes usar los registros R0 a R12 pues ya está preservado
 * el valor de los registros que deben mantenerse.
 * Los registros R0 a R3 contienen los argumentos al entrar a
 * la rutina y contendrán el valor devuelto al salir.
 * Si realizas un llamado a subrutina, los registros R0 a R3 y el
 * registro R12 pueden cambiar su valor (y en particular, R0 contiene 
 * normalmente el valor devuelto), los registros R4 a R11 preservan
 * su valor.
 */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre:
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm


/**
 * Sumar dos enteros de 32 bit
 *  suma(2,3) => 5
 * Entrada
 *  a->R0, b->R1 : sumandos, enteros de 32 bit con signo 
 * Salida
 *  R0     : suma, entero de 32 bit con signo
 */
defun suma
    push {r4-r11,lr}
    // Insertar código a continuación

    ADD R0,R0,R1
    
    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun suma

/**
 * Sumar los números de un arreglo en memoria de enteros de
 * 32 bit con resultado de 64 bit.
 *
 * sumatoria(5,(uint32_t[]){1,2,3,4,5}) => 15
 *
 * Entrada 
 *  n->R0    : Cantidad de números en registro R0, entero de 32 bit
 *  b->R1    : Dirección en memoria del primer número, puntero a
 *             entero de 32 bit con signo.
 * Salida
 *  R1:R0 : Sumatoria, entero de 64 bit con signo 
 */
defun sumatoria
    push {r4-r11,lr}
    // Insertar código a continuación

    mov r3, r0
    mov r4,r1
    mov r0, #0      
    mov r1, #0     
    mov r2, #0 

    sum_loop:
        cmp r2, r3
        bge f
        ldr r5, [r4, r2, lsl#2]
        cmp r5, #0
        blt negativo
        adds r0,r0,r5
        adc r1,#0
        bal fin_loop
    negativo:
        adds r0,r0,r5
        adc r1,#-1
    fin_loop:
        add r2,r2,#1
        b sum_loop
    
    // Retorno, antes R1:R0 debe tener el valor correcto
    f:
        pop {r4-r11,pc}

endfun sumatoria


/**
 * Encuentra la posicion del máximo elemento de un arreglo
 *
 * posicion_maximo(4,(uint32_t[]){1,4,2,3}) => 1
 *
 * Entrada:
 *  n->R0 : cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : posición en memoria del primer número, puntero
 *          a entero de 32 bit con signo.
 * Salida:
 *  R0 : posición del máximo elemento en el arreglo, entero
 *       de 32 bit.
 */

defun posicion_maximo
    push {r4-r11,lr}
    // Insertar código a continuación

    mov r3, r0
    mov r4, r1
    mov r0, #0
    cmp r3, #1
    ble exit
    ldr r1, [r4, r0,lsl#2]
    mov r2, #1

    bucle:
        cmp r2,r3
        bge exit
        ldr r5, [r4, r2,lsl#2]
        cmp r1, r5
        bge fin_comp
        mov r1,r5
        mov r0, r2
        fin_comp:
        add r2,r2,#1
        b bucle
    
    // Retorno, antes R0 debe tener el valor correcto
    exit:
        pop {r4-r11,pc}
endfun posicion_maximo

/**
 * Ordenar de menor a mayor un arreglo de números en memoria.
 * La ordenación es en el lugar, sobreescribiendo el arreglo
 * original.
 *
 * uint32_t vals[]={4,1,3,5,2,6,7};
 * ordenar_en_sitio_menor_a_mayor(7,vals)
 * luego vals contendrá {1,2,3,4,5,6,7}
 *
 * Entrada:
 *  n->R0 : Cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : Dirección del primer número, puntero a entero de
 *          32 bit con signo.
 * Salida:
 *  Sin valor de salida. El arreglo dado debe haber sido ordenado
 *  sobreescribiendo los valores originales.
 */
defun ordenar_en_sitio_menor_a_mayor
    push {r4-r11,lr}
    // Insertar código a continuación
     mov r4, r0
     mov r5, r1
     sub r6, r4, #1
  
     ciclo:
        cmp r6, #0
        ble fin
        add r0,r6,#1
        mov r1,r5
        bl posicion_maximo
        ldr r7, [r5, r6, lsl#2] 
        ldr r8, [r5, r0, lsl#2]  
        str r7 ,[r5, r0, lsl#2]
        str r8 ,[r5, r6, lsl#2]
        sub r6,#1
        b ciclo

    // Retorno
    fin:
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
