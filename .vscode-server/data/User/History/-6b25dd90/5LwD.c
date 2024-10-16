#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// Possible states of a thread:
#define FREE        0x0
#define RUNNING     0x1
#define RUNNABLE    0x2

#define STACK_SIZE  8192
#define MAX_THREAD  4

struct context {
  uint64 ra;
  uint64 sp;
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

struct thread {
  struct context context;  // Register context
  char       stack[STACK_SIZE]; // Thread stack
  int        state; // FREE, RUNNING, RUNNABLE
  int        id; // Thread ID for FCFS
};

struct thread all_thread[MAX_THREAD]; // PCB table
struct thread *current_thread;
int next_thread_id = 0; // 用于分配线程 ID

extern void thread_switch(uint64, uint64);

// Initialize threads
void thread_init(void) {
  current_thread = &all_thread[0];
  current_thread->state = RUNNING;
  current_thread->id = next_thread_id++; // Assign ID to the main thread
}

// FCFS thread scheduling
void thread_schedule(void) {
  struct thread *next_thread = 0;

  // Find the first runnable thread in the order of arrival
  for (int i = 0; i < MAX_THREAD; i++) {
    if (all_thread[i].state == RUNNABLE) {
      next_thread = &all_thread[i];
      break; // FCFS: choose the first runnable thread
    }
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
    exit(-1);
  }

  if (current_thread != next_thread) {
    next_thread->state = RUNNING;
    struct thread *prev_thread = current_thread;
    current_thread = next_thread;

    // Context switch
    thread_switch((uint64)prev_thread, (uint64)current_thread);
  }
}

// Create a thread
void thread_create(void (*func)()) {
  struct thread *t;
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  
  if (t == all_thread + MAX_THREAD) {
    printf("thread_create: no available threads\n");
    return; // No available threads
  }

  t->state = RUNNABLE;
  t->id = next_thread_id++; // Assign ID to the new thread
  t->context.sp = (uint64)((char*)&t->stack + STACK_SIZE);
  t->context.ra = (uint64)func;
}

// Yield the current thread
void thread_yield(void) {
  current_thread->state = RUNNABLE;
  thread_schedule();
}

void thread_a(void) {
  printf("thread_a started\n");
  for (int i = 0; i < 100; i++) {
    printf("thread_a %d\n", i);
  }
  current_thread->state = FREE;
  thread_schedule();
}

void thread_b(void) {
  printf("thread_b started\n");
  for (int i = 0; i < 100; i++) {
    printf("thread_b %d\n", i);
  }
  current_thread->state = FREE;
  thread_schedule();
}

void thread_c(void) {
  printf("thread_c started\n");
  for (int i = 0; i < 100; i++) {
    printf("thread_c %d\n", i);
  }
  current_thread->state = FREE;
  thread_schedule();
}

int main(int argc, char *argv[]) {
  thread_init();
  thread_create(thread_a);
  thread_create(thread_b);
  thread_create(thread_c);
  thread_schedule();
  exit(0);
}
