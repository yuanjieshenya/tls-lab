#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

/* Possible states of a thread: */
#define FREE        0x0
#define RUNNING     0x1
#define RUNNABLE    0x2

#define STACK_SIZE  8192
#define MAX_THREAD  7

//定义一个存寄存器的结构
struct context{
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

//修改一下PCB表的结构，这样后续代码能更清晰，汇编代码.S也可以写得足够简洁
struct thread {
  struct context context;          //存寄存器的结构
  char       stack[STACK_SIZE]; /* the thread's stack */
  int        state;             /* FREE, RUNNING, RUNNABLE */
  int priority;  // Add priority field
};
struct thread all_thread[MAX_THREAD];//PCB表
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
  current_thread->state = RUNNING;
}

void 
thread_schedule(void)
{
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  int highest_priority = -1;
  
  for(int i = 0; i < MAX_THREAD; i++){
    t = &all_thread[i];
    if (t->state == RUNNABLE && t->priority > highest_priority) {
        highest_priority = t->priority;
        next_thread = t;
    }
  }
  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
    exit(-1);
  }

  if (current_thread != next_thread) {         /* switch threads?  */
    next_thread->state = RUNNING;
    t = current_thread;
    current_thread = next_thread;
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
     thread_switch((uint64)t, (uint64)current_thread);
  } else
    next_thread = 0;
}

void 
thread_create(void (*func)(), int priority)
{
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  // YOUR CODE HERE
  t->state = RUNNABLE;
  t->priority = priority;
  t->context.sp = (uint64)((char*)&t->stack + STACK_SIZE);//sp在栈顶
  t->context.ra = (uint64)func;
}


void 
thread_yield(void)
{
  current_thread->state = RUNNABLE;
  thread_schedule();
}

volatile int a_started, b_started, c_started, d_started, e_started, f_started;
volatile int a_n, b_n, c_n, d_n, e_n, f_n;

void 
thread_a(void)
{
  int i;
  printf("thread_a started\n");
  a_started = 1;
  //等待其他进程启动
  for (i = 0; i < 100; i++) {
    printf("thread_a %d\n", i);
    a_n += 1;
  }
  printf("thread_a: exit after %d\n", a_n);

  current_thread->state = FREE;
  thread_schedule();
}

void 
thread_b(void)
{
  int i;
  printf("thread_b started\n");
  b_started = 1;
  for (i = 0; i < 100; i++) {
    printf("thread_b %d\n", i);
    b_n += 1;
  }
  printf("thread_b: exit after %d\n", b_n);

  current_thread->state = FREE;
  thread_schedule();
}

void 
thread_c(void)
{
  int i;
  printf("thread_c started\n");
  c_started = 1;
  for (i = 0; i < 100; i++) {
    printf("thread_c %d\n", i);
    c_n += 1;
  }
  printf("thread_c: exit after %d\n", c_n);

  current_thread->state = FREE;
  thread_schedule();
}

void thread_d(void) {
    int i;
    printf("thread_d started\n");
    d_started = 1;
    for (i = 0; i < 100; i++) {
        printf("thread_d %d\n", i);
        d_n += 1;
    }
    printf("thread_d: exit after %d\n", d_n);
    current_thread->state = FREE; // 设置状态为 FREE
    thread_schedule(); // 调度
}

void thread_e(void) {
    int i;
    printf("thread_e started\n");
    e_started = 1;
    for (i = 0; i < 100; i++) {
        printf("thread_e %d\n", i);
        e_n += 1;
    }
    printf("thread_e: exit after %d\n", e_n);
    current_thread->state = FREE; // 设置状态为 FREE
    thread_schedule(); // 调度
}

void thread_f(void) {
    int i;
    printf("thread_f started\n");
    f_started = 1;
    for (i = 0; i < 100; i++) {
        printf("thread_f %d\n", i);
        f_n += 1;
    }
    printf("thread_f: exit after %d\n", f_n);
    current_thread->state = FREE; // 设置状态为 FREE
    thread_schedule(); // 调度
}

int 
main(int argc, char *argv[]) 
{
  a_started = b_started = c_started = 0;
  a_n = b_n = c_n = 0;
  thread_init();
  thread_create(thread_a,1);
  thread_create(thread_b,2);
  thread_create(thread_c,3);
  thread_schedule();
  thread_create(thread_d, 4);
  thread_create(thread_e, 5);
  thread_create(thread_f, 6);
  while (1) {
        int all_done = 1; // 假设所有线程都已完成
        for (int i = 0; i < MAX_THREAD; i++) {
            if (all_thread[i].state != FREE) {
                all_done = 0; // 有线程未完成
                break;
            }
        }
        if (all_done) {
            break; // 如果所有线程都已完成，退出循环
        }
        thread_schedule(); // 调度剩余线程
    }
  exit(0);
}
