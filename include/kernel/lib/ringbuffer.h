#ifndef KERNEL_LIB_RINGBUFFER_H
#define KERNEL_LIB_RINGBUFFER_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

struct ringbuffer {
	uint8_t *data;
	size_t capacity;
	size_t head;
	size_t tail;
	size_t count;
};

void ringbuffer_init(struct ringbuffer *rb, uint8_t *storage, size_t capacity);
bool ringbuffer_is_empty(const struct ringbuffer *rb);
bool ringbuffer_is_full(const struct ringbuffer *rb);
bool ringbuffer_push(struct ringbuffer *rb, uint8_t value);
bool ringbuffer_pop(struct ringbuffer *rb, uint8_t *value);

#endif /* KERNEL_LIB_RINGBUFFER_H */