.686
.MODEL FLAT, C
.CODE

my_copy_x86 PROC C dst:dword, src:dword, len:dword
	push esi
	push edi

	mov esi, src
	mov edi, dst
	mov ecx, len

	cmp ecx, 0
	je done

	cmp esi, edi
	ja forward

	add esi, ecx
	dec esi

	add edi, ecx
	dec edi

	std 
	rep movsb
	cld
	jmp done

	forward:
		cld
		rep movsb

	done:
		pop edi
		pop esi
		ret
my_copy_x86 ENDP
END