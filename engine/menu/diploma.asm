DisplayDiploma: ; 566e2 (15:66e2)
	call SaveScreenTilesToBuffer2
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	xor a
	ld [$cfcb], a
	ld hl, $d730
	set 6, [hl]
	call DisableLCD
	ld hl, CircleTile ; $7d88
	ld de, $9700
	ld bc, $0010
	ld a, BANK(CircleTile)
	call FarCopyData2
	ld hl, wTileMap
	ld bc, $1012
	ld a, $27
	call Predef
	ld hl, DiplomaTextPointersAndCoords ; $6784
	ld c, $5
.asm_56715
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call PlaceString
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .asm_56715 ; 0x56725 $ee
	FuncCoord 10, 4 ; $c3fa
	ld hl, Coord
	ld de, W_PLAYERNAME
	call PlaceString
	callba Func_44dd
	ld hl, $c301
	ld bc, $8028
.asm_5673e
	ld a, [hl]
	add $21
	ld [hli], a
	inc hl
	ld a, b
	ld [hli], a
	inc hl
	dec c
	jr nz, .asm_5673e ; 0x56747 $f5
	call EnableLCD
	callba LoadTrainerInfoTextBoxTiles
	ld b, $8
	call GoPAL_SET
	call Delay3
	call GBPalNormal
	ld a, $90
	ld [$ff48], a
	call WaitForTextScrollButtonPress
	ld hl, $d730
	res 6, [hl]
	call GBPalWhiteOutWithDelay3
	call Func_3dbe
	call Delay3
	jp GBPalNormal

Func_56777: ; 56777 (15:6777)
	ld hl, W_PLAYERNAME
	ld bc, $ff00
.asm_5677d
	ld a, [hli]
	cp $50
	ret z
	dec c
	jr .asm_5677d ; 0x56782 $f9

DiplomaTextPointersAndCoords: ; 56784 (15:6784)
	dw DiplomaText
	dw $c3cd
	dw DiplomaPlayer
	dw $c3f3
	dw DiplomaEmptyText
	dw $c3ff
	dw DiplomaCongrats
	dw $c41a
	dw DiplomaGameFreak
	dw $c4e9

DiplomaText:
	db $70,"Diploma",$70,"@"

DiplomaPlayer:
	db "Player@"

DiplomaEmptyText:
	db "@"

DiplomaCongrats:
	db   "Congrats! This"
	next "diploma certifies"
	next "that you have"
	next "completed your"
	next "#dex.@"

DiplomaGameFreak:
	db "GAME FREAK@"
