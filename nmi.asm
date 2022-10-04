    .p816
    .smart

.segment "CODE"
NMI_stub:
    JML NMI ; jump out of mirrored bank 00 into real bank 80

NMI:
    php
    AXY16
    phb
    pha
    phx
    phy
    phd
    AXY8
    LDX z:bg2sc_mirror
    STX BG2SC
    LDA z:bg1_x
    BIT #%00000111 
    BNE @DontLoadAColumn
@GetColumnAddress:
    LDA z:bg1_x
    LSR A
    LSR A
    LSR A
    XBA ; move addr low byte to a hi byte so we can setup addr hi byte in a lo byte
    LDA z:bg1_x + 1 ; high byte of background
    AND #$01 ; only the first bit
    EOR #$01 ; and invert it, we want to write to the nametable we are not in
    ASL
    ASL ; move to bit 4, this now contains either #$00 or #$04
    ORA #$10 ; #$10 or #$14
    XBA ; right now addr lo is in a hi and vice versa, fix
    A16
@ColumnDMA:
    STA VMADDL 
    LDX #V_INC_32
    STX VMAIN

    LDX #%00000001 ; 2 bytes, 2 registers
    STX $4300
    LDX #$18
    STX $4301 ; write to vram data
    LDA z:column_load_loword
    STA $4302 ; and 4303
    LDX z:column_load_bank
    STX $4304
    LDX #$002A ; 21 words (42 bytes) of column data is written
    STX $4305
    LDX #$01
    STX $420B ; sendit

@DontLoadAColumn:
    A8
    XY16
    LDA #%10000000
    STA INIDISP ; fblank so we don't catch fire in event of lag
    INC z:num_nmis

    LDA z:bg1_x 
    STA BG1HOFS
    LDA z:bg1_x + 1
    STA BG1HOFS

    JSR DMA_OAM

DisplayScore:
    LDA z:scoreUpdatedThisFrame
    A16
    XY8
    BEQ @Done
    STZ z:scoreUpdatedThisFrame
    LDX #V_INC_1
    STX VMAIN
    LDA #$1ccf
    STA VMADDL
    LDX z:scoreTenIndex
    LDA NumberTopTile,X
    STA VMDATAL
    LDX z:scoreOneIndex
    LDA NumberTopTile,X    
    STA VMDATAL
    LDA #$1cef
    STA VMADDL
    LDX z:scoreTenIndex
    LDA NumberBottomTile,X
    STA VMDATAL
    LDX z:scoreOneIndex
    LDA NumberBottomTile,X    
    STA VMDATAL
@Done:

DisplayHighScore:
    A8
    LDA z:hiScoreUpdatedThisFrame
    BEQ @Done
    STZ z:hiScoreUpdatedThisFrame
    A16

    LDX #V_INC_1
    STX VMAIN
    LDA #$1d2f
    STA VMADDL
    LDX z:hiScoreTenIndex
    LDA NumberTopTile,X
    STA VMDATAL
    LDX z:hiScoreOneIndex
    LDA NumberTopTile,X    
    STA VMDATAL
    LDA #$1d4f
    STA VMADDL
    LDX z:hiScoreTenIndex
    LDA NumberBottomTile,X
    STA VMDATAL
    LDX z:hiScoreOneIndex
    LDA NumberBottomTile,X    
    STA VMDATAL
@Done:
    A16
UnFblank:
    LDX #%00001111
    STX INIDISP ; un fblank now that we're done with vblank

; process joypad
    LDA z:buttons_pressed
    STA z:nmi_temp ; temp 0 is now buttons pressed previous frame
    LDA JOY1L ; by the power of 16 bit a this will load cntrl1 and cntrl2
    STA z:buttons_pressed
    LDA z:nmi_temp
    EOR #%1111111111111111 ; invert everything, now a contains buttons not pressed previous frames
    AND z:buttons_pressed
    STA z:buttons_just_pressed

    BIT $4210 ; nmi over
    AXY16
    pld
    ply
    plx
    pla
    plb
    plp
    RTI

BRK_HANDLER:
    A8
    STZ CGADD
    LDA #%00011111
    STA CGDATA
    LDA #%00000000
    STA CGDATA
    STZ TM ; turn the screen off if we jump to garbag
    RTI
IRQ:
    BIT $4211
IRQ_end:
    RTI

