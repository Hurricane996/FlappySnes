.p816
.smart

INITIAL_VELOCITY = $FB80
TERMINAL_VELOCITY = $0300
ACCELERATION = $0060

.segment "CODE"
Playing:
    PHP
    JSR MaybeSpawnPipe
    AXY8
BirdAnim:
    LDA frame_timer
    LSR
    LSR
    LSR
    LSR ; divide by 16
    AND #%00000111 ; then mod it by 8
    TAX
    LDA AnimationTable, X
    STA OAM_BUFFER + 2
BirdPhysics:
    A16
    INC bg1_x
    LDA flappy_sub_vel
    CLC
    ADC #ACCELERATION
    CMP #TERMINAL_VELOCITY
    BMI @NotTerminal
    LDA #TERMINAL_VELOCITY
@NotTerminal:
    STA flappy_sub_vel

    LDA buttons_just_pressed
    BEQ UpdatePosition
    A8
    LDA #SFX_WING
    JSR PlaySfx
    A16
    LDA #INITIAL_VELOCITY
    STA flappy_sub_vel
UpdatePosition:
    A8
    LDA flappy_y
    CLC
    ADC flappy_vel
    ; underflow detection. Worst case, y is $00 and immediately we add $FB. If we are FB or greater, that means we underflowed
    CMP #$FA
    BCC @NotAnUnderflow
    LDA #$00
@NotAnUnderflow:
    STA flappy_y
    CMP #$9e
    BCS Die
    JSR CheckCollision
    PLP
    RTS
Die:
    JSR EnterDead
    PLP
    RTS
EnterPlaying:
    PHP
    A16
    XY8
    JSR SyncScore

    LDA bg1_x ; simplify the maths by making sure our x coordinate always starts at 0
    AND #%0000000000000111
    STA bg1_x
    LDA #INITIAL_VELOCITY
    STA flappy_sub_vel
    LDA #.loword(Playing)
    STA game_state

    LDX #$02 ; 2 -> 3 -> 1 -> 0
    STX current_pipe_index
    A8
    LDA #SFX_WING
    JSR PlaySfx
    PLP
    RTS


MaybeSpawnPipe:
    PHP
    AXY8
    ; based on the tile
    LDA bg1_x
    BIT #%00000111
    BEQ ProbablySpawnPipe
    PLP
    RTS
ProbablySpawnPipe:
    LSR
    LSR ; divide by 8 for 8 pixels then multiply by 2 for word address
    AND #%11110 ; bits 1-4 are the last 4 bits of tile addr, bit 0 is unimportant for words
    TAX
    JMP (.loword(PipeSpawningTable),X)
PipeSpawningTable:
    .word .loword(DoNothing), .loword(DoNothing), .loword(DoNothing), .loword(DoNothing), .loword(DoNothing), .loword(DoNothing), .loword(DoNothing), .loword(DoNothing)
    .word .loword(DoNothing), .loword(DoNothing), .loword(DoNothing), .loword(SpawnPipe0),.loword(SpawnPipe1),.loword(SpawnPipe2),.loword(SpawnPipe3), .loword(DoNothing)
DoNothing:
    A16
    LDA #.loword(BlankColumn)
    STA column_load_loword
    ; bank is always the same
    PLP
    RTS

SpawnPipe0:
    A16
    XY8
    JSR PRNG
    JSR PRNG ; call it twice for 2 random bytes
; start a divide
    LDA rng0
    STA $4204
    LDX #$0E 
    STX $4206
; while divide is running, prep the pipe index, store it into x, then
; update it using y
    LDX z:current_pipe_index 
    TXY 
    INY
    CPY #$04
    BNE @DontMod
    LDY #$00
@DontMod:
    STY z:current_pipe_index
; divide done
    LDA $4216 ; remainder
    STA z:current_pipe_y
; update vram buffer
    ASL
    CLC
    ADC #.loword(Pipe0)
    STA column_load_loword
; Update pipe y values
    A8
    LDA #14
    CLC
    SBC current_pipe_y
    ASL
    ASL
    ASL
    STA pipes_y,X
    ; bank is always the same
    PLP
    RTS

SpawnPipe1:
    A16
    LDA current_pipe_y
    ASL
    CLC
    ADC #.loword(Pipe1)
    STA column_load_loword
    ; bank is always the same
    PLP
    RTS


SpawnPipe2:
    A16
    LDA current_pipe_y
    ASL
    CLC
    ADC #.loword(Pipe2)
    STA column_load_loword
    ; bank is always the same
    PLP
    RTS

SpawnPipe3:
    A16
    LDA current_pipe_y
    ASL
    CLC
    ADC #.loword(Pipe3)
    STA column_load_loword
    ; bank is always the same
    PLP
    RTS

IncrementScore:
    PHP
    A8
    LDA z:unspawned_pipes_left
    BEQ @Continue
    DEC z:unspawned_pipes_left
    PLP
    RTS
@Continue:
    INC z:score
    LDA #SFX_POINT
    JSR PlaySfx
    LDA score
    BRA SyncScoreCommon
SyncScore:
    PHP
    A8
SyncScoreCommon:
    STA $4204
    STZ $4205
    LDA #10
    STA $4206
    LDA score ; 5
    CMP f:high_score ;10
    BMI @HSDone ; 12/13
    STA f:high_score ; 17
    STA f:high_score + 1 ; 22
    BRA @HSDone2 ; 25
@HSDone:
    NOP ; 15
    NOP ; 17
@HSDone2:
    LDA $4216 ; ignore high byte
    INC A
    CLC
    ASL A
    STA scoreOneIndex

    LDA $4214
    BEQ @Done 
    INC A
    CLC
    ASL A
@Done:
    STA scoreTenIndex
    INC scoreUpdatedThisFrame
    PLP
    RTS

; [003f,0065] -> 0
; [00bf,00e5] -> 1
; [013f,0165] -> 2
; [01bf,01e5] -> 3

CheckCollision:
    PHP
    AXY8
    LDA z:bg1_x
    CMP #$3f
    BCC NoCollision
    LDX #$00
    CMP #$64
    BEQ Score
    BCC MaybeCollision
    CMP #$Bf
    BCC NoCollision
    LDX #$01
    CMP #$E4
    BEQ Score
    BCC MaybeCollision
NoCollision:
    PLP
    RTS
Score:
    JSR IncrementScore
    PLP
    RTS
MaybeCollision:
    LDA z:bg1_x + 1
    AND #$01
    CLC
    ASL
    STA z:temp

    TXA
    ORA z:temp

    TAX

    LDA pipes_y,X

    CMP #$FF
    BEQ NoCollision
ProbablyCollision:

    CMP flappy_y
    BCS Collision

    ADC #(8*8 - 12) 
    CMP flappy_y
    BCS NoCollision

Collision:
    JSR EnterDead
    PLP
    RTS

