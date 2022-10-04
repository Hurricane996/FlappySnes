.setcpu "none"
.include "spc-ca65.inc"

; Memory Map
; 0000-00EF: Variables
; 00F0-00FF: Registers
; 0100-01FF: Stack
; 0200-XXXX: Sample Directory
; XXXX-YYYY: Code
; YYYY-FFFF: Datas

SPC_PROGRAM_START: ; since we're in a different address space, we have to 
                   ; calculate addresses as address - SPC_PROGRAM_START + #$0200
                   ; FIXME this is dumb, how to not have to do this

HitSample:
    .word (HIT_BRR - SPC_PROGRAM_START + $200),(HIT_BRR - SPC_PROGRAM_START + $200)
    .word (POINT_BRR - SPC_PROGRAM_START + $200),(POINT_BRR - SPC_PROGRAM_START + $200)
    .word (WING_BRR - SPC_PROGRAM_START + $200),(WING_BRR - SPC_PROGRAM_START + $200)

EntryPoint:
; set up hit channel (channel 0)
    ; volume 7f for both
    mov a, #$00 
    mov y, #$7f
    movw $f2, ya
    inc a 
    movw $f2, ya
    inc a
    ; pitch 0800 (down 1 octave)
    mov y, #$00
    movw $f2, ya
    inc a
    mov y, #$08
    movw $f2, ya
    inc a
    ; sample 0
    mov y, #$00
    movw $f2, ya
    inc a
    ; zero out the rest
    ; adsr1
    movw $f2, ya
    inc a
    ; adsr 2
    movw $f2, ya
    inc a
    ; gain
    mov y, #$7f ;direct gain, maximum
    movw $f2, ya
 
; set up point channel (channel 1)
    ; volume 7f for both
    mov a, #$10 
    mov y, #$7f
    movw $f2, ya
    inc a 
    movw $f2, ya
    inc a
    ; pitch 0800 (down 1 octave)
    mov y, #$00
    movw $f2, ya
    inc a
    mov y, #$08
    movw $f2, ya
    inc a
    ; sample 1
    mov y, #$01
    movw $f2, ya
    inc a
    mov y, #$00
    ; adsr1
    movw $f2, ya
    inc a
    ; adsr 2
    movw $f2, ya
    inc a
    ; gain
    mov y, #$7f ;direct gain, maximum
    movw $f2, ya
 
; set up wing channel (channel 2)
    ; volume 7f for both
    mov a, #$20 
    mov y, #$7f
    movw $f2, ya
    inc a 
    movw $f2, ya
    inc a
    ; pitch 0800 (down 1 octave)
    mov y, #$00
    movw $f2, ya
    inc a
    mov y, #$08
    movw $f2, ya
    inc a
    ; sample 1
    mov y, #$02
    movw $f2, ya
    inc a
    ; zero out the rest
    mov y, #$00
    ; adsr1
    movw $f2, ya
    inc a
    ; adsr 2
    movw $f2, ya
    inc a
    ; gain
    mov y, #$7f ;direct gain, maximum
    movw $f2, ya
 
; master volume
    mov a, #$0C
    mov y, #$7F
    movw $f2, ya
    mov a, #$1C
    movw $f2, ya
; sample table
    mov y, #$02
    mov a, #$5d
    movw $f2, ya

; flags 00100000 = no reset, no mute, no echo, default noise
    mov y, #$20    
    mov a, #$6c
    movw $f2, ya

; clear everything else
    mov y, #$00
; echo volume
    mov a, #$2c
    movw $f2, ya
; echo volume right
    mov a, #$3c
    movw $f2, ya



; pitch mod
    mov a, #$2d
    movw $f2, ya

; which channels are noise (none of them)
    mov a, #$3d
    movw $f2, ya
; which channels have echo (none of them)
    mov a, #$4d
    movw $f2, ya

; set up our counter for synchronization
    mov $00, #$01
    mov $F6, $00




MainLoop:
    cmp $F5, $00
    bne MainLoop
    inc $00
    mov $F6, $00
    mov y, $F4
    mov a, #$4C
    movw $f2, ya
    bra MainLoop
    

HIT_BRR:
    .INCBIN "hit.brr"
POINT_BRR:
    .INCBIN "point.brr"
WING_BRR:
    .INCBIN "wing.brr"
SPC_PROGRAM_END:
; reenable 65c816 mode
.p816
.smart