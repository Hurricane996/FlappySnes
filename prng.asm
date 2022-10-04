.p816
.smart
; alg by Grog

.segment "CODE"
PRNG:
    PHP
    A8
    LDA rng2
    STA rng3
    LDA rng1
    STA rng2
    LDA rng0
    STA rng1
    CMP rng2
    BMI @R2_GREATER
    LDA rng2
    CLC
    ADC rng3
    STA rng0
    PLP
    RTS
@R2_GREATER:
    CLC
    ADC rng3
    STA rng0
    PLP
    RTS