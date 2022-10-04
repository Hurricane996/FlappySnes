.p816
.smart

.segment "RODATA"
TILESET:
    .incbin "bg1.chr"
    .incbin "bg2.chr"
    .incbin "gameover.chr"
    .incbin "sprites.chr"
    .incbin "bg3.chr"
TILESET_End:
BG2_Map:    
    .incbin "bg2.map"
BG2_Map_End:
Palette:
    .incbin "palette.pal"
    .incbin "palette.pal" ; TODO dont put 512 bytes of palette data in the rom and proceed to use 24 of them
Palette_end:
BG3ClearTile:
    .word $2800

BG1GrassTileLo:
    .word $c5
BG1DirtTileLo:
    .word $78
BG1TileHi:
    .word $04

GameOverStripeData:
    ; no flip: %00101100 = $2C
    ; h-flip: %01101100 = $4C
    .word $2cd2,$2cd5,$2cd5,$2cd5,$2cd5,$2cd5,$2ce1
    .word $2cd3,$2cd6,$2cda,$2cda,$2cda,$2cda,$2cd4
    .word $2cd3,$2cd7,$2cda,$2cdb,$2cde,$2cda,$2cd4
    .word $2cd3,$2cd8,$2cda,$2cdc,$2cdf,$2cda,$2cd4
    .word $2cd3,$2cd9,$2cda,$2cdd,$2ce0,$2cda,$2cd4
    .word $6cd2,$6cd5,$6cd5,$6cd5,$6cd5,$6cd5,$6ce1



.segment "CODE"
LoadGraphics:
Tileset: 
    PHP
    A8
    XY16
    LDA #V_INC_1
    STA VMAIN
    LDX #$0000
    STX VMADDL 
    LDA #1
    STA $4300 ; transfer mode 2 regs, 1 write
    LDA #$18
    STA $4301 ; write to vram data
    LDX #.loword(TILESET)
    STX $4302
    LDA #^TILESET
    STA $4304
    LDX #(TILESET_End - TILESET)
    STX $4305
    LDA #1
    STA $420b ; start dma
BG2Map:
    LDX #$1980 ; first however many bytes are 0, skip them
    STX VMADDL 

    JSR BG2Inner
BG2DeadMap:
    LDX #$2180
    STX VMADDL 

    JSR BG2Inner


    LDY #$208D
    LDX #.loword(GameOverStripeData)
    LDA #^(GameOverStripeData)
    STA temp
    LDA #7
    STA temp + 1
    LDA #6
    JSR LoadVerticalStripeImage

BG1Map:
    LDX #$12A0
    STX VMADDL
    JSR @LoInner
    LDX #$16A0
    STX VMADDL
    JSR @LoInner

    ; Hi Byte
    LDA #V_INC_1
    STA VMAIN
    LDX #$12A0
    STX VMADDL
    JSR @HiInner
    LDX #$16A0
    STX VMADDL
    JSR @HiInner

    PLP
    RTS

@HiInner:
    LDX #.loword(BG1TileHi)
    STX $4302
    LDA #^BG1TileHi
    STA $4304
    LDX #$160
    STX $4305
    LDA #$19
    STA $4301
    LDA #%00001000 ; no autoincrement, 1 write 1 reg
    STA $4300

    LDA #$01
    STA $420b
    RTS

@LoInner:
    STZ VMAIN

    ; tiles to copy
    LDX #.loword(BG1GrassTileLo)
    STX $4302
    LDX #.loword(BG1DirtTileLo)
    STX $4312

    ; bank
    LDA #^BG1GrassTileLo
    STA $4304
    STA $4314 ; they are in the same bank

    ; amount to copy
    LDX #$20
    STX $4305
    LDX #$140
    STX $4315
    
    ; 
    LDA #$18
    STA $4301
    STA $4311

    LDA #%00001000 ; no autoincrement, 1 write 1 reg
    STA $4300
    STA $4310


    LDA #%11 ; activate 2 dma channels
    STA $420B
    RTS
BG2Inner:
    LDA #1
    STA $4300 ; transfer mode 2 regs, 1 write
    LDA #$18
    STA $4301 ; write to vram data
    LDX #.loword(BG2_Map)
    STX $4302
    LDA #^BG2_Map
    STA $4304
    LDX #(BG2_Map_End - BG2_Map)
    STX $4305
    LDA #1
    STA $420b ; start dma
    RTS

; X = source
; Y = dest
; A = Width
; temp[0]: bank
; temp[1]: height
LoadVerticalStripeImage:
    CLC
    PHA
    LDA #V_INC_32
    STA VMAIN
    ASL temp + 1
    PLA
@Loop:
    PHA

    STY VMADDL

    LDA #%01
    STA $4300
    LDA #$18
    STA $4301
    STX $4302
    ;4303
    LDA temp
    STA $4304
    LDA temp + 1
    STA $4305
    STZ $4306

    LDA #$1
    STA $420B

    A16
    TXA ; source needs to be incremented by height times 2
    ADC temp+1
    TAX
    INY; dest needs to be incremented by 1
    A8
    PLA
    DEC A
    CMP #$FF
    BNE @Loop
    RTS




BG3NumberTile =  %0010100000000000
FLAPPY_0 = $E2
FLAPPY_1 = $E4
FLAPPY_2 = $E6

.segment "RODATA" ; doesnt strictly need to be in same bank as nmi handler but its faster if it is 
NumberTopTile:
    .word $2800,$29F1,$29F2,$29F3,$29F3,$29F4,$29F5,$29F5,$29F6,$29F7,$29F7
NumberBottomTile:
    .word $2800,$A9F1,$29F8,$A9F5,$A9F3,$29F9,$A9F3,$A9F7,$29F8,$A9F7,$29F9