.include beta.uasm

main:
    ADDC(R31, 16, R1)
    ADDC(R31, 17, R9)
    ADDC(R31, 17, R10)
    ADDC(R31, 17, R11)
    BEQ(R4, test, R2)
    ADD(R31, 0, R31)
test:
    ADD(R31, 1, R31)
    EXIT()