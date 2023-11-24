; 10 SYS (49152)
*= $0801
        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $34, $39, $31, $35, $32, $29, $00, $00, $00

v       = 53248 ; $d000, location of VIC chip in memory
SP0VAL  = $0340

*= $c000
        ; Setting background and border color
        lda #$00 ; Color black value
        sta $d020 ; Border color
        sta $d021 ; Background color

        ; Clearing the screen
        lda #147
        jsr $ffd2

        ; Sprite (definition) pointers are located in screen memory

        lda #13 ; Setting sprite pointer to 13
        sta 2040 ; Storing the sprite pointer to 2040

        lda #1
        sta v+21 ; Sprite enable register
        lda #2
        sta v+39 ; Sprite 0 color register

        ldx #0
build   lda DATA,x
        sta SP0VAL,x
        inx
        cpx #63
        bne build

forever
        lda #$ff
        cmp $d012 ; Compare raster counter
        bne forever ; If not equal, going back to forever

up      lda 56320 ; Joystick port
        and #1
        bne down
        dec spry
down    lda 56320 ; Joystick port
        and #2
        bne left
        inc spry
left    lda 56320 ; Joystick port
        and #4
        bne right
        dec sprx
        lda sprx
        cmp #$ff ; If wrapped
        dec sprx+1
right   lda 56320 ; Joystick port
        and #8
        bne button
        inc sprx
        bne button
        inc sprx+1
button  lda 56320
        and #16
        bne done
        inc $d020 ; Border color
done
        lda sprx
        sta v

        lda spry
        sta v+1

        jmp forever

DATA    BYTE $00, $7E, $00, $00, $FF, $00, $00, $FF, $00, $00, $FF, $00, $00, $FF, $00, $00, $FF, $00, $00, $FF, $00
        BYTE $0E, $7E, $E0, $0F, $BD, $F0, $3F, $FF, $F8, $38, $FE, $3C, $78, $3C, $1E, $78, $3C, $1E, $78, $3C, $1E
        BYTE $38, $7C, $1C, $00, $EE, $00, $00, $CE, $00, $01, $CF, $00, $01, $87, $00, $03, $83, $80, $0F, $03, $F0
        BYTE 0
sprx    BYTE 100,0
spry    BYTE 100