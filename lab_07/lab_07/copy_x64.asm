.CODE
my_copy_x64 PROC
	mov rsi, rdx ; src
	mov rdi, rcx ; dst
	mov rcx, r8  ; len

	jrcxz done

	cmp rsi, rdi
	ja forward

	add rsi, rcx
	dec rsi

	add rdi, rcx
	dec rdi

	std
	rep movsb
	cld
	jmp done

	forward:
		cld
		rep movsb

	done:
		ret
my_copy_x64 ENDP
END