.include "base.asm"
.include "macros.asm"
.data
map: .space 55808 # 0<= y <= 108
divisoria: .space 512 #y = 109
hud: .space 9216 # 110 <= y <= 127 

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
helicoptero_posicao: .word 73 40
helicoptero_posicao_2: .word 54 -60
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
casa_posicao_2: .word 112 30
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

navio_posicao: .word 58 -5
navio_vela_cor: .word 0x000000
navio_base_cor: .word 0x5c4033
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

tiro_cor: .word 0xFF0000
tiro_posicao: .word 63 98
tiro_pixels:
.word 0 0
.word 0 -1
.word 0 -2
.word 99 99
#cor fica no reg $5
#display fica no %s0
rio_pos: .word 0 0

rio_margens:
.word 31 101
.word 96 101
.word 99 99

.text
carregar:
	lui $s0, 0x1001 #display
	lui $s1, 0xffff #teclado
	addi $s2, $0, 0 #existencia do tiro
	addi $s3, $0, 1 #jogador vivo
	casa (casa_posicao)
	casa (casa_posicao_2)
	navio
	helicoptero (helicoptero_posicao)
	helicoptero (helicoptero_posicao_2)
	jogador_apaga
	
	tiro
	jogador_desenha
	
	delay
	delay
	delay
	
loop:	
	aviao_som
	casa (casa_posicao)
	casa (casa_posicao_2)
	navio
	helicoptero (helicoptero_posicao)
	helicoptero (helicoptero_posicao_2)
	teclado
	 
	delay
	#jogador_colidiu_helicoptero_1
	#jogador_colidiu_helicoptero_2
	#jogador_colidiu_navio
	jogador_colidiu_rio
	j loop
	
game_over_label:
	end
	
	
	





