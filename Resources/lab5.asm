; DCS_ASM
.data
	.cte SP 0x0
.enddata
.code
	addc R15, #0x2 ; R15 = 2
	addc r14 , #0x1; R14 = 1
	
	addc R5, #0x1
	SUBC R6, #0x2
	ADD R6, R5
	SUB R5, R6
	SHLA R5, R15 ; Replaced
	NOT R6
	ADDC R6, #0x3
	cpy r7, r5
	mul r7 r6
	swap r7, r5
	div r7, r5
	cpy r8, r7
	xor	r8, r5
	rtrc r5, r15
	;jmpc next instruction??
	st R5, M[R0, 0x555]
	rtlc r5, r14
	ld r5, M[r0, 0x555]
	out R5, 0x0 ;SP
	in R8, 0x0 ; SP
.endcode