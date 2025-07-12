.data
casa_pos: .word 100, 20
casa_telhado_cor: .word 0xFF00F0
casa_parede_cor: .word 0xFFFFFF

casa_telhado_pixels:
#topo
.word 0, -2
.word -1, -2
.word 1, -2
#base
.word 0, -1
.word 1, -1
.word 2, -1
.word -1, -1
.word -2, -1

.word 99, 99

casa_parede_pixels:
#topo
.word 0, 0
.word 2, 0
.word -2, 0
#base
.word 0, 1
.word 1, 1
.word 2, 1
.word -1, 1
.word -2, 1


.text
main:
lui $16, 0x1001
#ver como arrumar esse jals para fazer tudo funcionar direito
#lembrar de alterar a cor do telhado da casa
defCasa:
	jal defCasaTelhado
	jal defCasaParede

defCasaTelhado:
	lw $4, casa_telhado_cor
	
	add $7, $0, $0
loopCasaTelhado:
	lw $5, casa_pos
	lw $6, casa_pos+4
	lw $t0, casa_telhado_pixels($7)
	lw $t1, casa_telhado_pixels+4($7)
	
	li $t8, 99
	beq $t0, $t8, defCasaParede
	
	add $5, $5, $t0
	add $6, $6, $t1
	
	jal DrawPixel
	
	addi $7, $7, 8
	j loopCasaTelhado


DrawPixel:
	mul $8, $5, 4
	mul $9, $6, 512
	add $10, $9, $8
	add $10, $10, $16
	add $11, $0, $4
	
	sw $11, 0($10)
	
	jr $31
	


defCasaParede:
lw $4, casa_parede_cor
	
	add $7, $0, $0
loopCasaParede:
	lw $5, casa_pos
	lw $6, casa_pos+4
	lw $t0, casa_parede_pixels($7)
	lw $t1, casa_parede_pixels+4($7)
	
	li $t8, 99
	beq $t0, $t8, fCasa
	
	add $5, $5, $t0
	add $6, $6, $t1
	
	jal DrawPixel
	
	addi $7, $7, 8
	j loopCasaParede
	
fCasa:
fim:
	addi $2, $0, 10
	syscall