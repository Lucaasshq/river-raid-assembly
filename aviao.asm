.data
aviao_pos: .word 58, 100
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
lui $16, 0x1001




	
defAviao:
	lw $4, aviao_cor
	
	add $7, $0, $0
LEAviao:
	lw $5, aviao_pos
	lw $6, aviao_pos+4
	lw $t0, aviao_pixels($7)
	lw $t1, aviao_pixels+4($7)
	
	li $t8, 99
	beq $t0, $t8, fim
	
	
	add $5, $5, $t0
	add $6, $6, $t1
	
	jal DrawPixel
	
	addi $7, $7, 8
	j LEAviao
	
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