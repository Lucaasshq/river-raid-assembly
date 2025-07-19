.macro delay 
li $a0, 60
li $v0, 32
syscall
.end_macro

.macro end
li $v0, 10
syscall
.end_macro

.macro pinta_pixel(%x, %y)
sll $8, %x, 2
sll $9, %y, 9
add $10, $9, $8
add $11, $10, $s0
sw $5, 0($11)
.end_macro

.macro desenha (%cor, %posicao, %pixels)
lw $5, %cor
la $6, %posicao
la $7, %pixels
desenha_loop:
	lw $8, 0($7)
	lw $9, 4($7)
	beq $8, 99, fim_desenha_loop
	
	lw $10, 0($6)
	lw $11, 4($6)
	
	add $10, $10, $8
	add $11, $11, $9
	
	blt $11, $0, auxiliar_desenha
	bgt $11, 108, auxiliar_desenha
	
	pinta_pixel ($10, $11)
	
auxiliar_desenha:
	add $7, $7, 8
	j desenha_loop
fim_desenha_loop:
nop
.end_macro

.macro recupera_cor(%x)
blt %x, 32, verde
blt %x, 96, azul

verde:
add $5, $0, 0x11c411
j fim_recupera

azul:
add $5, $0, 0x2D32B8

fim_recupera:
nop
.end_macro

.macro apaga (%posicao, %pixels)
la $6, %posicao
la $7, %pixels
apaga_loop:
	lw $8, 0($7)
	lw $9, 4($7)
	beq $8, 99, fim_apaga_loop
	
	lw $10, 0($6)
	lw $11, 4($6)
	
	add $10, $10, $8
	add $11, $11, $9
	
	blt $11, $0, auxiliar_apaga
	bgt $11, 108, auxiliar_apaga
	
	recupera_cor($10)
	pinta_pixel ($10, $11)
	
auxiliar_apaga:
	add $7, $7, 8
	j apaga_loop
fim_apaga_loop:
nop
.end_macro



.macro esquerda (%posicao)
lw $8, %posicao
addi $8, $8, -1
sw $8, %posicao
.end_macro

.macro direita (%posicao)
lw $8, %posicao
addi $8, $8, 1
sw $8, %posicao
.end_macro

.macro baixo (%posicao)
lw $8, %posicao+4
addi $8, $8, 1
sw $8, %posicao+4
.end_macro

.macro cima (%posicao)
lw $8, %posicao+4
addi $8, $8, -1
sw $8, %posicao+4
.end_macro

.macro jogador_desenha
desenha (jogador_cor, jogador_posicao, jogador_pixels)
.end_macro

.macro jogador_apaga
apaga (jogador_posicao, jogador_pixels)
.end_macro

.macro navio_move_esquerda 
esquerda (navio_posicao)
.end_macro

.macro navio_move_direita
direita (navio_posicao)
.end_macro

.macro navio_direcao ()


lw $8, navio_direcao
beq $8, $0, navio_direita
j navio_esquerda
navio_direita:
	lw $8, navio_posicao
	addi $8, $8 5
	beq $8, 95, navio_esquerda
	navio_move_direita()
	add $8, $0, $0
	sw $8, navio_direcao
	j fim_navio_direcao
navio_esquerda:
	lw $8, navio_posicao
	addi $8, $8 -8
	beq $8, 32, navio_direita
	navio_move_esquerda()
	addi $8, $0, 1
	sw $8, navio_direcao
fim_navio_direcao:
.end_macro

.macro navio_desce 
baixo (navio_posicao)
.end_macro

.macro navio_desenha
desenha (navio_vela_cor, navio_posicao, navio_vela_pixels)
desenha (navio_base_cor, navio_posicao, navio_base_pixels)
.end_macro

.macro navio_apaga
apaga (navio_posicao, navio_vela_pixels)
apaga (navio_posicao, navio_base_pixels)
.end_macro

.macro navio
navio_apaga
navio_desce
navio_direcao
navio_desenha
.end_macro

.macro helicoptero_desenha (%posicao)
desenha (helicoptero_helice_cor, %posicao, helicoptero_helice_pixels)
desenha (helicoptero_ponta_cor, %posicao, helicoptero_ponta_pixels)
desenha (helicoptero_meio_cor, %posicao, helicoptero_meio_pixels)
.end_macro

.macro helicoptero_apaga (%posicao)
apaga (%posicao, helicoptero_helice_pixels)
apaga (%posicao, helicoptero_ponta_pixels)
apaga (%posicao, helicoptero_meio_pixels)
.end_macro

.macro casa_desenha (%posicao)
desenha (casa_telhado_cor, %posicao, casa_telhado_pixels)
desenha (casa_parede_cor, %posicao, casa_parede_pixels)
.end_macro

.macro casa_apaga (%posicao)
apaga (%posicao, casa_telhado_pixels)
apaga (%posicao, casa_parede_pixels)
.end_macro

.macro casa (%posicao)
casa_apaga (%posicao)
baixo(%posicao)
lw $8, %posicao+4
blt $8, 109, fim_casa
resetar_casa:
	li $8, -5
	sw $8, %posicao+4
	
fim_casa:
casa_desenha(%posicao)
.end_macro

.macro helicoptero (%posicao)
helicoptero_apaga (%posicao)
baixo (%posicao)
helicoptero_desenha (%posicao)
.end_macro







.macro teclado
jogador_apaga
lw $8, 0($s1)
beq $8, $0, fim_teclado
lw $9, 4($s1)
addi $10, $0, 'a'
beq $10, $9, jogador_esquerda
addi $10, $0, 'd'
beq $10, $9, jogador_direita
addi $10, $0, ' '
beq $10, $9, jogador_tiro
j fim_teclado
jogador_esquerda:
	esquerda(jogador_posicao)
	j fim_teclado
jogador_direita:
	direita(jogador_posicao)
	j fim_teclado
jogador_tiro:
	beq $s2, 1, fim_teclado
	addi $s2, $0, 1
	lw $8, jogador_posicao
	li $9, 98
	sw $8, tiro_posicao
	sw $9, tiro_posicao+4
	tiro_som
	
fim_teclado:
tiro
jogador_desenha
.end_macro

.macro tiro
lw $8, tiro_posicao+4
blt $8, $0, resetar_tiro
j posicao_tiro
resetar_tiro:
add $s2, $0, $0
posicao_tiro:
	beq $s2, $0, fim_tiro
	apaga(tiro_posicao, tiro_pixels)
	cima (tiro_posicao)
	desenha (tiro_cor, tiro_posicao, tiro_pixels)
fim_tiro:

.end_macro

.macro aviao_som
addi $a1 $0 5000 # tempo
    addi $a2 $0 90 # instrumento
    addi $a3 $0 127 # volume
    addi $a0 $0 21 # nota
    addi $v0 $0 31 # syscall
    syscall
.end_macro

.macro tiro_som
addi $a1 $0 500 # tempo
    addi $a2 $0 127 # instrumento
    addi $a3 $0 127 # volume
    addi $a0 $0 50 # nota
    addi $v0 $0 31 # syscall
    syscall
.end_macro