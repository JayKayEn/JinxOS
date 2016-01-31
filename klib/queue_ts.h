#ifndef QUEUE_TS_H_
#define _QUEUE_TS_H_

struct queue_ts;

struct queue_ts* queue_ts_create(void);
int queue_ts_push(struct queue_ts*, void*);
void* queue_ts_pop(struct queue_ts*);
void* queue_ts_pop_blocking(struct queue_ts*);
int queue_ts_isempty(struct queue_ts*);
unsigned int queue_ts_getsize(struct queue_ts*);
void queue_ts_destroy(struct queue_ts*);
void queue_ts_assertvalid(struct queue_ts*);

#endif // _QUEUE_TS_H_
