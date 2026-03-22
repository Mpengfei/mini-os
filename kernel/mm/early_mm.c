#include <stddef.h>
#include <stdint.h>

#include <kernel/early_mm.h>

extern unsigned char __heap_start[];
extern unsigned char __heap_end[];

static struct early_mm_region boot_heap_region;
static const char *last_allocation_tag;
static uintptr_t last_allocation_base;
static size_t last_allocation_size;

static uintptr_t align_up_uintptr(uintptr_t value, size_t align)
{
	uintptr_t mask;

	if (align <= 1U) {
		return value;
	}

	mask = (uintptr_t)align - 1U;
	return (value + mask) & ~mask;
}

static void zero_memory(unsigned char *memory, size_t size)
{
	size_t i;

	for (i = 0U; i < size; ++i) {
		memory[i] = 0U;
	}
}

static void early_mm_region_init(struct early_mm_region *region,
				     const char *name,
				     uintptr_t start,
				     uintptr_t end)
{
	if (region == (struct early_mm_region *)0) {
		return;
	}

	region->name = name;
	region->start = start;
	region->current = start;
	region->end = end;
	region->allocation_count = 0U;
	region->peak_used_bytes = 0U;
}

static void *early_mm_region_alloc(struct early_mm_region *region,
				   size_t size,
				   size_t align,
				   const char *tag)
{
	uintptr_t current;
	uintptr_t next;
	size_t used_bytes;
	unsigned char *memory;

	if ((region == (struct early_mm_region *)0) || (size == 0U)) {
		return (void *)0;
	}

	current = align_up_uintptr(region->current, align);
	next = current + (uintptr_t)size;
	if ((next < current) || (next > region->end)) {
		return (void *)0;
	}

	memory = (unsigned char *)current;
	zero_memory(memory, size);

	region->current = next;
	region->allocation_count++;
	used_bytes = (size_t)(region->current - region->start);
	if (used_bytes > region->peak_used_bytes) {
		region->peak_used_bytes = used_bytes;
	}

	last_allocation_tag = tag;
	last_allocation_base = current;
	last_allocation_size = size;
	return memory;
}

void early_mm_init(void)
{
	early_mm_region_init(&boot_heap_region, "boot-heap",
			     (uintptr_t)__heap_start,
			     (uintptr_t)__heap_end);
	last_allocation_tag = (const char *)0;
	last_allocation_base = 0U;
	last_allocation_size = 0U;
}

void *early_alloc(size_t size, size_t align)
{
	return early_mm_alloc(size, align, "legacy");
}

void *early_mm_alloc(size_t size, size_t align, const char *tag)
{
	return early_mm_region_alloc(&boot_heap_region, size, align, tag);
}

void *early_mm_alloc_pages(size_t page_count, const char *tag)
{
	if (page_count == 0U) {
		return (void *)0;
	}

	return early_mm_alloc(page_count * EARLY_MM_PAGE_SIZE,
			      EARLY_MM_PAGE_SIZE,
			      tag);
}

const struct early_mm_region *early_mm_default_region(void)
{
	return &boot_heap_region;
}

void early_mm_get_stats(struct early_allocator_stats *stats)
{
	if (stats == (struct early_allocator_stats *)0) {
		return;
	}

	stats->name = boot_heap_region.name;
	stats->start = boot_heap_region.start;
	stats->current = boot_heap_region.current;
	stats->end = boot_heap_region.end;
	stats->total_bytes = (size_t)(boot_heap_region.end - boot_heap_region.start);
	stats->used_bytes = (size_t)(boot_heap_region.current - boot_heap_region.start);
	stats->free_bytes = (size_t)(boot_heap_region.end - boot_heap_region.current);
	stats->peak_used_bytes = boot_heap_region.peak_used_bytes;
	stats->allocation_count = boot_heap_region.allocation_count;
	stats->page_size = EARLY_MM_PAGE_SIZE;

	(void)last_allocation_tag;
	(void)last_allocation_base;
	(void)last_allocation_size;
}