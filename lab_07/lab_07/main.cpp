#include <iostream>
#include <string>

#define CYAN    "\033[36m"
#define RESET   "\033[0m"

void input_string(char* buffer, size_t size);
void demo_overlap(void);

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
    char user_str[100];
    input_string(user_str, sizeof(user_str));

    std::cout << CYAN << "Length: " << my_strlen(user_str) << RESET << std::endl;

    char buffer[120] = { 0 };
    my_copy(buffer, user_str, my_strlen(user_str));

    std::cout << CYAN << "Copied string: " << buffer << RESET << std::endl;

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

void input_string(char* buffer, size_t size)
{
    std::cout << CYAN << "Enter your string: " << RESET;
    std::cin.getline(buffer, size);
}

void demo_overlap(void)
{
    char buffer[20] = "0123456789";

    std::cout << "\n--- Overlap Demo ---" << std::endl;
    std::cout << "Original: " << CYAN << buffer << RESET << std::endl;

    my_copy(buffer + 2, buffer, 5);

    std::cout << "After copy (buffer+2, buffer, 5): " << CYAN << buffer << RESET << std::endl;
}