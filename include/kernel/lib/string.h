#ifndef KERNEL_LIB_STRING_H
#define KERNEL_LIB_STRING_H

#include <stddef.h>

size_t mini_os_strlen(const char *str);
int mini_os_strcmp(const char *lhs, const char *rhs);

#endif /* KERNEL_LIB_STRING_H */