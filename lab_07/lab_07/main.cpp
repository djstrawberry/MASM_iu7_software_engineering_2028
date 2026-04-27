#include <iostream>

static size_t my_strlen(const char* str);
extern "C" void my_copy(char* dst, const char* src, size_t n);

int main(void)
{
	const char* str = "Hui pipisa";
	std::cout << my_strlen(str) << std::endl;

	char buffer[20] = "0123456789";
	my_copy(buffer + 2, buffer, 5);
	std::cout << "After copy:  " << buffer << std::endl;

	return 0;
}

static size_t my_strlen(const char* str)
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