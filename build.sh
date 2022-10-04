ca65 main.asm -g &&
ld65 -C lorom256k.cfg -o flappy.sfc main.o -Ln labels.txt
