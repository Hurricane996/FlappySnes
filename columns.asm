.p816
.smart

.segment "RODATA"

BLANK_TILE = $0000

PIPE_BODY_0 = $04C6 
PIPE_MIDDLE_DOWN_0 = $04CE
PIPE_HEAD_DOWN_0 = $04CA
PIPE_MIDDLE_UP_0 = $84CE
PIPE_HEAD_UP_0 = $84CA

PIPE_BODY_1 = $04C7 
PIPE_MIDDLE_DOWN_1 = $04CF
PIPE_HEAD_DOWN_1 = $04CB
PIPE_MIDDLE_UP_1 = $84CF
PIPE_HEAD_UP_1 = $84CB

PIPE_BODY_2 = $04C8 
PIPE_MIDDLE_DOWN_2 = $04D0
PIPE_HEAD_DOWN_2 = $04CC
PIPE_MIDDLE_UP_2 = $84D0
PIPE_HEAD_UP_2 = $84CC

PIPE_BODY_3 = $04C9 
PIPE_MIDDLE_DOWN_3 = $04D1
PIPE_HEAD_DOWN_3 = $04CD
PIPE_MIDDLE_UP_3 = $84D1
PIPE_HEAD_UP_3 = $84CD


BlankColumn:
    .word BLANK_TILE, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE

Pipe0:
    .word PIPE_BODY_0, PIPE_BODY_0, PIPE_BODY_0, PIPE_BODY_0
    .word PIPE_BODY_0, PIPE_BODY_0, PIPE_BODY_0, PIPE_BODY_0
    .word PIPE_BODY_0, PIPE_BODY_0, PIPE_BODY_0, PIPE_MIDDLE_DOWN_0
    .word PIPE_HEAD_DOWN_0, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, PIPE_HEAD_UP_0, PIPE_MIDDLE_UP_0, PIPE_BODY_0
    .word PIPE_BODY_0, PIPE_BODY_0, PIPE_BODY_0, PIPE_BODY_0
    .word PIPE_BODY_0, PIPE_BODY_0, PIPE_BODY_0, PIPE_BODY_0 
    .word PIPE_BODY_0, PIPE_BODY_0

Pipe1:
    .word PIPE_BODY_1, PIPE_BODY_1, PIPE_BODY_1, PIPE_BODY_1
    .word PIPE_BODY_1, PIPE_BODY_1, PIPE_BODY_1, PIPE_BODY_1
    .word PIPE_BODY_1, PIPE_BODY_1, PIPE_BODY_1, PIPE_MIDDLE_DOWN_1
    .word PIPE_HEAD_DOWN_1, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, PIPE_HEAD_UP_1, PIPE_MIDDLE_UP_1, PIPE_BODY_1
    .word PIPE_BODY_1, PIPE_BODY_1, PIPE_BODY_1, PIPE_BODY_1
    .word PIPE_BODY_1, PIPE_BODY_1, PIPE_BODY_1, PIPE_BODY_1 
    .word PIPE_BODY_1, PIPE_BODY_1

 Pipe2:
    .word PIPE_BODY_2, PIPE_BODY_2, PIPE_BODY_2, PIPE_BODY_2
    .word PIPE_BODY_2, PIPE_BODY_2, PIPE_BODY_2, PIPE_BODY_2
    .word PIPE_BODY_2, PIPE_BODY_2, PIPE_BODY_2, PIPE_MIDDLE_DOWN_2
    .word PIPE_HEAD_DOWN_2, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, PIPE_HEAD_UP_2, PIPE_MIDDLE_UP_2, PIPE_BODY_2
    .word PIPE_BODY_2, PIPE_BODY_2, PIPE_BODY_2, PIPE_BODY_2
    .word PIPE_BODY_2, PIPE_BODY_2, PIPE_BODY_2, PIPE_BODY_2 
    .word PIPE_BODY_2, PIPE_BODY_2   

Pipe3:
    .word PIPE_BODY_3, PIPE_BODY_3, PIPE_BODY_3, PIPE_BODY_3
    .word PIPE_BODY_3, PIPE_BODY_3, PIPE_BODY_3, PIPE_BODY_3
    .word PIPE_BODY_3, PIPE_BODY_3, PIPE_BODY_3, PIPE_MIDDLE_DOWN_3
    .word PIPE_HEAD_DOWN_3, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, BLANK_TILE, BLANK_TILE, BLANK_TILE
    .word BLANK_TILE, PIPE_HEAD_UP_3, PIPE_MIDDLE_UP_3, PIPE_BODY_3
    .word PIPE_BODY_3, PIPE_BODY_3, PIPE_BODY_3, PIPE_BODY_3
    .word PIPE_BODY_3, PIPE_BODY_3, PIPE_BODY_3, PIPE_BODY_3 
    .word PIPE_BODY_3, PIPE_BODY_3