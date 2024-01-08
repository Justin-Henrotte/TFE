.include beta.uasm

main:
    ADDC(R31, 1, R1)
    ADDC(R1, 1, R2)
    ADDC(R31, 1, R3)
    ADDC(R3, 1, R4)
    ADDC(R4, 1, R5)
    ADDC(R31, 1, R6)
    ADDC(R6, 1, R7)
    ADDC(R7, 1, R8)
    ADDC(R8, 1, R9)
    EXIT()