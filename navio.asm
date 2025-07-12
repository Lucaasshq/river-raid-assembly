.data
navio_pos: .word 58, 100
aviao_cor: .word 0xFFEB3B

#vela - preta
navio_pixels: 
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

#base - marrom

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



#fim
.word 99 99





.text
main:
lui $16, 0x1001




	
defNavio:
	lw $4, aviao_cor
	
	add $7, $0, $0
LENavio:
	lw $5, navio_pos
	lw $6, navio_pos+4
	lw $t0, navio_pixels($7)
	lw $t1, navio_pixels+4($7)
	
	li $t8, 99
	beq $t0, $t8, fim
	
	
	add $5, $5, $t0
	add $6, $6, $t1
	
	jal DrawPixel
	
	addi $7, $7, 8
	j LENavio
	
#$4 = cor
#$5 = x
#$6 = y
DrawPixel:
	mul $8, $5, 4
	mul $9, $6, 512
	add $10, $9, $8
	add $10, $10, $16
	add $11, $0, $4
	
	sw $11, 0($10)
	
	jr $31

fim: 	
	
	addi $2, $0, 10
	syscall
