.include "./base.asm" #arquivo base possui tudo que é estatico

.data
map: .space 55808 # 0<= y <= 108
divisoria: .space 512 #y = 109
hud: .space 9216 # 110 <= y <= 127 

grama_cor: .word 0x11c411
rio_cor: .word 0x2D32B8

jogador_cor: .word 0xFFEB3B
jogador_posicao: .word 63 96
jogador_pixels: 
.word 0 0
.word 0 1
.word -1 2
.word 0 2
.word 1 2
.word -2 3
.word -1 3
.word 0 3
.word 1 3
.word 2 3
.word -3 4
.word -2 4
.word -1 4
.word 0 4
.word 1 4
.word 2 4
.word 3 4
.word -3 5
.word -2 5
.word 0 5
.word 2 5
.word 3 5
.word -3 6
.word 0 6
.word 3 6
.word 0 7
.word -1 8
.word 0 8
.word 1 8
.word -2 9
.word -1 9
.word 0 9
.word 1 9
.word 2 9	
.word -2 10
.word 0 10
.word 2 10
.word 99 99


helicoptero_helice_cor: .word 0xF9A825
helicoptero_ponta_cor: .word 0x004030
helicoptero_meio_cor: .word 0x000887 
helicoptero_posicao: .word 63 40
helicoptero_helice_pixels:
.word 1 0
.word 2 0
.word 3 0
.word 3 1
.word 4 1
.word 5 1
.word 3 2
.word 99 99
helicoptero_meio_pixels:
.word -5 5
.word -4 5
.word -3 5
.word -2 5
.word -1 5
.word 0 5
.word 1 5
.word 2 5
.word 3 5
.word 4 5
.word 5 5
.word -5 6
.word -4 6
.word -3 6
.word -2 6
.word -1 6
.word 0 6
.word 1 6
.word 2 6
.word 3 6
.word 4 6
.word 5 6
.word 99 99
helicoptero_ponta_pixels:
.word 2 3
.word 3 3
.word 4 3
.word -5 4
.word -4 4
.word 1 4
.word 2 4
.word 3 4
.word 4 4
.word 5 4
.word -5 7
.word -4 7
.word 2 7
.word 3 7
.word 4 7
.word 3 8
.word 2 9
.word 3 9
.word 4 9
.word 99 99

casa_telhado_cor: .word 0x000000
casa_parede_cor: .word 0xFFFFFF
casa_posicao: .word 15 100
casa_telhado_pixels:
.word -1 0
.word 0 0
.word 1 0
.word -2 1
.word -1 1
.word 0 1
.word 1 1
.word 2 1
.word -3 2
.word -2 2
.word -1 2
.word 0 2
.word 1 2
.word 2 2
.word 3 2
.word 99 99
casa_parede_pixels:
.word -3 3
.word -2 3
.word -1 3
.word 0 3
.word 1 3
.word 2 3
.word 3 3
.word -3 4
.word -1 4
.word 1 4
.word 3 4
.word -3 5
.word -2 5
.word -1 5
.word 0 5
.word 1 5
.word 2 5
.word 3 5
.word 99 99

navio_pos: .word 58 -1
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


.text
carregar:
	
	lui $s0, 0x1001
	la $s1, hud
	
	
		
game_loop:
	jal inimigo1
	jal navio
	jal jogador
	jal casa
	li $a0, 400
	li $v0, 32
	syscall
	j game_loop
	
fim:	li $v0, 10
	syscall
	
#======================#======================
#função: que desenha um figura/forma
#argumentos: 
#$5 = $a1 -> forma_cor
#$6 = $a2 -> forma_posicao
#$7 = $a3 -> forma_pixels
#registradores alterados:
# $7, $10, $8, $9, $10, $11, $12
#==========================================
DrawShape:
	subi $sp, $sp, 4
    	sw $ra, 0($sp)
loop_DrawShape:
	lw $10, 0($7)
	lw $11, 4($7)
	
	li $12, 99
	beq $12, $10, fDrawShape
	
	lw $8, 0($6)
	lw $9, 4($6)
	
	add $8, $8, $10
	add $9, $9, $11
	
	blt $9, $0, aloop_DrawShape
	bgt $9, 108, aloop_DrawShape
	
	jal DrawPixel
aloop_DrawShape:
	add $7, $7, 8
	j loop_DrawShape
fDrawShape:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
        
	jr $31


#====================#====================
#função: pinta um pixel na tela
#registradores alterados:
# $8, $9, $10, $11 
#registradores usados:
# $5, $s0
#=================================
DrawPixel:
	sll $8, $8, 2
	sll $9, $9, 9
	add $10, $9, $8
	add $11, $10, $s0
	sw $5, 0($11)
	
	jr $31

EraseShape:
	subi $sp, $sp, 4 
    	sw $ra, 0($sp)
loop_EraseShape:
	lw $8, 0($7)
	lw $9, 4($7)
	
	li $12, 99
	
	beq $8, $12, fEraseShape
	
	lw $10, 0($6)
	lw $11, 4($6)
	
	add $8, $8, $10
	add $9, $9, $11
	
	blt $9, $0, aloop_EraseShape
	bgt $9, 108, aloop_EraseShape
	
	blt $8, 32, pintaGrama
	blt $8, 96, pintaRio
	blt $8, 128, pintaGrama
	
aEraseShape:
	jal DrawPixel
	
aloop_EraseShape:
	addi $7, $7, 8
	j loop_EraseShape

fEraseShape:	
	lw $ra, 0($sp)
	addi $sp, $sp, 4        
	jr $31

pintaGrama:
	lw $5, grama_cor
	j aEraseShape
pintaRio:
	lw $5, rio_cor
	j aEraseShape
	
	
jogador:
	subi $sp, $sp, 4 
    	sw $ra, 0($sp)
    	
    	lw $5, jogador_cor
	la $6, jogador_posicao
	la $7, jogador_pixels
	jal EraseShape
    	
	lw $5, jogador_cor
	la $6, jogador_posicao
	la $7, jogador_pixels
	jal DrawShape
    	    	
    	lw $ra, 0($sp)
	addi $sp, $sp, 4        
	jr $31

inimigo1:
	subi $sp, $sp, 4 
    	sw $ra, 0($sp)
	
	lw $5, helicoptero_helice_cor
	la $6, helicoptero_posicao
	la $7, helicoptero_helice_pixels
	jal EraseShape
	
	lw $5, helicoptero_ponta_cor
	la $6, helicoptero_posicao
	la $7, helicoptero_ponta_pixels
	jal EraseShape
	
	lw $5, helicoptero_meio_cor
	la $6, helicoptero_posicao
	la $7, helicoptero_meio_pixels
	jal EraseShape
	
	lw $8, helicoptero_posicao+4
	addi $8, $8, 1
	sw $8, helicoptero_posicao+4
	
	lw $5, helicoptero_helice_cor
	la $6, helicoptero_posicao
	la $7, helicoptero_helice_pixels
	jal DrawShape
	
	lw $5, helicoptero_ponta_cor
	la $6, helicoptero_posicao
	la $7, helicoptero_ponta_pixels
	jal DrawShape
	
	lw $5, helicoptero_meio_cor
	la $6, helicoptero_posicao
	la $7, helicoptero_meio_pixels
	jal DrawShape
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4        
	jr $31

casa:	subi $sp, $sp, 4 
    	sw $ra, 0($sp)
	
	lw $8, casa_posicao+4
	beq $8, 109, casaVoltaTopo

	lw $5, casa_telhado_cor
	la $6, casa_posicao
	la $7, casa_telhado_pixels
	jal EraseShape
	
	lw $5, casa_parede_cor
	la $6, casa_posicao
	la $7, casa_parede_pixels
	jal EraseShape
	
	lw $8, casa_posicao+4
	addi $8, $8, 1
	sw $8, casa_posicao+4
	
	
	lw $5, casa_telhado_cor
	la $6, casa_posicao
	la $7, casa_telhado_pixels
	jal DrawShape
	
	lw $5, casa_parede_cor
	la $6, casa_posicao
	la $7, casa_parede_pixels
	jal DrawShape

	lw $ra, 0($sp)
	addi $sp, $sp, 4        
	jr $31
	
casaVoltaTopo:
	li $8, -6
	sw $8, casa_posicao+4
	
	lw $8, casa_posicao
	beq $8, 15, casaNaDireita
	j casaNaEsquerda
casaNaDireita:
	li $8, 105
	sw $8, casa_posicao
	j casa
casaNaEsquerda:
	li $8, 15
	sw $8, casa_posicao
	j casa
	
navio:	
	subi $sp, $sp, 4
    	sw $ra, 0($sp)

	lw $a1, navio_cor_vela
    	la $a2, navio_pos
    	la $a3, navio_vela_pixels
    	
    	jal EraseShape
	    	    	
    	lw $a1, navio_cor_base
    	la $a2, navio_pos
    	la $a3, navio_base_pixels
    	
    	jal EraseShape
    
    	lw $8, navio_pos+4
    	addi $8, $8, 1
    	sw $8, navio_pos+4
    	
    	jal move_navio
    	
desenhaNavio:
	lw $a1, navio_cor_vela
    	la $a2, navio_pos
    	la $a3, navio_vela_pixels
    	
    	
	jal DrawShape
	    	    	
    	lw $a1, navio_cor_base
    	la $a2, navio_pos
    	la $a3, navio_base_pixels
    	
    	jal DrawShape
    	
    	
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