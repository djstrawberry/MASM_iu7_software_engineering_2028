#include <iostream>

#ifndef _M_X64
static size_t my_strlen_x86(const char* str);
#endif

extern "C" {
    void my_copy_x86(char* dst, const char* src, size_t n);
    void my_copy_x64(char* dst, const char* src, size_t n);
    size_t my_len_x64(const char* s);
}

#ifdef _M_X64
auto my_copy = my_copy_x64;
auto my_strlen = my_len_x64;
#else
auto my_copy = my_copy_x86;
auto my_strlen = my_strlen_x86;
#endif

int main(void)
{
    const char* str = "Hui pipisa";
    std::cout << my_strlen(str) << std::endl;

    char buffer[20] = "0123456789";
    my_copy(buffer + 2, buffer, 5);
    std::cout << "After copy:  " << buffer << std::endl;

    return 0;
}

#ifndef _M_X64
static size_t my_strlen_x86(const char* str)
{
    size_t len = 0;

    __asm
    {
        mov edi, str
        mov ebx, edi

        mov al, 0
        mov ecx, -1

        cld
        repne scasb

        sub edi, ebx
        dec edi
        mov len, edi
    }

    return len;
}
#endif