.CODE
my_len_x64 PROC
    mov rdi, rcx        
    mov rbx, rdi        
    
    xor al, al          
    mov rcx, -1         
    
    cld                 
    repne scasb         
    
    sub rdi, rbx       
    dec rdi            
    mov rax, rdi     
    ret
my_len_x64 ENDP
END