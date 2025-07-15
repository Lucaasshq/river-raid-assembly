cruz_cor: .word 0xFF0000
cruz_posicao: .word 63 -3
cruz_pixels:
.word 0 0
.word -1 1
.word 0 1
.word 1 1
.word 0 2 
.word 0 3
.word 0 4
.word 99 99



cruz:	subi $sp, $sp, 4 #apenas exemplo
    	sw $ra, 0($sp)
    	
    	lw $5, cruz_cor
	la $6, cruz_posicao
	la $7, cruz_pixels
	
	jal EraseShape
    	
    	lw $8, cruz_posicao+4
	addi $8, $8, 1
	sw $8, cruz_posicao+4
    	
	lw $5, cruz_cor
	la $6, cruz_posicao
	la $7, cruz_pixels
	
	jal DrawShape
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4        
	jr $31