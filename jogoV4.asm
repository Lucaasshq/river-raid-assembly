.data 0x10000000
q_cor:  .word 0xFF0000
q_pos:  .word 32, 54
q_pixels:
    .word 0, 0
    .word 0, 1
    .word 1, 1
    .word -1, 1
    .word 0, 2
    .word 0, 3
    .word 99, 99

casa_pos: .word 15, 34
casa_telhado_cor: .word 0x000000
casa_parede_cor: .word 0xFFFFFF

casa_telhado_pixels:
#topo
.word 0, 0
.word -1, 0
.word 1, 0
#base
.word 0, 1
.word 1, 1
.word 2, 1
.word -1, 1
.word -2, 1

.word 99, 99

casa_parede_pixels:
#topo
.word 0, 2
.word 1, 2
.word -1, 2
.word 2, 2
.word -2, 2
#base
.word 0, 3
.word 1, 3
.word 2, 3
.word -1, 3
.word -2, 3
.word 99, 99

navio_pos: .word 58, -100
navio_cor_vela: .word 0x000000
navio_cor_base: .word 0x5c4033
navio_direcao: .word 0

#vela - preta
navio_vela_pixels: 
.word 0, -4
.word 0, -3 
.word -1, -3
.word 0, -2
.word -3, -2
.word -2, -2
.word -1, -2
.word 1, -2
.word 0, -1
.word -1, -1
.word -2, -1
.word -3, -1
.word -4, -1
.word 1, -1
.word 2, -1
.word 99 , 99

#base - marrom
navio_base_pixels:
.word 0, 0
.word -1, 0
.word -2, 0
.word -3, 0
.word -4, 0
.word -5, 0
.word -6, 0
.word -7, 0
.word -8, 0
.word 1, 0
.word 2, 0
.word 3, 0
.word 4, 0
.word 5, 0
.word 0, 1
.word 1, 1
.word 2, 1
.word 3, 1
.word 4, 1
.word 5, 1
.word -1, 1
.word -2, 1
.word -3, 1
.word -4, 1
.word -5, 1
.word -6, 1
.word 99, 99

aviao_pos: .word 58, 110
aviao_cor: .word 0xFFEB3B


aviao_pixels: 
#meio centro da nave
.word 0, -5
.word 0, -4
.word 0, -3
.word 0, -2
.word 0, -1
.word 0, 0
.word 0, 1
.word 0, 2
.word 0, 3
.word 0, 4
.word 0, 5

#asa direita
.word 1, -3
.word 1, -2
.word 2, -2
.word 1, -1
.word 2, -1
.word 3, -1
.word 2, 0
.word 3, 0
.word 3, 1

#asa esquerda
.word -1, -3
.word -1, -2
.word -2, -2
.word -1, -1
.word -2, -1
.word -3, -1
.word -2, 0
.word -3, 0
.word -3, 1

#estabalizador horizontal direito
.word 1, 3
.word 1, 4
.word 2, 4
.word 2, 5

#estabalizador horizontal esquerdo
.word -1, 3
.word -1, 4
.word -2, 4
.word -2, 5

#fim
.word 99 99


.text
main:
	.include "./cenario.asm"
    ### MUDANÇA: Apontar $s0 para o endereço de vídeo correto.
    lui $s0, 0x1001     # $s0 ($16) é o endereço base do Bitmap Display
    lui $s1, 0x1002
    
    
gameloop:
	jal casa
	jal navio
	jal aviao
    #jal quadrado
    li $a0, 100
    	li $v0, 32
    	syscall
    j gameloop

aviao:
	subi $sp, $sp, 4
    	sw $ra, 0($sp)
	
	lw $4, aviao_cor
	la $5, aviao_pos
	la $6, aviao_pixels
	
	jal desenhaForma							
									

	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	jr $ra

quadrado:
    ### ADIÇÃO: Salva o endereço de retorno para 'main' na pilha
    subi $sp, $sp, 4
    sw $ra, 0($sp)

    # Prepara os argumentos e chama a primeira função
    lw $a0, q_cor
    la $a1, q_pos
    la $a2, q_pixels
    jal apagaForma

    # Pausa
	lw $8, q_pos+4
    addi $8, $8, 1
    sw $8, q_pos+4
 
    # Prepara os argumentos e chama a segunda função
    la $a2, q_pixels
    jal desenhaForma # (apagaForma precisaria da mesma correção de pilha que desenhaForma)
    
    ### ADIÇÃO: Restaura o endereço de retorno para 'main' da pilha
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra              # Agora retorna com segurança para 'main'
	
desenhaForma:
    ### ADIÇÃO: Salva o endereço de retorno para 'quadrado'
    subi $sp, $sp, 4
    sw $ra, 0($sp)

loop_desenhaForma: # Label para o loop
    lw $t0, 0($a1)
    lw $t1, 4($a1)
    
    lw $t2, 0($a2)
    lw $t3, 4($a2)
    
    li $t4, 99
    beq $t2, $t4, fDesenhaForma # Pula para o final da função se for 99
    
    add $t0, $t0, $t2
    add $t1, $t1, $t3
    
    jal DrawPixel           # Chama DrawPixel. $ra é sobrescrito aqui.
    
    addi $a2, $a2, 8
    j loop_desenhaForma     # Volta ao início do loop

fDesenhaForma:
    ### ADIÇÃO: Restaura o endereço de retorno para 'quadrado'
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra                  # Agora retorna com segurança para 'quadrado'
#---------------------------------------------------------------------
### MUDANÇA: Função DrawPixel reescrita, separada e com a lógica correta.
# Argumentos esperados:
# $t0: coordenada X final
# $t1: coordenada Y final
# $a0: cor do pixel
# $s0: endereço base do display
DrawPixel:
    # Usa registradores temporários para não destruir os valores de entrada
    mul $t5, $t0, 4         # offset_x = x * 4
    mul $t6, $t1, 512       # offset_y = y * 512 (para tela de 128px de largura)
    
    add $t7, $t5, $t6       # offset_total = offset_x + offset_y
    add $t7, $t7, $s0       # endereco_final = offset_total + endereco_base
    
    sw $a0, 0($t7)          # Desenha o pixel
    
    jr $ra                  # Retorna para a função que a chamou
#---------------------------------------------------------------------
apagaForma:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
loop_apagaForma:
    lw $t0, 0($a1)      # t0 = q_pos.x (posição base x)
    lw $t1, 4($a1)      # t1 = q_pos.y (posição base y)
    
    lw $t2, 0($a2)      # t2 = pixel_offset.x
    lw $t3, 4($a2)      # t3 = pixel_offset.y
    
    li $t4, 99          # t4 = 99 (valor de parada)
    
    ### MUDANÇA: A verificação de parada deve ser no offset x ($t2).
    beq $t2, $t4, fApagaForma
    
    # Calcula a posição final do pixel a ser desenhado
    add $t0, $t0, $t2   # Posição final X = base.x + offset.x
    add $t1, $t1, $t3   # Posição final Y = base.y + offset.y
    
    jal ErasePixel       # Chama a função para desenhar o pixel
    
    addi $a2, $a2, 8    # Avança o ponteiro dos pixels para o próximo par (x,y)
    
    ### MUDANÇA: Adicionado salto para continuar o loop.
    j loop_apagaForma

fApagaForma:
	lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $31

#---------------------------------------------------------------------
### MUDANÇA: Função DrawPixel reescrita, separada e com a lógica correta.
# Argumentos esperados:
# $t0: coordenada X final
# $t1: coordenada Y final
# $a0: cor do pixel
# $s0: endereço base do display
ErasePixel:
    # Usa registradores temporários para não destruir os valores de entrada
    mul $t5, $t0, 4         # offset_x = x * 4
    mul $t6, $t1, 512       # offset_y = y * 512 (para tela de 128px de largura)
    
    add $t7, $t5, $t6       # offset_total = offset_x + offset_y
    add $t8, $t7, $s1	    # endereço_final da copia do mapa (shadow)
    add $t7, $t7, $s0       # endereco_final = offset_total + endereco_base
    lw $t9, 0($t8)	#recupera a cor no shadow
    sw $t9, 0($t7)	#escreve o que ta no shadow na tela
    
    jr $ra                  # Retorna para a função que a chamou
#---------------------------------------------------------------------



moverCasa:
	
	lw $8, casa_pos+4
	beq $8, 128, voltaTopo
	addi $8, $8, 1
	sw $8, casa_pos+4
	j casaDesenha
	
voltaTopo:
	addi $8, $0, 0
	sw $8, casa_pos+4
	j casaDesenha
	
casa:	subi $sp, $sp, 4
    	sw $ra, 0($sp)
    	
	lw $a0, casa_telhado_cor
    	la $a1, casa_pos
    	la $a2, casa_telhado_pixels
    	
    	jal apagaForma

	lw $a0, casa_parede_cor
    	la $a1, casa_pos
    	la $a2, casa_parede_pixels
	
	jal apagaForma
	
	j moverCasa
casaDesenha:
	lw $a0, casa_telhado_cor
    	la $a1, casa_pos
    	la $a2, casa_telhado_pixels
    	
    	jal desenhaForma

	lw $a0, casa_parede_cor
    	la $a1, casa_pos
    	la $a2, casa_parede_pixels
	
	jal desenhaForma

	
	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    
    	jr $ra
	
	
	
navio:	
	subi $sp, $sp, 4
    	sw $ra, 0($sp)

	lw $a0, navio_cor_vela
    	la $a1, navio_pos
    	la $a2, navio_vela_pixels
    	
    	jal apagaForma
	    	    	
    	lw $a0, navio_cor_base
    	la $a1, navio_pos
    	la $a2, navio_base_pixels
    	
    	jal apagaForma
    
    	lw $8, navio_pos+4
    	addi $8, $8, 1
    	sw $8, navio_pos+4
    	
    	jal move_navio
    	
desenhaNavio:
	lw $a0, navio_cor_vela
    	la $a1, navio_pos
    	la $a2, navio_vela_pixels
    	
    	
	jal desenhaForma
	    	    	
    	lw $a0, navio_cor_base
    	la $a1, navio_pos
    	la $a2, navio_base_pixels
    	
    	jal desenhaForma
    	
    	
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	jr $ra

	
	
move_navio:	
    	la $11, navio_direcao
    	la $9, navio_pos
    	lw $8, navio_pos
    	addi $8, $8, -8
    	beq $8, 32, move_direita
	lw $8, navio_pos
    	addi $8, $8, 5
    	beq $8, 95, move_esquerda
    	lw $8, navio_direcao
    	beq $8, $0, move_direita
    	j move_esquerda
    	
	
move_direita:
	add $10, $0, $0
	sw $10, 0($11)
	lw $8, 0($9)
	addi $8, $8, 1
	sw $8, 0($9)
	
	jr $31
move_esquerda:
	addi $10, $0, 1
	sw $10, 0($11)
	
	lw $8, 0($9)
	addi $8, $8, -1
	sw $8, 0($9)
	jr $31
	
fim:
li $v0, 10
syscall
