.data
.text
.globl main
main:
addi s0,s0,-1024
auipc t1,0xf
sw t1,(s0)

