.text
main:
    addi $a1 $0 5000 # tempo
    addi $a2 $0 90 # instrumento
    addi $a3 $0 127 # volume
    addi $a0 $0 21 # nota
    addi $v0 $0 31 # syscall
    syscall
   
    # pausa
    addi $v0 $0 32
    addi $a0 $0 1000
    syscall
   
    addi $a1 $0 500 # tempo
    addi $a2 $0 127 # instrumento
    addi $a3 $0 127 # volume
    addi $a0 $0 50 # nota
    addi $v0 $0 31 # syscall
    syscall
fim:
    addi $v0 $0 10
    syscall


