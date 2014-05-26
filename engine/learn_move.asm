LearnMove: ; 6e43 (1:6e43)
	call SaveScreenTilesToBuffer1
	ld a, [wWhichPokemon] ; $cf92
	ld hl, W_PARTYMON1NAME ; $d2b5
	call GetPartyMonName
	ld hl, $cd6d
	ld de, $d036
	ld bc, $b
	call CopyData

DontAbandonLearning: ; 6e5b (1:6e5b)
	ld hl, W_PARTYMON1_MOVE1 ; $d173
	ld bc, $2c
	ld a, [wWhichPokemon] ; $cf92
	call AddNTimes
	ld d, h
	ld e, l
	ld b, $4
.asm_6e6b
	ld a, [hl]
	and a
	jr z, .asm_6e8b
	inc hl
	dec b
	jr nz, .asm_6e6b
	push de
	call TryingToLearn
	pop de
	jp c, AbandonLearning
	push hl
	push de
	ld [$d11e], a
	call GetMoveName
	ld hl, OneTwoAndText
	call PrintText
	pop de
	pop hl
.asm_6e8b
	ld a, [$d0e0]
	ld [hl], a
	ld bc, $15
	add hl, bc
	push hl
	push de
	dec a
	ld hl, Moves ; $4000
	ld bc, $6
	call AddNTimes
	ld de, $cee9
	ld a, BANK(Moves)
	call FarCopyData
	ld a, [$ceee]
	pop de
	pop hl
	ld [hl], a
	ld a, [W_ISINBATTLE] ; $d057
	and a
	jp z, PrintLearnedMove
	ld a, [wWhichPokemon] ; $cf92
	ld b, a
	ld a, [wPlayerMonNumber] ; $cc2f
	cp b
	jp nz, PrintLearnedMove
	ld h, d
	ld l, e
	ld de, W_PLAYERMONMOVES
	ld bc, $4
	call CopyData
	ld bc, $11
	add hl, bc
	ld de, W_PLAYERMONPP ; $d02d
	ld bc, $4
	call CopyData
	jp PrintLearnedMove

AbandonLearning: ; 6eda (1:6eda)
	ld hl, AbandonLearningText
	call PrintText
	FuncCoord 14, 7 ; $c43a
	ld hl, Coord
	ld bc, $80f
	ld a, $14
	ld [$d125], a
	call DisplayTextBoxID
	ld a, [wCurrentMenuItem] ; $cc26
	and a
	jp nz, DontAbandonLearning
	ld hl, DidNotLearnText
	call PrintText
	ld b, $0
	ret

PrintLearnedMove: ; 6efe (1:6efe)
	ld hl, LearnedMove1Text
	call PrintText
	ld b, $1
	ret

TryingToLearn: ; 6f07 (1:6f07)
	push hl
	ld hl, TryingToLearnText
	call PrintText
	FuncCoord 14, 7 ; $c43a
	ld hl, Coord
	ld bc, $80f
	ld a, $14
	ld [$d125], a
	call DisplayTextBoxID
	pop hl
	ld a, [wCurrentMenuItem] ; $cc26
	rra
	ret c
	ld bc, $fffc
	add hl, bc
	push hl
	ld de, $d0dc
	ld bc, $4
	call CopyData
	callab Func_39b87
	pop hl
.asm_6f39
	push hl
	ld hl, WhichMoveToForgetText
	call PrintText
	FuncCoord 4, 7 ; $c430
	ld hl, Coord
	ld b, $4
	ld c, $e
	call TextBoxBorder
	FuncCoord 6, 8 ; $c446
	ld hl, Coord
	ld de, $d0e1
	ld a, [$fff6]
	set 2, a
	ld [$fff6], a
	call PlaceString
	ld a, [$fff6]
	res 2, a
	ld [$fff6], a
	ld hl, wTopMenuItemY ; $cc24
	ld a, $8
	ld [hli], a
	ld a, $5
	ld [hli], a
	xor a
	ld [hli], a
	inc hl
	ld a, [$cd6c]
	ld [hli], a
	ld a, $3
	ld [hli], a
	ld [hl], $0
	ld hl, $fff6
	set 1, [hl]
	call HandleMenuInput
	ld hl, $fff6
	res 1, [hl]
	push af
	call LoadScreenTilesFromBuffer1
	pop af
	pop hl
	bit 1, a
	jr nz, .asm_6fab
	push hl
	ld a, [wCurrentMenuItem] ; $cc26
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	push af
	push bc
	call IsMoveHM
	pop bc
	pop de
	ld a, d
	jr c, .asm_6fa2
	pop hl
	add hl, bc
	and a
	ret
.asm_6fa2
	ld hl, HMCantDeleteText
	call PrintText
	pop hl
	jr .asm_6f39
.asm_6fab
	scf
	ret

LearnedMove1Text: ; 6fb4 (1:6fb4)
	TX_FAR _LearnedMove1Text
	db $b,6,"@"

WhichMoveToForgetText: ; 6fb4 (1:6fb4)
	TX_FAR _WhichMoveToForgetText
	db "@"

AbandonLearningText: ; 6fb9 (1:6fb9)
	TX_FAR _AbandonLearningText
	db "@"

DidNotLearnText: ; 6fbe (1:6fbe)
	TX_FAR _DidNotLearnText
	db "@"

TryingToLearnText: ; 6fc3 (1:6fc3)
	TX_FAR _TryingToLearnText
	db "@"

OneTwoAndText: ; 6fc8 (1:6fc8)
	TX_FAR _OneTwoAndText
	db $a
	db $8
	ld a, (SFX_02_58 - SFX_Headers_02) / 3
	call PlaySoundWaitForCurrent
	ld hl, PoofText
	ret

PoofText: ; 6fd7 (1:6fd7)
	TX_FAR _PoofText
	db $a
ForgotAndText: ; 6fdc (1:6fdc)
	TX_FAR _ForgotAndText
	db "@"

HMCantDeleteText: ; 6fe1 (1:6fe1)
	TX_FAR _HMCantDeleteText
	db "@"
