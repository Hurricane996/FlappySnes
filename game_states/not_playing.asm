.p816
.smart
.segment "CODE"

FLAPPY_INITIAL_POSITION = 224/2

NotPlaying:
    PHP
    AXY8
    LDA frame_timer
    LSR
    LSR
    LSR
    LSR ; divide by 16
    AND #%00000111 ; then mod it by 8
    TAX
    LDA AnimationTable, X
    STA OAM_BUFFER + 2
    LDA FlappyPosTable, X
    STA flappy_y

    A16
    LDA buttons_just_pressed
        ; bysSUDLRaxlr0000
    AND #%1001000010000000
    BEQ @noAButton
    JSR EnterPlaying
@noAButton:
    A16
    INC bg1_x
    PLP
    RTS

.segment "RODATA"
AnimationTable:
    .byte FLAPPY_2, FLAPPY_0, FLAPPY_1, FLAPPY_0,FLAPPY_2, FLAPPY_0, FLAPPY_1, FLAPPY_0
FlappyPosTable:
    .byte 112,113,113,112,112,111,111,112

