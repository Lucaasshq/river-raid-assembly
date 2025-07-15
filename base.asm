.text
defCenario:
	lui $s0, 0x1001
	add $8, $0, $s0
LECenario:
	beq $9, 109, fLECenario
	add $10, $0, $0
	LICenario:
		beq $10, 128, fLICenario
		
		blt $10, 32, verdeCenario
		blt $10, 96, azulCenario
		blt $10, 128, verdeCenario
	
	aLICenario: # a = auxiliar
		sw $11, 0($8)
		
		addi $8, $8, 4
		addi $10, $10, 1
		
		j LICenario
	fLICenario:
		addi $9, $9, 1
		j LECenario
fLECenario:
	j defHud

verdeCenario:
	add $11, $0, 0x11c411
	j aLICenario
	
azulCenario:
	add $11, $0, 0x2D32B8#0x014ba0
	j aLICenario
defHud:
	add $9, $0, $0
	add $11, $0, 0x8e8f8e
LEHud:
	beq $9, 19, fLEHud
	add $10, $0, $0
	LIHud:
		beq $10, 128, fLIHud
		beq $9, $0, aLIHud
		
		sw $11, 0($8)
		
	aLIHud:	addi $8, $8, 4
		addi $10, $10, 1
		
		j LIHud
	fLIHud:
		addi $9, $9, 1
		j LEHud
fLEHud:
nop
	
	
	
	
	
	
		
