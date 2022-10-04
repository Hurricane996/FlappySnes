.segment "SNESHEADER"
;$00FFC0-$00FFFF
;      123456789012345678901
.byte "Flappy Bird Clone    " ;rom name 21 chars
.byte $30  ;LoROM FastROM
.byte $02  ; extra chips in cartridge, 00: no extra RAM; 02: RAM with battery
.byte $08  ; ROM size (08-0C typical)
.byte $01  ; backup RAM size (01,03,05 typical; Dezaemon has 07)
.byte $01  ;US
.byte $33  ; publisher id, 'just use 00'
.byte $00  ; ROM revision number
.word $0000  ; checksum of all bytes
.word $0000  ; $FFFF minus checksum

;7fe0 not used
.word $0000
.word $0000

;7fe4 - native mode vectors
.addr IRQ_end  ;cop native **
.addr BRK_HANDLER  ;brk native **
.addr $0000  ;abort native not used *
.addr NMI_stub ;nmi native 
.addr RESET ;RESET native
.addr IRQ ;irq native


;7ff0 not used
.word $0000
.word $0000

;7ff4 - emulation mode vectors
.addr IRQ_end  ;cop emulation **
.addr $0000 ; not used
.addr $0000  ;abort not used *
.addr IRQ_end ;nmi emulation
.addr RESET ;RESET emulation
.addr IRQ_end ;irq/brk emulation **