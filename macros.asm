.define MAP_OFFSET(tile_x,tile_y) (((tile_y)<<5)+(tile_x))

.macro A8
	sep #$20
.endmacro

.macro A16
	rep #$20
.endmacro

.macro AXY8
	sep #$30
.endmacro

.macro AXY16
	rep #$30
.endmacro

.macro XY8
	sep #$10
.endmacro

.macro XY16
	rep #$10
.endmacro
