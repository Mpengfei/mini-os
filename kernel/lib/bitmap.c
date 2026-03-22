#include <kernel/lib/bitmap.h>

#define BITS_PER_WORD (sizeof(unsigned long) * 8U)

void bitmap_set_bit(unsigned long *bitmap, size_t bit)
{
	bitmap[bit / BITS_PER_WORD] |= (1UL << (bit % BITS_PER_WORD));
}

void bitmap_clear_bit(unsigned long *bitmap, size_t bit)
{
	bitmap[bit / BITS_PER_WORD] &= ~(1UL << (bit % BITS_PER_WORD));
}

bool bitmap_test_bit(const unsigned long *bitmap, size_t bit)
{
	return (bitmap[bit / BITS_PER_WORD] & (1UL << (bit % BITS_PER_WORD))) != 0UL;
}