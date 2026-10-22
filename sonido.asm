;===========================================================================
;===  GALAX JON - sonido.asm                                              ===
;===  Efectos de sonido (BEEPER de la ROM)                                ===
;===========================================================================

;----------------------------------------------------------------
;---		     S U B  -  S O N I D O S                  ---
;---                                                          ---
;--- ( Los sonidos son originarios del Juego PoromPong...     ---
;---   ... de Juan Antonio Rubio, canal RETROPARLA )          ---
;---                                                          ---
;---  A = 1 Pala, 2 Rebote, 3 Variable (soni_disp), 4 Menus   ---
;---  Conserva todos los registros                            ---
;----------------------------------------------------------------
sonido:
	push	de
	push	hl

	dec	a
	jr	z,sonido_pala
	dec	a
	jr	z,sonido_rebote
	dec	a
	jr	z,sonido_vidamenos

sonido_pulsamenus:
	ld	hl,s_4
	ld	de,s4_dura
	jr	emitir_sonido

sonido_pala:
	ld	hl,s_2
	ld	de,s2_dura/$05
	jr	emitir_sonido

sonido_rebote:
	ld	hl,s_3
	ld	de,s3_dura/$05
	jr	emitir_sonido

sonido_vidamenos:
	ld	hl,(soni_disp)
	ld	de,s1_dura/$10

emitir_sonido:
	push	af
	push	bc
	push	ix
	call	BEEPER			; Rutina ROM
	pop	ix
	pop	bc
	pop	af
	pop	hl
	pop	de
	ret
