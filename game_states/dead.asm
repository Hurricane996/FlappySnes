.p816
.smart
.segment "CODE"


Dead:
    PHP
    A16
    LDA buttons_just_pressed


        ; bysSUDLRaxlr0000
    AND #%1001000010000000
    BEQ @noAButton
    JMP SoftReset
@noAButton:
    PLP
    RTS

EnterDead:
    PHP
    A16
    XY8
    LDX #$20
    STX bg2sc_mirror
    LDA #.loword(Dead)
    STA game_state

    ; prep to display the high score value
    A8
    LDA #SFX_HIT
    JSR PlaySfx
    LDA f:high_score
    STA $4204
    STZ $4205
    LDA #10
    STA $4206
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDA $4216 ; ignore high byte
    INC A
    CLC
    ASL A
    STA hiScoreOneIndex

    LDA $4214
    BEQ @Done 
    INC A
    CLC
    ASL A
@Done:
    STA hiScoreTenIndex
    INC hiScoreUpdatedThisFrame
    PLP
    RTS