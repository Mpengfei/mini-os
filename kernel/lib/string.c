#include <kernel/lib/string.h>

size_t mini_os_strlen(const char *str)
{
	size_t len = 0U;

	if (str == (const char *)0) {
		return 0U;
	}

	while (str[len] != '\0') {
		len++;
	}

	return len;
}

int mini_os_strcmp(const char *lhs, const char *rhs)
{
	while ((*lhs != '\0') && (*lhs == *rhs)) {
		lhs++;
		rhs++;
	}

	return (int)(unsigned char)*lhs - (int)(unsigned char)*rhs;
}