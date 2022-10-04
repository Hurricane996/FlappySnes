.p816
.smart

.segment "RODATA" 
    .include "spc700program.asm"

.segment "CODE"

SFX_WING = %00000100
SFX_POINT = %00000010
SFX_HIT = %00000001

LoadSPC700Program:
    PHP
    A8
    XY16
    
    LDX #$0200
    LDA #$AA
@wait:
    CMP APUIO0
    BNE @wait

    STX APUIO2
    LDX #(SPC_PROGRAM_END - SPC_PROGRAM_START)

    LDA #$01
    STA APUIO1
    LDA #$cc
    STA APUIO0 
@wait2:
    CMP APUIO0
    BNE @wait2

    LDY #$0000
@loop:
    ; we're setting up full width a to contain our destination and counter
    ; load data into the high byte
    XBA
    LDA SPC_PROGRAM_START,Y 
    XBA

    ; then load our counter into the lowbyte
    TYA

    A16
    STA APUIO0
    A8
@wait3:
    CMP APUIO0
    BNE @wait3

    INY
    DEX
    BNE @loop

    LDX #(EntryPoint - SPC_PROGRAM_START + $200)
    STX APUIO2

    INC A
    INC A

    A16
    AND #$00FF

    STA APUIO0

@Done:
    PLP
    RTS

; a, 8 bit: sfx to play
PlaySfx:
    PHP
    A8
    STA APUIO0
    LDA APUIO2
    STA APUIO1
    PLP
    RTS
