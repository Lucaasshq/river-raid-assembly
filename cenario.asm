.text
mainCenario:
	lui $s0, 0x1001 #endereço do display
	lui $s1, 0x1002 #endereço da copia do mapa original
		
defCenario:
	add $4, $0, 0xFF00
	add $5, $0, 0xFF
	add $8, $0, $16
	add $9, $0, $17
	
LECenario:
	beq $10, 128, fLECenario
	add $11, $0, $0
	
	LICenario:
		beq $11, 128, fLICenario
		
		
		blt $11, 32, pintaGrama
		blt $11, 96, pintaRio
		blt $11, 128, pintaGrama
		
	aLICenario:
		addi $8, $8, 4
		addi $9, $9, 4
		addi $11, $11, 1
		
		j LICenario
		
	fLICenario:
		addi $10, $10, 1
		j LECenario
		
		

	
	
pintaGrama:
	sw $4, 0($8)
	sw $4, 0($9)
	
	j aLICenario
	
pintaRio:
	sw $5, 0($8)
	sw $5, 0($9)
	
	j aLICenario
	
fLECenario:
	
		
		

	
