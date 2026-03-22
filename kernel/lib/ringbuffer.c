#include <kernel/lib/ringbuffer.h>

void ringbuffer_init(struct ringbuffer *rb, uint8_t *storage, size_t capacity)
{
	rb->data = storage;
	rb->capacity = capacity;
	rb->head = 0U;
	rb->tail = 0U;
	rb->count = 0U;
}

bool ringbuffer_is_empty(const struct ringbuffer *rb)
{
	return rb->count == 0U;
}

bool ringbuffer_is_full(const struct ringbuffer *rb)
{
	return rb->count == rb->capacity;
}

bool ringbuffer_push(struct ringbuffer *rb, uint8_t value)
{
	if (ringbuffer_is_full(rb)) {
		return false;
	}

	rb->data[rb->head] = value;
	rb->head = (rb->head + 1U) % rb->capacity;
	rb->count++;
	return true;
}

bool ringbuffer_pop(struct ringbuffer *rb, uint8_t *value)
{
	if (ringbuffer_is_empty(rb)) {
		return false;
	}

	*value = rb->data[rb->tail];
	rb->tail = (rb->tail + 1U) % rb->capacity;
	rb->count--;
	return true;
}