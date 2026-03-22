#ifndef KERNEL_LIB_BITMAP_H
#define KERNEL_LIB_BITMAP_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

void bitmap_set_bit(unsigned long *bitmap, size_t bit);
void bitmap_clear_bit(unsigned long *bitmap, size_t bit);
bool bitmap_test_bit(const unsigned long *bitmap, size_t bit);

#endif /* KERNEL_LIB_BITMAP_H */