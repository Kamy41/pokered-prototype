DrawAllPokeballs: ; 3a849 (e:6849)
	call LoadPartyPokeballGfx
	call SetupOwnPartyPokeballs
	ld a, [W_ISINBATTLE]
	dec a
	ret z ; return if wild pokémon
	jp SetupEnemyPartyPokeballs

DrawEnemyPokeballs: ; 3a857 (e:6857)
	call LoadPartyPokeballGfx
	jp SetupEnemyPartyPokeballs

LoadPartyPokeballGfx: ; 3a85d (e:685d)
	ld de, PokeballTileGraphics
	ld hl, vSprites + $310
	ld bc, (BANK(PokeballTileGraphics) << 8) + $04
	jp CopyVideoData

SetupOwnPartyPokeballs: ; 3a869 (e:6869)
	ld hl, PartyTileMap
	call PartyUpdateDone
	ld hl, wPartyMon1
	ld de, wPartyCount
	call SetupPokeballs
	ld a, $60
	ld hl, W_BASECOORDX
	ld [hli], a
	ld [hl], a
	ld a, 8
	ld [wHUDPokeballGfxOffsetX], a
	ld hl, wOAMBuffer
	jp WritePokeballOAMData

SetupEnemyPartyPokeballs: ; 3a887 (e:6887)
	call PlaceEnemyHUDTiles
	ld hl, wEnemyMons
	ld de, wEnemyPartyCount
	call SetupPokeballs
	ld hl, W_BASECOORDX
	ld a, $48
	ld [hli], a
	ld [hl], $20
	ld a, -8
	ld [wHUDPokeballGfxOffsetX], a
	ld hl, wOAMBuffer + PARTY_LENGTH * 4
	jp WritePokeballOAMData

SetupPokeballs: ; 0x3a8a6
	ld a, [de]
	push af
	ld de, wBuffer
	ld c, PARTY_LENGTH
	ld a, $34 ; empty pokeball
.emptyloop
	ld [de], a
	inc de
	dec c
	jr nz, .emptyloop
	pop af
	ld de, wBuffer
.monloop
	push af
	call PickPokeball
	inc de
	pop af
	dec a
	jr nz, .monloop
	ret

PickPokeball: ; 3a8c2 (e:68c2)
	inc hl
	ld a, [hli]
	and a
	jr nz, .alive
	ld a, [hl]
	and a
	ld b, $33 ; crossed ball (fainted)
	jr z, .done_fainted
.alive
	inc hl
	inc hl
	ld a, [hl] ; status
	and a
	ld b, $32 ; black ball (status)
	jr nz, .done
	dec b ; regular ball
	jr .done
.done_fainted
	inc hl
	inc hl
.done
	ld a, b
	ld [de], a
	ld bc, wPartyMon2 - wPartyMon1Status
	add hl, bc ; next mon struct
	ret

WritePokeballOAMData: ; 3a8e1 (e:68e1)
	ld de, wBuffer
	ld c, PARTY_LENGTH
.loop
	ld a, [W_BASECOORDY]
	ld [hli], a
	ld a, [W_BASECOORDX]
	ld [hli], a
	ld a, [de]
	ld [hli], a
	xor a
	ld [hli], a
	ld a, [W_BASECOORDX]
	ld b, a
	ld a, [wHUDPokeballGfxOffsetX]
	add b
	ld [W_BASECOORDX], a
	inc de
	dec c
	jr nz, .loop
	ret

PlacePlayerHUDTiles: ; 3a902 (e:6902)
	ld hl, PlayerBattleHUDGraphicsTiles
PartyUpdateDone:
	ld de, wHUDGraphicsTiles
	ld bc, $3
	call CopyData
	coord hl, 18, 10
	ld de, -1
	jr PlaceHUDTiles

PartyTileMap:
	db $73, $75, $6F

PlayerBattleHUDGraphicsTiles: ; 3a916 (e:6916)
; The tile numbers for specific parts of the battle display for the player's pokemon
	db $73 ; unused ($73 is hardcoded into the routine that uses these bytes)
	db $77 ; lower-right corner tile of the HUD
	db $6F ; lower-left triangle tile of the HUD

PlaceEnemyHUDTiles: ; 3a919 (e:6919)
	ld hl, EnemyBattleHUDGraphicsTiles
	ld de, wHUDGraphicsTiles
	ld bc, $3
	call CopyData
	coord hl, 1, 2
	ld [hl], $72
	ld a, [W_ISINBATTLE]
	dec a
	jr  nz, .noBattle
	push hl
	ld a, [wEnemyMon]
	ld [wd11e], a
	callab IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, $2
	ld hl, wPokedexOwned
	predef FlagActionPredef
	ld a, c
	and a
	jr z, .notOwned
	coord hl, 1, 1
	ld [hl], $E9
.notOwned
	pop hl
.noBattle
	ld de, $0001
	jp HealthBarUpdateDone

EnemyBattleHUDGraphicsTiles: ; 3a92d (e:692d)
; The tile numbers for specific parts of the battle display for the enemy
	db $73 ; unused ($73 is hardcoded in the routine that uses these bytes)
	db $74 ; lower-left corner tile of the HUD
	db $78 ; lower-right triangle tile of the HUD

PlaceHUDTiles: ; 3a930 (e:6930)
	ld [hl], $73
HealthBarUpdateDone:
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld a, [wHUDGraphicsTiles + 1] ; leftmost tile
	ld [hl], a
	ld a, 8
.loop
	add hl, de
	ld [hl], $76
	dec a
	jr nz, .loop
	add hl, de
	ld a, [wHUDGraphicsTiles + 2] ; rightmost tile
	ld [hl], a
	ret

SetupPlayerAndEnemyPokeballs: ; 3a948 (e:6948)
	call LoadPartyPokeballGfx
	ld hl, wPartyMons
	ld de, wPartyCount
	call SetupPokeballs
	ld hl, W_BASECOORDX
	ld a, $50
	ld [hli], a
	ld [hl], $40
	ld a, 8
	ld [wHUDPokeballGfxOffsetX], a
	ld hl, wOAMBuffer
	call WritePokeballOAMData
	ld hl, wEnemyMons
	ld de, wEnemyPartyCount
	call SetupPokeballs
	ld hl, W_BASECOORDX
	ld a, $50
	ld [hli], a
	ld [hl], $68
	ld hl, wOAMBuffer + $18
	jp WritePokeballOAMData

; four tiles: pokeball, black pokeball (status ailment), crossed out pokeball (faited) and pokeball slot (no mon)
PokeballTileGraphics:: ; 3a97e (e:697e)
	INCBIN "gfx/pokeball.2bpp"
