.data
.word

.text
main:	lui $8, 0x1001
	
	
	ori $5, $5, 0xffff
	add $4, $0, 0x00FF00 # verde
	add $5, $0, 0x120a8f # azul
	add $6, $0, 0x808080 # cinza
	add $7, $0, 0xF5C207 # amarelo
	
	addi $10, $0, 0 # i
	addi $11, $0, 16384 # lenght
	addi $12, $0, 26 # inicio do rio #0 1
	add $15, $0, 100 # fim do rio
	
	addi $21, $0, 8192
	addi $22, $0, 14976
	
	
for:	beq $11, $10, fim
	beq $22, $10, defEstrada
	beq $21, $10 diminuirLinha

sFor:
	sge $14, $10, $12 # se $10 > $12 $14=1
	sle $16, $10, $15
	and $17, $14, $16
	 
	bne $17, $0, azul
	j verde
	 	
azul:
	sw $5, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $10, $10, 1 # i++
	j for

verde: 	sw $4, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $10, $10, 1 # i++
	
	beq $16, $0, proximaLinha
	j for
	
proximaLinha:
	
	addi $12, $12, 128 # inicio do rio #0 1
	addi $15, $15, 128 # fim do rio
	j for

diminuirLinha:	add $21, $21, 2000
	
	addi $12, $12, 4 # inicio do rio #0 1
	addi $15, $15, -4 # fim do rio

	j sFor
fim:
	addi $2, $0, 10
	syscall
	
	
defEstrada:

	addi $12, $0, 0 # LINHA TEM QUE SOMAR AINDA
	add $15, $0, 127 # LINHA TEM QUE SOMAR AINDA
	add $21, $0, 15616
	add $12, $12, $21
	add $15, $15, $21

estrada: 
	beq $11, $10, fim
	# verficacao ou ele vai pra cinza ou amarelo
	sge $14, $10, $12 # se $10 > $12 $14=1
	sle $16, $10, $15
	and $17, $14, $16
	
	bne $17, $0, amarelo
	j cinza
	
cinza:	
	sw $6, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $10, $10, 1 # i++
	j estrada
	
amarelo:
	sw $7, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $10, $10, 1 # i++
	j estrada
	
	
