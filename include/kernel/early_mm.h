#ifndef KERNEL_EARLY_MM_H
#define KERNEL_EARLY_MM_H

#include <stddef.h>
#include <stdint.h>

#define EARLY_MM_PAGE_SIZE 4096U

struct early_mm_region {
	const char *name;
	uintptr_t start;
	uintptr_t current;
	uintptr_t end;
	size_t allocation_count;
	size_t peak_used_bytes;
};

struct early_allocator_stats {
	const char *name;
	uintptr_t start;
	uintptr_t current;
	uintptr_t end;
	size_t total_bytes;
	size_t used_bytes;
	size_t free_bytes;
	size_t peak_used_bytes;
	size_t allocation_count;
	size_t page_size;
};

void early_mm_init(void);
void *early_alloc(size_t size, size_t align);
void *early_mm_alloc(size_t size, size_t align, const char *tag);
void *early_mm_alloc_pages(size_t page_count, const char *tag);
const struct early_mm_region *early_mm_default_region(void);
void early_mm_get_stats(struct early_allocator_stats *stats);

#endif /* KERNEL_EARLY_MM_H */