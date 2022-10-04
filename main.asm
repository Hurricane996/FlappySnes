    .p816
    .smart

    .include "macros.asm"
    .include "header.asm"
    .include "nmi.asm"
    .include "reset.asm"
    .include "ram.asm"
    
    .include "game_states/not_playing.asm"
    .include "game_states/playing.asm"
    .include "game_states/dead.asm"


    .include "gfx/gfx.asm"
    .include "hwregs.inc"

    .include "columns.asm"

    .include "prng.asm"

    .include "sound/snesdriver.asm"

.segment "RODATA"

RandomZeroByte: .byte $00
.segment "CODE"
SoftReset:
    A8
    XY16
    ; first turn on FBLANK
    ;LDA #%10000000
    ;STA INIDISP
    ; and tuirn off nma irq and ajr
    STZ NMITIMEN
    ; next reset the stack. values from before our reset are in there,
    ; and this could cause a stack overflow, which we dont want
    LDX #$1fff
    TXS
    LDX #$0000 ; now x is 0 so we can STX as a 16 bit STZ
    ; some important stzs
    ; temp values don't need cleared (i hope) because 
    ; nothing is relying on them being 0
    STZ z:num_nmis ; this counter is lag frame related, needs cleared
    STX z:bg1_x; scroll value. we could probably get away with not clearing this, but cringe
    STZ z:score ; obvious
    STX z:current_pipe_y
    STX z:pipes_y
    STX z:pipes_y + 2

    LDA #V_INC_1
    STA VMAIN
    ; clear BG1 (1000 to 1270). We just need to clear screen 1
    ; because screen 2 is missing
    LDX #$1000
    STX VMADDL

    LDA #%00001001 ; two regs write once, no increment
    STA DMAPx + CH0
    LDA #$18
    STA BBADx + CH0
    LDX #.loword(RandomZeroByte)
    STX A1TxL + CH0
    LDA #^RandomZeroByte
    STA A1Bx + CH0
    LDX #$0540
    STX DASxL + CH0
    LDA #$01
    STA MDMAEN
    ; clear BG3


    LDY #$2800

    LDX #$1ccf
    STX VMADDL
    STY VMDATAL
    STY VMDATAL
    LDX #$1cef
    STX VMADDL
    STY VMDATAL
    STY VMDATAL

    LDX #$1d2f
    STX VMADDL
    STY VMDATAL
    STY VMDATAL
    LDX #$1d4f
    STX VMADDL
    STY VMDATAL
    STY VMDATAL

    JMP MemoryInitialization
Main:
    A8
    XY16
SeedRng:
    LDX #$ADEA
    STX rng0
    LDX #$DCA0 ; (get it? a dead cow?)
    STX rng2

ResetSaveRam:
    LDA f:high_score
    CMP #99
    BCS @Reset
    CMP f:high_score + 1
    BEQ @Done
@Reset:
    LDA #$00
    STA f:high_score
    STA f:high_score + 1
@Done:

    JSR LoadSPC700Program

InitializeGraphics:
    JSR LoadGraphics

    ; scroll all vgs down by 1 pixel because of a ppu bug
    LDA #1
    STA BG1VOFS
    STZ BG1VOFS
    STA BG2VOFS
    STZ BG2VOFS

    LDA #%00001001
    STA BGMODE  ; background mode 1 with priority stuff
    STZ BG12NBA ;  tiles for backgrounds 1 and 2 are at address $0000
    STZ BG34NBA ; tiles for background 3 and 4 are too
    LDA #($10|%01) ; BG1 at $1000 words / $2000 bytes, 64x32
    STA BG1SC
    LDA #$18
    STA BG2SC
    LDA #$1C ; BG3 map at $1C00 words, $3800 bytes
    STA BG3SC 

    ; scroll bg3 to align with the death popup on bg2
    LDA #$03
    STA BG3VOFS
    STZ BG3VOFS

    LDA #(BG1_ON|BG2_ON|BG3_ON|SPR_ON) ; turn the relevant backgrounds off
    STA TM

    LDA #%01100000 ; 16x16 and 32x32 sprites, sprite offset 0
    STA OBSEL
MemoryInitialization:
    LDX #.loword(BlankColumn) ; load a blank column to the right of background 1 
    STX column_load_loword
    LDA #^BlankColumn
    STA column_load_bank

    LDA #2
    STA unspawned_pipes_left


    LDX #$ffff
    STX buttons_pressed ; pretend all the buttons are pressed on the first frame
    STX pipes_y
    STX pipes_y + 2

    LDA #$18
    STA bg2sc_mirror
    
    LDX #$7818; y pos 78, x pos 18
    STX OAM_BUFFER
    LDX #(%0011010000000000|FLAPPY_0)
    STX OAM_BUFFER + 2

    LDX #.loword(NotPlaying)
    STX game_state

StartGame:
    LDA #$0f ; turn on display
    STA INIDISP

    LDA #NMI_ON|AUTO_JOY_ON ; and activate nmi/auto joypad read
	STA NMITIMEN ;$4200

GameLoop:
    LDA num_nmis
    BEQ GameLoop ; wait until there has been at least one nmi
    INC frame_timer

    JSR PRNG

    LDX #$0
    JSR (game_state,X)

    LDA flappy_y
    SEC
    SBC #$04
    STA OAM_BUFFER + 1

    DEC num_nmis
    LDA OBSEL ; this will show up on the event viewer
    JMP GameLoop
