SetDefaultNames: ; 60ca (1:60ca)
	ld a, [$d358]
	push af
	ld a, [W_OPTIONS] ; $d355
	push af
	ld a, [$d732]
	push af
	ld hl, W_PLAYERNAME ; $d158
	ld bc, $d8a
	xor a
	call FillMemory
	ld hl, wSpriteStateData1
	ld bc, $200
	xor a
	call FillMemory
	pop af
	ld [$d732], a
	pop af
	ld [W_OPTIONS], a ; $d355
	pop af
	ld [$d358], a
	ld a, [$d08a]
	and a
	call z, Func_5bff
	ld hl, NintenText
	ld de, W_PLAYERNAME ; $d158
	ld bc, $b
	call CopyData
	ld hl, SonyText
	ld de, W_RIVALNAME ; $d34a
	ld bc, $b
	jp CopyData

OakSpeech: ; 6115 (1:6115)
	ld a,$FF
	call PlaySound ; stop music
	ld a, BANK(Music_Routes2) ; bank of song
	ld c,a
	ld a, MUSIC_ROUTES2 ; song #
	call PlayMusic  ; plays music
	call ClearScreen
	call LoadTextBoxTilePatterns
	call SetDefaultNames
	ld a,$18
	call Predef ; indirect jump to InitializePlayerData
	ld hl,$D53A
	ld a,POTION
	ld [$CF91],a
	ld a,1
	ld [$CF96],a
	call AddItemToInventory  ; give one potion
	ld a,[$D07C]
	ld [$D71A],a
	call Func_62ce
	xor a
	ld [$FFD7],a
	ld a, PAL_OAK
	call GotPaletteID
	ld de,ProfOakPic
	ld bc, (Bank(ProfOakPic) << 8) | $00
	call IntroPredef3B   ; displays Oak pic?
	call FadeInIntroPic
	ld hl,OakSpeechText1
	call PrintText      ; prints text box
	call GBFadeOut2
	call ClearScreen
	call GetNidoPalID
	ld a,MEW
	ld [$D0B5],a    ; pic displayed is stored at this location
	ld [$CF91],a
	call GetMonHeader      ; this is also related to the pic
	FuncCoord 6, 4 ; $c3f6
	ld hl,Coord     ; position on tilemap the pic is displayed
	call LoadFlippedFrontSpriteByMonIndex      ; displays pic?
	call MovePicLeft
	ld hl,OakSpeechText2
	call PrintText      ; Prints text box
	call GBFadeOut2
	call GetRedPalID
	ld de,RedPicFront
	ld bc,(Bank(RedPicFront) << 8) | $00
	call IntroPredef3B      ; displays player pic?
	call MovePicLeft
	ld hl,IntroducePlayerText
	call PrintText
	call LoadDefaultNamesPlayer ; brings up NewName/Red/etc menu
	call GBFadeOut2
	call GetRivalPalID
	ld de,Rival1Pic
	ld bc,(Bank(Rival1Pic) << 8) | $00
	call IntroPredef3B ; displays rival pic
	call FadeInIntroPic
	ld hl,IntroduceRivalText
	call PrintText
	;call Func_69a4

Func_61bc: ; 61bc (1:61bc)
	call GBFadeOut2
	call GetRedPalID
	ld de,RedPicFront
	ld bc,(Bank(RedPicFront) << 8) | $00
	call IntroPredef3B
	call GBFadeIn2
	ld a,[$D72D]
	and a
	jr nz,.next
	ld hl,OakSpeechText3
	call PrintText
.next
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,(SFX_02_48 - SFX_Headers_02) / 3
	call PlaySound
	pop af
	ld [H_LOADEDROMBANK],a
	ld [$2000],a
	ld c,4
	call DelayFrames
	ld de,RedSprite ; $4180
	ld hl,$8000
	ld bc,(BANK(RedSprite) << 8) | $0C
	call CopyVideoData
	ld de,ShrinkPic1
	ld bc,(BANK(ShrinkPic1) << 8) | $00
	call IntroPredef3B
	ld c,4
	call DelayFrames
	ld de,ShrinkPic2
	ld bc,(BANK(ShrinkPic2) << 8) | $00
	call IntroPredef3B
	call ResetPlayerSpriteData
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,2
	ld [$C0EF],a
	ld [$C0F0],a
	ld a,$A
	ld [wMusicHeaderPointer],a
	ld a,$FF
	ld [$C0EE],a
	call PlaySound ; stop music
	pop af
	ld [H_LOADEDROMBANK],a
	ld [$2000],a
	ld c,$14
	call DelayFrames
	FuncCoord 6, 5 ; $c40a
	ld hl,Coord
	ld b,7
	ld c,7
	call ClearScreenArea
	call LoadTextBoxTilePatterns
	ld a,1
	ld [$CFCB],a
	ld c,$32
	call DelayFrames
	call GBFadeOut2
	jp ClearScreen
OakSpeechText1: ; 6253 (1:6253)
	TX_FAR _OakSpeechText1
	db "@"
OakSpeechText2: ; 6258 (1:6258)
	TX_FAR _OakSpeechText2A
	db $14
	TX_FAR _OakSpeechText2B
	db "@"
IntroducePlayerText: ; 6262 (1:6262)
	TX_FAR _IntroducePlayerText
	db "@"
IntroduceRivalText: ; 6267 (1:6267)
	TX_FAR _IntroduceRivalText
	db "@"
OakSpeechText3: ; 626c (1:626c)
	TX_FAR _OakSpeechText3
	db "@"

FadeInIntroPic: ; 6271 (1:6271)
	ld hl,IntroFadePalettes
	ld b,6
.next
	ld a,[hli]
	ld [rBGP],a
	ld c,10
	call DelayFrames
	dec b
	jr nz,.next
	ret

IntroFadePalettes: ; 6282 (1:6282)
	db %01010100
	db %10101000
	db %11111100
	db %11111000
	db %11110100
	db %11100100

MovePicLeft: ; 6288 (1:6288)
	ld a,119
	ld [$FF4B],a
	call DelayFrame

	ld a,$E4
	ld [rBGP],a
.next
	call DelayFrame
	ld a,[$FF4B]
	sub 8
	cp $FF
	ret z
	ld [$FF4B],a
	jr .next

Predef3B: ; 62a1 (1:62a1)
	call GetPredefRegisters
IntroPredef3B: ; 62a4 (1:62a4)
; bank of sprite given in b
	push bc
	ld a,b
	call UncompressSpriteFromDE
	ld hl,S_SPRITEBUFFER1
	ld de,$A000
	ld bc,$0310
	call CopyData
	ld de,$9000
	call InterlaceMergeSpriteBuffers
	pop bc
	ld a,c
	and a
	FuncCoord 15, 1 ; $c3c3
	ld hl,Coord
	jr nz,.next
	FuncCoord 6, 4 ; $c3f6
	ld hl,Coord
.next
	xor a
	ld [$FFE1],a
	ld a,1
	jp Predef
