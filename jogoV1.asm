.text
main:	
	lui $4, 0x1001 #registrador 4 mant√©m o primeiro espa√ßo de m√©moria
	
	jal defCenario
	#jal defRua
	jal defNavio
	jal defCasa
	jal defCasa1
	
	addi $2, $0, 10
	syscall



#def -> coisas inicias
#l -> la√ßo
#le -> la√ßo externo
#li -> la√ßo interno
#fim -> se tiver f significa fim
 # =====================================================================
# Nova definiÁ„o do Navio, desenhado em 3 partes para se assemelhar ‡ imagem
# =====================================================================
defNavio:
    # --- Parte 1: Casco inferior (Azul Claro) ---
    # PosiÁ„o inicial: linha 42, coluna 59
    # Õndice = (42 * 128 + 59) = 5435
    li $9, 5435          # Õndice base para o casco azul
    mul $16, $9, 4       # Deslocamento em bytes
    add $8, $4, $16      # Ponteiro para a posiÁ„o inicial
    li $10, 1            # Altura (1 linha)
    li $11, 10           # Largura (10 colunas)
    li $5, 0x66B2FF      # Cor: Azul claro

linhaNavioAzul:
    li $12, 0            # Zera o contador de colunas
colunaNavioAzul:
    sw $5, 0($8)         # Pinta a posiÁ„o com azul claro
    addi $8, $8, 4       # PrÛxima cÈlula na mesma linha
    addi $12, $12, 1
    bne $12, $11, colunaNavioAzul # Loop para as colunas

    # Prepara para a prÛxima linha (n„o È necess·rio aqui, pois È uma linha sÛ)
    addi $10, $10, -1
    bnez $10, linhaNavioAzul

    # --- Parte 2: ConvÈs/Casco superior (Marrom) ---
    # PosiÁ„o inicial: linha 41, coluna 58
    # Õndice = (41 * 128 + 58) = 5306
    li $9, 5306          # Õndice base para o convÈs marrom
    mul $16, $9, 4       # Deslocamento em bytes
    add $8, $4, $16      # Ponteiro para a posiÁ„o inicial
    li $10, 1            # Altura (1 linha)
    li $11, 12           # Largura (12 colunas)
    li $5, 0x8B4513      # Cor: Marrom (a mesma que vocÍ usou)

linhaNavioMarrom:
    li $12, 0            # Zera o contador de colunas
colunaNavioMarrom:
    sw $5, 0($8)         # Pinta a posiÁ„o com marrom
    addi $8, $8, 4       # PrÛxima cÈlula na mesma linha
    addi $12, $12, 1
    bne $12, $11, colunaNavioMarrom # Loop para as colunas

    addi $10, $10, -1
    bnez $10, linhaNavioMarrom

    # --- Parte 3: Superestrutura (Preto) ---
    # PosiÁ„o inicial: linha 40, coluna 63
    # Õndice = (40 * 128 + 63) = 5183
    li $9, 5183          # Õndice base para a estrutura preta
    mul $16, $9, 4       # Deslocamento em bytes
    add $8, $4, $16      # Ponteiro para a posiÁ„o inicial
    li $10, 1            # Altura (1 linha)
    li $11, 4            # Largura (4 colunas)
    li $5, 0x000000      # Cor: Preto

linhaNavioPreto:
    li $12, 0            # Zera o contador de colunas
colunaNavioPreto:
    sw $5, 0($8)         # Pinta a posiÁ„o com preto
    addi $8, $8, 4       # PrÛxima cÈlula na mesma linha
    addi $12, $12, 1
    bne $12, $11, colunaNavioPreto # Loop para as colunas

    addi $10, $10, -1
    bnez $10, linhaNavioPreto

    jr $31

defCenario:
	add $8, $4, $0 # espa√ßo de memoria que sera alterado
	add $9, $0, $0 # i -> contador do la√ßo
	add $10, $0, 16384 # lenght -> limite do la√ßo
	# limites do rio
	add $11, $0, 26	 #come√ßo do rio na linha
	add $12, $0, 102 #fim do rio na linha
	
	add $16, $0,  8192#guardar valor para reduzir tamanho do rio
 

lCenario: 
	beq $10, $9, fimlCenario
	
	#if para saber se pinta azul ou verde
	sge $13, $9, $11 # se $9 >= $11 ent√£o $13 recebe 1.
	sle $14, $9, $12 # se $9 <= $12 ent√£o $14 recebe 1.
	and $15, $13, $14 # faz um and com $13 e $14 recebe 1 ou 0
	bne $15, $0, azulCenario # se for 1 pinta o rio senao pinta a grama
	j verdeCenario 
	
verdeCenario: 	
	add $5, $0, 0x00FF00 #cor verde
	sw $5, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
#	beq $9, $16, diminuirRioCenario
	j lCenario	

azulCenario:
	add $5, $0, 0x120a8f # azul
	sw $5, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
	
	beq $9, $12, pulaLinhaCenario #se $9 = $12 (limite do rio na linha) chama pulaLInha
	j lCenario

pulaLinhaCenario:
	# soma ao $11 e $12, para pular para o proxima linha
	# para assim desenhar o rio
	add $11, $11, 128 
	add $12, $12, 128
	j lCenario

#diminuirRioCenario:
#	add $11, $11, 4 # inicio do rio soma 4 para reduzir tamanho do rio
#	add $12, $12, -4 # fim do rio diminui 4 para reduzir tamanho do rio
#	add $16, $16, 1280 # frequencia com ele vai diminuir //a cada 10 li#nha
#	j lCenario
	
fimlCenario:
	jr $31
	
defRua:
	add $9, $0, 14976 # i -> contador do la√ßo //ja come√ßa onde pinta a rua
	mul $16, $9, 4 #para pegar o espa√ßo de memoria correto
	add $8, $4, $16 # espa√ßo de memoria que sera alterado 
	add $10, $0, 16384 # lenght -> limite do la√ßo // onde termina a rua
	#limites da faixa amarela
	add $11, $0, 15616	 #come√ßo do faixa amarela na linha
	add $12, $11, 127 	 #fim do faixa amarela linha
	
lRua:	beq $10, $9, fimlRua
	#if para saber se pinta amarelo ou cinza
	sge $13, $9, $11 # se $9 >= $11 ent√£o $13 recebe 1.
	sle $14, $9, $12 # se $9 <= $12 ent√£o $14 recebe 1.
	and $15, $13, $14 # faz um and com $13 e $14 recebe 1 ou 0
	bne $15, $0, amareloRua # se for 1 pinta o asfalto senao pinta a faixa
	j cinzaRua 

cinzaRua:
	add $5, $0, 0x808080 # amarelo
	sw $5, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
	j lRua

amareloRua:
	add $5, $0, 0xF5C207 # amarelo
	sw $5, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
	j lRua
fimlRua: jr $31


#def -> defenicoes iniciais:
#casa 1
defCasa:
	add $9, $0, 11264 # i -> contador do la√ßo //ja come√ßa onde pinta a rua
	mul $16, $9, 4 #para pegar o espa√ßo de memoria correto
	add $8, $4, $16 # espa√ßo de memoria que sera alterado 
	add $10, $0, 12032 # lenght -> limite do la√ßo // onde termina a rua
	#limites da Casa
	add $11, $0, 14	 #Comeco da casa
	add $12, $0, 16 #fim da Casa
	add $11, $11, $9
	add $12, $12, $9
	
	 
	
lCasa:	beq $10, $9, fimlCasa
	#if para saber se pinta amarelo ou cinza
	sge $13, $9, $11 # se $9 >= $11 ent√£o $13 recebe 1.
	sle $14, $9, $12 # se $9 <= $12 ent√£o $14 recebe 1.
	and $15, $13, $14 # faz um and com $13 e $14 recebe 1 ou 0
	slti $16, $9,11648
	and $17, $15, $16
	bne $17, $0, PretoCasa # se for 1 pinta o asfalto senao pinta a faixa
	bne $15, $0, corCasa
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
	beq $9, 11392, aumentarLinhaCasa
	beq $9, 11520, aumentarLinhaCasa
	j lCasa
	
PretoCasa:
	add $5, $0, 0x000000 # preto
	sw $5, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
	beq $9, $12, pulaLinhaCasa 
	j lCasa
corCasa:
	add $5, $0, 0xFFFFFF # preto
	sw $5, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
	beq $9, $12, pulaLinhaCasa 
	j lCasa
pulaLinhaCasa:
	# soma ao $11 e $12, para pular para o proxima linha
	# para assim desenhar o rio
	add $11, $11, 128 
	add $12, $12, 128
	j lCasa

aumentarLinhaCasa:
	add $11, $11, -2
	add $12, $12, 2
	j lCasa
	
fimlCasa:
	jr $31
	
#casa 2
defCasa1:
	add $9, $0, 11264 # i -> contador do la√ßo //ja come√ßa onde pinta a rua
	mul $16, $9, 4 #para pegar o espa√ßo de memoria correto
	add $8, $4, $16 # espa√ßo de memoria que sera alterado 
	add $10, $0, 12032 # lenght -> limite do la√ßo // onde termina a rua
	#limites da Casa
	add $11, $0, 110	 #Comeco da casa
	add $12, $0, 112 #fim da Casa
	add $11, $11, $9
	add $12, $12, $9
	
	 
	
lCasa1:	beq $10, $9, fimlCasa1
	#if para saber se pinta amarelo ou cinza
	sge $13, $9, $11 # se $9 >= $11 ent√£o $13 recebe 1.
	sle $14, $9, $12 # se $9 <= $12 ent√£o $14 recebe 1.
	and $15, $13, $14 # faz um and com $13 e $14 recebe 1 ou 0
	slti $16, $9,11648
	and $17, $15, $16
	bne $17, $0, PretoCasa1 # se for 1 pinta o asfalto senao pinta a faixa
	bne $15, $0, corCasa1
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
	beq $9, 11392, aumentarLinhaCasa1
	beq $9, 11520, aumentarLinhaCasa1
	j lCasa
	
PretoCasa1:
	add $5, $0, 0x000000 # preto
	sw $5, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
	beq $9, $12, pulaLinhaCasa1
	j lCasa1
corCasa1:
	add $5, $0, 0xFFFFFF # preto
	sw $5, 0($8) # pintar valor
	addi $8, $8, 4 # [$8]+4
	addi $9, $9, 1 # i++
	beq $9, $12, pulaLinhaCasa1 
	j lCasa1
pulaLinhaCasa1:
	# soma ao $11 e $12, para pular para o proxima linha
	# para assim desenhar o rio
	add $11, $11, 128 
	add $12, $12, 128
	j lCasa1

aumentarLinhaCasa1:
	add $11, $11, -2
	add $12, $12, 2
	j lCasa1
	
fimlCasa1:
	jr $31
	
	

