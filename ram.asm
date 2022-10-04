.p816
.smart

.segment "ZEROPAGE"
temp: .res 8
nmi_temp: .res 8
num_nmis: .res 1

bg1_x: .res 2

frame_timer: .res 1

game_state: .res 2

flappy_y: .res 1

flappy_sub_vel: .res 1
flappy_vel: .res 1

buttons_pressed: .res 2
buttons_just_pressed: .res 2

column_load_loword: .res 2
column_load_bank: .res 1

rng0: .res 1
rng1: .res 1
rng2: .res 1
rng3: .res 1

unspawned_pipes_left: .res 1 ; starts at 2, decrements every time we could score, prevents scoring until 0
score: .res 1

current_pipe_y: .res 2 ; we have to deal with this while a is in 16 bit mode, may as well reserve a second byte for it to make our lives easier
current_pipe_index: .res 1

pipes_y: .res 4

scoreUpdatedThisFrame: .res 1
hiScoreUpdatedThisFrame: .res 1

scoreOneIndex: .res 1
scoreTenIndex: .res 1

hiScoreOneIndex: .res 1
hiScoreTenIndex: .res 1

bg2sc_mirror: .res 1

.segment "SRAM"
high_score: .res 1

.segment "BSS"
OAM_BUFFER: .res 512
OAM_BUFFER2: .res 32