;===========================================================================
;===  GALAX JON - musica.asm                                             ===
;===  Melodia espacial del menu principal (BEEPER de la ROM)             ===
;===========================================================================

;---------------------------------------------------------------------------
;---  Como funciona:                                                     ---
;---  El menu llama a 'tocar_melodia' una vez por vuelta (~2 frames).    ---
;---  Cada nota suena solo 30 ms (staccato) y luego espera N vueltas  ---
;---  en silencio, asi las estrellas siguen moviendose mientras suena.   ---
;---  Cuando suena una nota, el menu hace 1 HALT en vez de 2 para que    ---
;---  el ritmo de la animacion sea el mismo.                             ---
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;---                SUB - I N I C I A   M E L O D I A                    ---
;---------------------------------------------------------------------------
inicia_melodia:
	ld	hl,melodia
	ld	(mus_pos),hl
	xor	a
	ld	(mus_espera),a
	ret

;---------------------------------------------------------------------------
;---                SUB - T O C A R   M E L O D I A                      ---
;---                                                                     ---
;---  Sale con Carry = 1 si ha sonado una nota, Carry = 0 si no          ---
;---  (Altera AF,BC,DE,HL)                                               ---
;---------------------------------------------------------------------------
tocar_melodia:
	ld	a,(mus_espera)
	or	a
	jr	z,mus_nueva_nota
	dec	a			; Aun esperando a la siguiente nota
	ld	(mus_espera),a
	and	a			; Carry = 0
	ret

mus_nueva_nota:
	ld	hl,(mus_pos)
	ld	a,(hl)			; Vueltas que dura la nota
	or	a
	jr	nz,mus_lee_nota
	ld	hl,melodia		; 0 = Fin: vuelve a empezar
	ld	a,(hl)

mus_lee_nota:
	dec	a
	ld	(mus_espera),a
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)			; DE = Duracion (frecuencia * segundos)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)			; BC = Nota (437500 / frecuencia - 30)
	inc	hl
	ld	(mus_pos),hl

	ld	a,d
	or	e
	ret	z			; Silencio (Carry = 0)

	ld	h,b
	ld	l,c
	push	ix
	call	BEEPER			; Rutina ROM
	pop	ix
	scf				; Carry = 1
	ret

;---------------------------------------------------------------------------
;---  Formato: defb vueltas  /  defw duracion, nota   (0,0 = silencio)   ---
;---  Am - F - G - E (x2) y unos destellos agudos                        ---
;---------------------------------------------------------------------------
melodia:
	defb	2
	defw	13,964		; A4
	defb	2
	defw	20,633		; E5
	defb	2
	defw	26,467		; A5
	defb	2
	defw	31,388		; C6
	defb	2
	defw	26,467		; A5
	defb	2
	defw	20,633		; E5
	defb	2
	defw	10,1223		; F4
	defb	2
	defw	16,806		; C5
	defb	2
	defw	21,596		; F5
	defb	2
	defw	26,467		; A5
	defb	2
	defw	21,596		; F5
	defb	2
	defw	16,806		; C5
	defb	2
	defw	12,1086		; G4
	defb	2
	defw	18,715		; D5
	defb	2
	defw	24,528		; G5
	defb	2
	defw	30,413		; B5
	defb	2
	defw	24,528		; G5
	defb	2
	defw	18,715		; D5
	defb	2
	defw	10,1297		; E4
	defb	2
	defw	15,856		; B4
	defb	2
	defw	20,633		; E5
	defb	2
	defw	25,497		; G#5
	defb	3
	defw	30,413		; B5
	defb	5
	defw	0,0		; silencio
	defb	2
	defw	13,964		; A4
	defb	2
	defw	20,633		; E5
	defb	2
	defw	26,467		; A5
	defb	2
	defw	31,388		; C6
	defb	2
	defw	26,467		; A5
	defb	2
	defw	20,633		; E5
	defb	2
	defw	10,1223		; F4
	defb	2
	defw	16,806		; C5
	defb	2
	defw	21,596		; F5
	defb	2
	defw	26,467		; A5
	defb	2
	defw	21,596		; F5
	defb	2
	defw	16,806		; C5
	defb	2
	defw	12,1086		; G4
	defb	2
	defw	18,715		; D5
	defb	2
	defw	24,528		; G5
	defb	2
	defw	30,413		; B5
	defb	2
	defw	24,528		; G5
	defb	2
	defw	18,715		; D5
	defb	2
	defw	10,1297		; E4
	defb	2
	defw	15,856		; B4
	defb	2
	defw	20,633		; E5
	defb	2
	defw	25,497		; G#5
	defb	3
	defw	30,413		; B5
	defb	5
	defw	0,0		; silencio
	defb	4
	defw	40,302		; E6
	defb	4
	defw	31,388		; C6
	defb	4
	defw	26,467		; A5
	defb	4
	defw	30,413		; B5
	defb	3
	defw	31,388		; C6
	defb	3
	defw	35,342		; D6
	defb	6
	defw	40,302		; E6
	defb	4
	defw	0,0		; silencio
	defb	3
	defw	26,467		; A5
	defb	3
	defw	40,302		; E6
	defb	3
	defw	26,467		; A5
	defb	8
	defw	20,633		; E5
	defb	14
	defw	0,0		; silencio
	defb	0			; Fin de la melodia
