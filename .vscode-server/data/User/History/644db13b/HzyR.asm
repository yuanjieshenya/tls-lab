
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d2a78793          	addi	a5,a5,-726 # d30 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d0f73923          	sd	a5,-750(a4) # d20 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d0f72c23          	sw	a5,-744(a4) # 2d30 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:
{
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  26:	00001897          	auipc	a7,0x1
  2a:	cfa8b883          	ld	a7,-774(a7) # d20 <current_thread>
  2e:	6789                	lui	a5,0x2
  30:	0791                	addi	a5,a5,4 # 2004 <__global_pointer$+0xb03>
  32:	97c6                	add	a5,a5,a7
  34:	4711                	li	a4,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  36:	00009517          	auipc	a0,0x9
  3a:	d0a50513          	addi	a0,a0,-758 # 8d40 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  3e:	6609                	lui	a2,0x2
  40:	4589                	li	a1,2
      next_thread = t;
      break;
    }
    t = t + 1;
  42:	00460813          	addi	a6,a2,4 # 2004 <__global_pointer$+0xb03>
  46:	a809                	j	58 <thread_schedule+0x32>
    if(t->state == RUNNABLE) {
  48:	00c786b3          	add	a3,a5,a2
  4c:	4294                	lw	a3,0(a3)
  4e:	02b68d63          	beq	a3,a1,88 <thread_schedule+0x62>
    t = t + 1;
  52:	97c2                	add	a5,a5,a6
  for(int i = 0; i < MAX_THREAD; i++){
  54:	377d                	addiw	a4,a4,-1
  56:	cb01                	beqz	a4,66 <thread_schedule+0x40>
    if(t >= all_thread + MAX_THREAD)
  58:	fea7e8e3          	bltu	a5,a0,48 <thread_schedule+0x22>
      t = all_thread;
  5c:	00001797          	auipc	a5,0x1
  60:	cd478793          	addi	a5,a5,-812 # d30 <all_thread>
  64:	b7d5                	j	48 <thread_schedule+0x22>
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  6e:	00001517          	auipc	a0,0x1
  72:	b2250513          	addi	a0,a0,-1246 # b90 <malloc+0xe8>
  76:	00001097          	auipc	ra,0x1
  7a:	97a080e7          	jalr	-1670(ra) # 9f0 <printf>
    exit(-1);
  7e:	557d                	li	a0,-1
  80:	00000097          	auipc	ra,0x0
  84:	5ee080e7          	jalr	1518(ra) # 66e <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  88:	00f88b63          	beq	a7,a5,9e <thread_schedule+0x78>
    next_thread->state = RUNNING;
  8c:	6709                	lui	a4,0x2
  8e:	973e                	add	a4,a4,a5
  90:	4685                	li	a3,1
  92:	c314                	sw	a3,0(a4)
    t = current_thread;
    current_thread = next_thread;
  94:	00001717          	auipc	a4,0x1
  98:	c8f73623          	sd	a5,-884(a4) # d20 <current_thread>
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
  } else
    next_thread = 0;
}
  9c:	8082                	ret
  9e:	8082                	ret

00000000000000a0 <thread_create>:

void 
thread_create(void (*func)())
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  a6:	00001797          	auipc	a5,0x1
  aa:	c8a78793          	addi	a5,a5,-886 # d30 <all_thread>
    if (t->state == FREE) break;
  ae:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  b0:	00468593          	addi	a1,a3,4 # 2004 <__global_pointer$+0xb03>
  b4:	00009617          	auipc	a2,0x9
  b8:	c8c60613          	addi	a2,a2,-884 # 8d40 <base>
    if (t->state == FREE) break;
  bc:	00d78733          	add	a4,a5,a3
  c0:	4318                	lw	a4,0(a4)
  c2:	c701                	beqz	a4,ca <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c4:	97ae                	add	a5,a5,a1
  c6:	fec79be3          	bne	a5,a2,bc <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  ca:	6709                	lui	a4,0x2
  cc:	97ba                	add	a5,a5,a4
  ce:	4709                	li	a4,2
  d0:	c398                	sw	a4,0(a5)
  // YOUR CODE HERE
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <thread_yield>:

void 
thread_yield(void)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
  e0:	00001797          	auipc	a5,0x1
  e4:	c407b783          	ld	a5,-960(a5) # d20 <current_thread>
  e8:	6709                	lui	a4,0x2
  ea:	97ba                	add	a5,a5,a4
  ec:	4709                	li	a4,2
  ee:	c398                	sw	a4,0(a5)
  thread_schedule();
  f0:	00000097          	auipc	ra,0x0
  f4:	f36080e7          	jalr	-202(ra) # 26 <thread_schedule>
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 110:	00001517          	auipc	a0,0x1
 114:	aa850513          	addi	a0,a0,-1368 # bb8 <malloc+0x110>
 118:	00001097          	auipc	ra,0x1
 11c:	8d8080e7          	jalr	-1832(ra) # 9f0 <printf>
  a_started = 1;
 120:	4785                	li	a5,1
 122:	00001717          	auipc	a4,0x1
 126:	bef72d23          	sw	a5,-1030(a4) # d1c <a_started>
  while(b_started == 0 || c_started == 0)
 12a:	00001497          	auipc	s1,0x1
 12e:	bee48493          	addi	s1,s1,-1042 # d18 <b_started>
 132:	00001917          	auipc	s2,0x1
 136:	be290913          	addi	s2,s2,-1054 # d14 <c_started>
 13a:	a029                	j	144 <thread_a+0x44>
    thread_yield();
 13c:	00000097          	auipc	ra,0x0
 140:	f9c080e7          	jalr	-100(ra) # d8 <thread_yield>
  while(b_started == 0 || c_started == 0)
 144:	409c                	lw	a5,0(s1)
 146:	2781                	sext.w	a5,a5
 148:	dbf5                	beqz	a5,13c <thread_a+0x3c>
 14a:	00092783          	lw	a5,0(s2)
 14e:	2781                	sext.w	a5,a5
 150:	d7f5                	beqz	a5,13c <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 152:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 154:	00001a17          	auipc	s4,0x1
 158:	a7ca0a13          	addi	s4,s4,-1412 # bd0 <malloc+0x128>
    a_n += 1;
 15c:	00001917          	auipc	s2,0x1
 160:	bb490913          	addi	s2,s2,-1100 # d10 <a_n>
  for (i = 0; i < 100; i++) {
 164:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 168:	85a6                	mv	a1,s1
 16a:	8552                	mv	a0,s4
 16c:	00001097          	auipc	ra,0x1
 170:	884080e7          	jalr	-1916(ra) # 9f0 <printf>
    a_n += 1;
 174:	00092783          	lw	a5,0(s2)
 178:	2785                	addiw	a5,a5,1
 17a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 17e:	00000097          	auipc	ra,0x0
 182:	f5a080e7          	jalr	-166(ra) # d8 <thread_yield>
  for (i = 0; i < 100; i++) {
 186:	2485                	addiw	s1,s1,1
 188:	ff3490e3          	bne	s1,s3,168 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 18c:	00001597          	auipc	a1,0x1
 190:	b845a583          	lw	a1,-1148(a1) # d10 <a_n>
 194:	00001517          	auipc	a0,0x1
 198:	a4c50513          	addi	a0,a0,-1460 # be0 <malloc+0x138>
 19c:	00001097          	auipc	ra,0x1
 1a0:	854080e7          	jalr	-1964(ra) # 9f0 <printf>

  current_thread->state = FREE;
 1a4:	00001797          	auipc	a5,0x1
 1a8:	b7c7b783          	ld	a5,-1156(a5) # d20 <current_thread>
 1ac:	6709                	lui	a4,0x2
 1ae:	97ba                	add	a5,a5,a4
 1b0:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1b4:	00000097          	auipc	ra,0x0
 1b8:	e72080e7          	jalr	-398(ra) # 26 <thread_schedule>
}
 1bc:	70a2                	ld	ra,40(sp)
 1be:	7402                	ld	s0,32(sp)
 1c0:	64e2                	ld	s1,24(sp)
 1c2:	6942                	ld	s2,16(sp)
 1c4:	69a2                	ld	s3,8(sp)
 1c6:	6a02                	ld	s4,0(sp)
 1c8:	6145                	addi	sp,sp,48
 1ca:	8082                	ret

00000000000001cc <thread_b>:

void 
thread_b(void)
{
 1cc:	7179                	addi	sp,sp,-48
 1ce:	f406                	sd	ra,40(sp)
 1d0:	f022                	sd	s0,32(sp)
 1d2:	ec26                	sd	s1,24(sp)
 1d4:	e84a                	sd	s2,16(sp)
 1d6:	e44e                	sd	s3,8(sp)
 1d8:	e052                	sd	s4,0(sp)
 1da:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1dc:	00001517          	auipc	a0,0x1
 1e0:	a2450513          	addi	a0,a0,-1500 # c00 <malloc+0x158>
 1e4:	00001097          	auipc	ra,0x1
 1e8:	80c080e7          	jalr	-2036(ra) # 9f0 <printf>
  b_started = 1;
 1ec:	4785                	li	a5,1
 1ee:	00001717          	auipc	a4,0x1
 1f2:	b2f72523          	sw	a5,-1238(a4) # d18 <b_started>
  while(a_started == 0 || c_started == 0)
 1f6:	00001497          	auipc	s1,0x1
 1fa:	b2648493          	addi	s1,s1,-1242 # d1c <a_started>
 1fe:	00001917          	auipc	s2,0x1
 202:	b1690913          	addi	s2,s2,-1258 # d14 <c_started>
 206:	a029                	j	210 <thread_b+0x44>
    thread_yield();
 208:	00000097          	auipc	ra,0x0
 20c:	ed0080e7          	jalr	-304(ra) # d8 <thread_yield>
  while(a_started == 0 || c_started == 0)
 210:	409c                	lw	a5,0(s1)
 212:	2781                	sext.w	a5,a5
 214:	dbf5                	beqz	a5,208 <thread_b+0x3c>
 216:	00092783          	lw	a5,0(s2)
 21a:	2781                	sext.w	a5,a5
 21c:	d7f5                	beqz	a5,208 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 21e:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 220:	00001a17          	auipc	s4,0x1
 224:	9f8a0a13          	addi	s4,s4,-1544 # c18 <malloc+0x170>
    b_n += 1;
 228:	00001917          	auipc	s2,0x1
 22c:	ae490913          	addi	s2,s2,-1308 # d0c <b_n>
  for (i = 0; i < 100; i++) {
 230:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 234:	85a6                	mv	a1,s1
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	7b8080e7          	jalr	1976(ra) # 9f0 <printf>
    b_n += 1;
 240:	00092783          	lw	a5,0(s2)
 244:	2785                	addiw	a5,a5,1
 246:	00f92023          	sw	a5,0(s2)
    thread_yield();
 24a:	00000097          	auipc	ra,0x0
 24e:	e8e080e7          	jalr	-370(ra) # d8 <thread_yield>
  for (i = 0; i < 100; i++) {
 252:	2485                	addiw	s1,s1,1
 254:	ff3490e3          	bne	s1,s3,234 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 258:	00001597          	auipc	a1,0x1
 25c:	ab45a583          	lw	a1,-1356(a1) # d0c <b_n>
 260:	00001517          	auipc	a0,0x1
 264:	9c850513          	addi	a0,a0,-1592 # c28 <malloc+0x180>
 268:	00000097          	auipc	ra,0x0
 26c:	788080e7          	jalr	1928(ra) # 9f0 <printf>

  current_thread->state = FREE;
 270:	00001797          	auipc	a5,0x1
 274:	ab07b783          	ld	a5,-1360(a5) # d20 <current_thread>
 278:	6709                	lui	a4,0x2
 27a:	97ba                	add	a5,a5,a4
 27c:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 280:	00000097          	auipc	ra,0x0
 284:	da6080e7          	jalr	-602(ra) # 26 <thread_schedule>
}
 288:	70a2                	ld	ra,40(sp)
 28a:	7402                	ld	s0,32(sp)
 28c:	64e2                	ld	s1,24(sp)
 28e:	6942                	ld	s2,16(sp)
 290:	69a2                	ld	s3,8(sp)
 292:	6a02                	ld	s4,0(sp)
 294:	6145                	addi	sp,sp,48
 296:	8082                	ret

0000000000000298 <thread_c>:

void 
thread_c(void)
{
 298:	7179                	addi	sp,sp,-48
 29a:	f406                	sd	ra,40(sp)
 29c:	f022                	sd	s0,32(sp)
 29e:	ec26                	sd	s1,24(sp)
 2a0:	e84a                	sd	s2,16(sp)
 2a2:	e44e                	sd	s3,8(sp)
 2a4:	e052                	sd	s4,0(sp)
 2a6:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2a8:	00001517          	auipc	a0,0x1
 2ac:	9a050513          	addi	a0,a0,-1632 # c48 <malloc+0x1a0>
 2b0:	00000097          	auipc	ra,0x0
 2b4:	740080e7          	jalr	1856(ra) # 9f0 <printf>
  c_started = 1;
 2b8:	4785                	li	a5,1
 2ba:	00001717          	auipc	a4,0x1
 2be:	a4f72d23          	sw	a5,-1446(a4) # d14 <c_started>
  while(a_started == 0 || b_started == 0)
 2c2:	00001497          	auipc	s1,0x1
 2c6:	a5a48493          	addi	s1,s1,-1446 # d1c <a_started>
 2ca:	00001917          	auipc	s2,0x1
 2ce:	a4e90913          	addi	s2,s2,-1458 # d18 <b_started>
 2d2:	a029                	j	2dc <thread_c+0x44>
    thread_yield();
 2d4:	00000097          	auipc	ra,0x0
 2d8:	e04080e7          	jalr	-508(ra) # d8 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2dc:	409c                	lw	a5,0(s1)
 2de:	2781                	sext.w	a5,a5
 2e0:	dbf5                	beqz	a5,2d4 <thread_c+0x3c>
 2e2:	00092783          	lw	a5,0(s2)
 2e6:	2781                	sext.w	a5,a5
 2e8:	d7f5                	beqz	a5,2d4 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 2ea:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 2ec:	00001a17          	auipc	s4,0x1
 2f0:	974a0a13          	addi	s4,s4,-1676 # c60 <malloc+0x1b8>
    c_n += 1;
 2f4:	00001917          	auipc	s2,0x1
 2f8:	a1490913          	addi	s2,s2,-1516 # d08 <c_n>
  for (i = 0; i < 100; i++) {
 2fc:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 300:	85a6                	mv	a1,s1
 302:	8552                	mv	a0,s4
 304:	00000097          	auipc	ra,0x0
 308:	6ec080e7          	jalr	1772(ra) # 9f0 <printf>
    c_n += 1;
 30c:	00092783          	lw	a5,0(s2)
 310:	2785                	addiw	a5,a5,1
 312:	00f92023          	sw	a5,0(s2)
    thread_yield();
 316:	00000097          	auipc	ra,0x0
 31a:	dc2080e7          	jalr	-574(ra) # d8 <thread_yield>
  for (i = 0; i < 100; i++) {
 31e:	2485                	addiw	s1,s1,1
 320:	ff3490e3          	bne	s1,s3,300 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 324:	00001597          	auipc	a1,0x1
 328:	9e45a583          	lw	a1,-1564(a1) # d08 <c_n>
 32c:	00001517          	auipc	a0,0x1
 330:	94450513          	addi	a0,a0,-1724 # c70 <malloc+0x1c8>
 334:	00000097          	auipc	ra,0x0
 338:	6bc080e7          	jalr	1724(ra) # 9f0 <printf>

  current_thread->state = FREE;
 33c:	00001797          	auipc	a5,0x1
 340:	9e47b783          	ld	a5,-1564(a5) # d20 <current_thread>
 344:	6709                	lui	a4,0x2
 346:	97ba                	add	a5,a5,a4
 348:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 34c:	00000097          	auipc	ra,0x0
 350:	cda080e7          	jalr	-806(ra) # 26 <thread_schedule>
}
 354:	70a2                	ld	ra,40(sp)
 356:	7402                	ld	s0,32(sp)
 358:	64e2                	ld	s1,24(sp)
 35a:	6942                	ld	s2,16(sp)
 35c:	69a2                	ld	s3,8(sp)
 35e:	6a02                	ld	s4,0(sp)
 360:	6145                	addi	sp,sp,48
 362:	8082                	ret

0000000000000364 <main>:

int 
main(int argc, char *argv[]) 
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 36c:	00001797          	auipc	a5,0x1
 370:	9a07a423          	sw	zero,-1624(a5) # d14 <c_started>
 374:	00001797          	auipc	a5,0x1
 378:	9a07a223          	sw	zero,-1628(a5) # d18 <b_started>
 37c:	00001797          	auipc	a5,0x1
 380:	9a07a023          	sw	zero,-1632(a5) # d1c <a_started>
  a_n = b_n = c_n = 0;
 384:	00001797          	auipc	a5,0x1
 388:	9807a223          	sw	zero,-1660(a5) # d08 <c_n>
 38c:	00001797          	auipc	a5,0x1
 390:	9807a023          	sw	zero,-1664(a5) # d0c <b_n>
 394:	00001797          	auipc	a5,0x1
 398:	9607ae23          	sw	zero,-1668(a5) # d10 <a_n>
  thread_init();
 39c:	00000097          	auipc	ra,0x0
 3a0:	c64080e7          	jalr	-924(ra) # 0 <thread_init>
  thread_create(thread_a);
 3a4:	00000517          	auipc	a0,0x0
 3a8:	d5c50513          	addi	a0,a0,-676 # 100 <thread_a>
 3ac:	00000097          	auipc	ra,0x0
 3b0:	cf4080e7          	jalr	-780(ra) # a0 <thread_create>
  thread_create(thread_b);
 3b4:	00000517          	auipc	a0,0x0
 3b8:	e1850513          	addi	a0,a0,-488 # 1cc <thread_b>
 3bc:	00000097          	auipc	ra,0x0
 3c0:	ce4080e7          	jalr	-796(ra) # a0 <thread_create>
  thread_create(thread_c);
 3c4:	00000517          	auipc	a0,0x0
 3c8:	ed450513          	addi	a0,a0,-300 # 298 <thread_c>
 3cc:	00000097          	auipc	ra,0x0
 3d0:	cd4080e7          	jalr	-812(ra) # a0 <thread_create>
  thread_schedule();
 3d4:	00000097          	auipc	ra,0x0
 3d8:	c52080e7          	jalr	-942(ra) # 26 <thread_schedule>
  exit(0);
 3dc:	4501                	li	a0,0
 3de:	00000097          	auipc	ra,0x0
 3e2:	290080e7          	jalr	656(ra) # 66e <exit>

00000000000003e6 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	ret    /* return to ra */
 3e6:	8082                	ret

00000000000003e8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e406                	sd	ra,8(sp)
 3ec:	e022                	sd	s0,0(sp)
 3ee:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3f0:	00000097          	auipc	ra,0x0
 3f4:	f74080e7          	jalr	-140(ra) # 364 <main>
  exit(0);
 3f8:	4501                	li	a0,0
 3fa:	00000097          	auipc	ra,0x0
 3fe:	274080e7          	jalr	628(ra) # 66e <exit>

0000000000000402 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 408:	87aa                	mv	a5,a0
 40a:	0585                	addi	a1,a1,1
 40c:	0785                	addi	a5,a5,1
 40e:	fff5c703          	lbu	a4,-1(a1)
 412:	fee78fa3          	sb	a4,-1(a5)
 416:	fb75                	bnez	a4,40a <strcpy+0x8>
    ;
  return os;
}
 418:	6422                	ld	s0,8(sp)
 41a:	0141                	addi	sp,sp,16
 41c:	8082                	ret

000000000000041e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 424:	00054783          	lbu	a5,0(a0)
 428:	cb91                	beqz	a5,43c <strcmp+0x1e>
 42a:	0005c703          	lbu	a4,0(a1)
 42e:	00f71763          	bne	a4,a5,43c <strcmp+0x1e>
    p++, q++;
 432:	0505                	addi	a0,a0,1
 434:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 436:	00054783          	lbu	a5,0(a0)
 43a:	fbe5                	bnez	a5,42a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 43c:	0005c503          	lbu	a0,0(a1)
}
 440:	40a7853b          	subw	a0,a5,a0
 444:	6422                	ld	s0,8(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret

000000000000044a <strlen>:

uint
strlen(const char *s)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 450:	00054783          	lbu	a5,0(a0)
 454:	cf91                	beqz	a5,470 <strlen+0x26>
 456:	0505                	addi	a0,a0,1
 458:	87aa                	mv	a5,a0
 45a:	4685                	li	a3,1
 45c:	9e89                	subw	a3,a3,a0
 45e:	00f6853b          	addw	a0,a3,a5
 462:	0785                	addi	a5,a5,1
 464:	fff7c703          	lbu	a4,-1(a5)
 468:	fb7d                	bnez	a4,45e <strlen+0x14>
    ;
  return n;
}
 46a:	6422                	ld	s0,8(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret
  for(n = 0; s[n]; n++)
 470:	4501                	li	a0,0
 472:	bfe5                	j	46a <strlen+0x20>

0000000000000474 <memset>:

void*
memset(void *dst, int c, uint n)
{
 474:	1141                	addi	sp,sp,-16
 476:	e422                	sd	s0,8(sp)
 478:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 47a:	ca19                	beqz	a2,490 <memset+0x1c>
 47c:	87aa                	mv	a5,a0
 47e:	1602                	slli	a2,a2,0x20
 480:	9201                	srli	a2,a2,0x20
 482:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 486:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 48a:	0785                	addi	a5,a5,1
 48c:	fee79de3          	bne	a5,a4,486 <memset+0x12>
  }
  return dst;
}
 490:	6422                	ld	s0,8(sp)
 492:	0141                	addi	sp,sp,16
 494:	8082                	ret

0000000000000496 <strchr>:

char*
strchr(const char *s, char c)
{
 496:	1141                	addi	sp,sp,-16
 498:	e422                	sd	s0,8(sp)
 49a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 49c:	00054783          	lbu	a5,0(a0)
 4a0:	cb99                	beqz	a5,4b6 <strchr+0x20>
    if(*s == c)
 4a2:	00f58763          	beq	a1,a5,4b0 <strchr+0x1a>
  for(; *s; s++)
 4a6:	0505                	addi	a0,a0,1
 4a8:	00054783          	lbu	a5,0(a0)
 4ac:	fbfd                	bnez	a5,4a2 <strchr+0xc>
      return (char*)s;
  return 0;
 4ae:	4501                	li	a0,0
}
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret
  return 0;
 4b6:	4501                	li	a0,0
 4b8:	bfe5                	j	4b0 <strchr+0x1a>

00000000000004ba <gets>:

char*
gets(char *buf, int max)
{
 4ba:	711d                	addi	sp,sp,-96
 4bc:	ec86                	sd	ra,88(sp)
 4be:	e8a2                	sd	s0,80(sp)
 4c0:	e4a6                	sd	s1,72(sp)
 4c2:	e0ca                	sd	s2,64(sp)
 4c4:	fc4e                	sd	s3,56(sp)
 4c6:	f852                	sd	s4,48(sp)
 4c8:	f456                	sd	s5,40(sp)
 4ca:	f05a                	sd	s6,32(sp)
 4cc:	ec5e                	sd	s7,24(sp)
 4ce:	1080                	addi	s0,sp,96
 4d0:	8baa                	mv	s7,a0
 4d2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d4:	892a                	mv	s2,a0
 4d6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4d8:	4aa9                	li	s5,10
 4da:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4dc:	89a6                	mv	s3,s1
 4de:	2485                	addiw	s1,s1,1
 4e0:	0344d863          	bge	s1,s4,510 <gets+0x56>
    cc = read(0, &c, 1);
 4e4:	4605                	li	a2,1
 4e6:	faf40593          	addi	a1,s0,-81
 4ea:	4501                	li	a0,0
 4ec:	00000097          	auipc	ra,0x0
 4f0:	19a080e7          	jalr	410(ra) # 686 <read>
    if(cc < 1)
 4f4:	00a05e63          	blez	a0,510 <gets+0x56>
    buf[i++] = c;
 4f8:	faf44783          	lbu	a5,-81(s0)
 4fc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 500:	01578763          	beq	a5,s5,50e <gets+0x54>
 504:	0905                	addi	s2,s2,1
 506:	fd679be3          	bne	a5,s6,4dc <gets+0x22>
  for(i=0; i+1 < max; ){
 50a:	89a6                	mv	s3,s1
 50c:	a011                	j	510 <gets+0x56>
 50e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 510:	99de                	add	s3,s3,s7
 512:	00098023          	sb	zero,0(s3)
  return buf;
}
 516:	855e                	mv	a0,s7
 518:	60e6                	ld	ra,88(sp)
 51a:	6446                	ld	s0,80(sp)
 51c:	64a6                	ld	s1,72(sp)
 51e:	6906                	ld	s2,64(sp)
 520:	79e2                	ld	s3,56(sp)
 522:	7a42                	ld	s4,48(sp)
 524:	7aa2                	ld	s5,40(sp)
 526:	7b02                	ld	s6,32(sp)
 528:	6be2                	ld	s7,24(sp)
 52a:	6125                	addi	sp,sp,96
 52c:	8082                	ret

000000000000052e <stat>:

int
stat(const char *n, struct stat *st)
{
 52e:	1101                	addi	sp,sp,-32
 530:	ec06                	sd	ra,24(sp)
 532:	e822                	sd	s0,16(sp)
 534:	e426                	sd	s1,8(sp)
 536:	e04a                	sd	s2,0(sp)
 538:	1000                	addi	s0,sp,32
 53a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 53c:	4581                	li	a1,0
 53e:	00000097          	auipc	ra,0x0
 542:	170080e7          	jalr	368(ra) # 6ae <open>
  if(fd < 0)
 546:	02054563          	bltz	a0,570 <stat+0x42>
 54a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 54c:	85ca                	mv	a1,s2
 54e:	00000097          	auipc	ra,0x0
 552:	178080e7          	jalr	376(ra) # 6c6 <fstat>
 556:	892a                	mv	s2,a0
  close(fd);
 558:	8526                	mv	a0,s1
 55a:	00000097          	auipc	ra,0x0
 55e:	13c080e7          	jalr	316(ra) # 696 <close>
  return r;
}
 562:	854a                	mv	a0,s2
 564:	60e2                	ld	ra,24(sp)
 566:	6442                	ld	s0,16(sp)
 568:	64a2                	ld	s1,8(sp)
 56a:	6902                	ld	s2,0(sp)
 56c:	6105                	addi	sp,sp,32
 56e:	8082                	ret
    return -1;
 570:	597d                	li	s2,-1
 572:	bfc5                	j	562 <stat+0x34>

0000000000000574 <atoi>:

int
atoi(const char *s)
{
 574:	1141                	addi	sp,sp,-16
 576:	e422                	sd	s0,8(sp)
 578:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 57a:	00054683          	lbu	a3,0(a0)
 57e:	fd06879b          	addiw	a5,a3,-48
 582:	0ff7f793          	zext.b	a5,a5
 586:	4625                	li	a2,9
 588:	02f66863          	bltu	a2,a5,5b8 <atoi+0x44>
 58c:	872a                	mv	a4,a0
  n = 0;
 58e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 590:	0705                	addi	a4,a4,1 # 2001 <__global_pointer$+0xb00>
 592:	0025179b          	slliw	a5,a0,0x2
 596:	9fa9                	addw	a5,a5,a0
 598:	0017979b          	slliw	a5,a5,0x1
 59c:	9fb5                	addw	a5,a5,a3
 59e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5a2:	00074683          	lbu	a3,0(a4)
 5a6:	fd06879b          	addiw	a5,a3,-48
 5aa:	0ff7f793          	zext.b	a5,a5
 5ae:	fef671e3          	bgeu	a2,a5,590 <atoi+0x1c>
  return n;
}
 5b2:	6422                	ld	s0,8(sp)
 5b4:	0141                	addi	sp,sp,16
 5b6:	8082                	ret
  n = 0;
 5b8:	4501                	li	a0,0
 5ba:	bfe5                	j	5b2 <atoi+0x3e>

00000000000005bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5bc:	1141                	addi	sp,sp,-16
 5be:	e422                	sd	s0,8(sp)
 5c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5c2:	02b57463          	bgeu	a0,a1,5ea <memmove+0x2e>
    while(n-- > 0)
 5c6:	00c05f63          	blez	a2,5e4 <memmove+0x28>
 5ca:	1602                	slli	a2,a2,0x20
 5cc:	9201                	srli	a2,a2,0x20
 5ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 5d4:	0585                	addi	a1,a1,1
 5d6:	0705                	addi	a4,a4,1
 5d8:	fff5c683          	lbu	a3,-1(a1)
 5dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5e0:	fee79ae3          	bne	a5,a4,5d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5e4:	6422                	ld	s0,8(sp)
 5e6:	0141                	addi	sp,sp,16
 5e8:	8082                	ret
    dst += n;
 5ea:	00c50733          	add	a4,a0,a2
    src += n;
 5ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5f0:	fec05ae3          	blez	a2,5e4 <memmove+0x28>
 5f4:	fff6079b          	addiw	a5,a2,-1
 5f8:	1782                	slli	a5,a5,0x20
 5fa:	9381                	srli	a5,a5,0x20
 5fc:	fff7c793          	not	a5,a5
 600:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 602:	15fd                	addi	a1,a1,-1
 604:	177d                	addi	a4,a4,-1
 606:	0005c683          	lbu	a3,0(a1)
 60a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 60e:	fee79ae3          	bne	a5,a4,602 <memmove+0x46>
 612:	bfc9                	j	5e4 <memmove+0x28>

0000000000000614 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 614:	1141                	addi	sp,sp,-16
 616:	e422                	sd	s0,8(sp)
 618:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 61a:	ca05                	beqz	a2,64a <memcmp+0x36>
 61c:	fff6069b          	addiw	a3,a2,-1
 620:	1682                	slli	a3,a3,0x20
 622:	9281                	srli	a3,a3,0x20
 624:	0685                	addi	a3,a3,1
 626:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 628:	00054783          	lbu	a5,0(a0)
 62c:	0005c703          	lbu	a4,0(a1)
 630:	00e79863          	bne	a5,a4,640 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 634:	0505                	addi	a0,a0,1
    p2++;
 636:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 638:	fed518e3          	bne	a0,a3,628 <memcmp+0x14>
  }
  return 0;
 63c:	4501                	li	a0,0
 63e:	a019                	j	644 <memcmp+0x30>
      return *p1 - *p2;
 640:	40e7853b          	subw	a0,a5,a4
}
 644:	6422                	ld	s0,8(sp)
 646:	0141                	addi	sp,sp,16
 648:	8082                	ret
  return 0;
 64a:	4501                	li	a0,0
 64c:	bfe5                	j	644 <memcmp+0x30>

000000000000064e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 64e:	1141                	addi	sp,sp,-16
 650:	e406                	sd	ra,8(sp)
 652:	e022                	sd	s0,0(sp)
 654:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 656:	00000097          	auipc	ra,0x0
 65a:	f66080e7          	jalr	-154(ra) # 5bc <memmove>
}
 65e:	60a2                	ld	ra,8(sp)
 660:	6402                	ld	s0,0(sp)
 662:	0141                	addi	sp,sp,16
 664:	8082                	ret

0000000000000666 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 666:	4885                	li	a7,1
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <exit>:
.global exit
exit:
 li a7, SYS_exit
 66e:	4889                	li	a7,2
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <wait>:
.global wait
wait:
 li a7, SYS_wait
 676:	488d                	li	a7,3
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 67e:	4891                	li	a7,4
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <read>:
.global read
read:
 li a7, SYS_read
 686:	4895                	li	a7,5
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <write>:
.global write
write:
 li a7, SYS_write
 68e:	48c1                	li	a7,16
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <close>:
.global close
close:
 li a7, SYS_close
 696:	48d5                	li	a7,21
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <kill>:
.global kill
kill:
 li a7, SYS_kill
 69e:	4899                	li	a7,6
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 6a6:	489d                	li	a7,7
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <open>:
.global open
open:
 li a7, SYS_open
 6ae:	48bd                	li	a7,15
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6b6:	48c5                	li	a7,17
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6be:	48c9                	li	a7,18
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6c6:	48a1                	li	a7,8
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <link>:
.global link
link:
 li a7, SYS_link
 6ce:	48cd                	li	a7,19
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6d6:	48d1                	li	a7,20
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6de:	48a5                	li	a7,9
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6e6:	48a9                	li	a7,10
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ee:	48ad                	li	a7,11
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6f6:	48b1                	li	a7,12
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6fe:	48b5                	li	a7,13
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 706:	48b9                	li	a7,14
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <dup2>:
.global dup2
dup2:
 li a7, SYS_dup2
 70e:	48d9                	li	a7,22
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 716:	1101                	addi	sp,sp,-32
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 722:	4605                	li	a2,1
 724:	fef40593          	addi	a1,s0,-17
 728:	00000097          	auipc	ra,0x0
 72c:	f66080e7          	jalr	-154(ra) # 68e <write>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6105                	addi	sp,sp,32
 736:	8082                	ret

0000000000000738 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 738:	7139                	addi	sp,sp,-64
 73a:	fc06                	sd	ra,56(sp)
 73c:	f822                	sd	s0,48(sp)
 73e:	f426                	sd	s1,40(sp)
 740:	f04a                	sd	s2,32(sp)
 742:	ec4e                	sd	s3,24(sp)
 744:	0080                	addi	s0,sp,64
 746:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 748:	c299                	beqz	a3,74e <printint+0x16>
 74a:	0805c963          	bltz	a1,7dc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 74e:	2581                	sext.w	a1,a1
  neg = 0;
 750:	4881                	li	a7,0
 752:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 756:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 758:	2601                	sext.w	a2,a2
 75a:	00000517          	auipc	a0,0x0
 75e:	59650513          	addi	a0,a0,1430 # cf0 <digits>
 762:	883a                	mv	a6,a4
 764:	2705                	addiw	a4,a4,1
 766:	02c5f7bb          	remuw	a5,a1,a2
 76a:	1782                	slli	a5,a5,0x20
 76c:	9381                	srli	a5,a5,0x20
 76e:	97aa                	add	a5,a5,a0
 770:	0007c783          	lbu	a5,0(a5)
 774:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 778:	0005879b          	sext.w	a5,a1
 77c:	02c5d5bb          	divuw	a1,a1,a2
 780:	0685                	addi	a3,a3,1
 782:	fec7f0e3          	bgeu	a5,a2,762 <printint+0x2a>
  if(neg)
 786:	00088c63          	beqz	a7,79e <printint+0x66>
    buf[i++] = '-';
 78a:	fd070793          	addi	a5,a4,-48
 78e:	00878733          	add	a4,a5,s0
 792:	02d00793          	li	a5,45
 796:	fef70823          	sb	a5,-16(a4)
 79a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 79e:	02e05863          	blez	a4,7ce <printint+0x96>
 7a2:	fc040793          	addi	a5,s0,-64
 7a6:	00e78933          	add	s2,a5,a4
 7aa:	fff78993          	addi	s3,a5,-1
 7ae:	99ba                	add	s3,s3,a4
 7b0:	377d                	addiw	a4,a4,-1
 7b2:	1702                	slli	a4,a4,0x20
 7b4:	9301                	srli	a4,a4,0x20
 7b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7ba:	fff94583          	lbu	a1,-1(s2)
 7be:	8526                	mv	a0,s1
 7c0:	00000097          	auipc	ra,0x0
 7c4:	f56080e7          	jalr	-170(ra) # 716 <putc>
  while(--i >= 0)
 7c8:	197d                	addi	s2,s2,-1
 7ca:	ff3918e3          	bne	s2,s3,7ba <printint+0x82>
}
 7ce:	70e2                	ld	ra,56(sp)
 7d0:	7442                	ld	s0,48(sp)
 7d2:	74a2                	ld	s1,40(sp)
 7d4:	7902                	ld	s2,32(sp)
 7d6:	69e2                	ld	s3,24(sp)
 7d8:	6121                	addi	sp,sp,64
 7da:	8082                	ret
    x = -xx;
 7dc:	40b005bb          	negw	a1,a1
    neg = 1;
 7e0:	4885                	li	a7,1
    x = -xx;
 7e2:	bf85                	j	752 <printint+0x1a>

00000000000007e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7e4:	7119                	addi	sp,sp,-128
 7e6:	fc86                	sd	ra,120(sp)
 7e8:	f8a2                	sd	s0,112(sp)
 7ea:	f4a6                	sd	s1,104(sp)
 7ec:	f0ca                	sd	s2,96(sp)
 7ee:	ecce                	sd	s3,88(sp)
 7f0:	e8d2                	sd	s4,80(sp)
 7f2:	e4d6                	sd	s5,72(sp)
 7f4:	e0da                	sd	s6,64(sp)
 7f6:	fc5e                	sd	s7,56(sp)
 7f8:	f862                	sd	s8,48(sp)
 7fa:	f466                	sd	s9,40(sp)
 7fc:	f06a                	sd	s10,32(sp)
 7fe:	ec6e                	sd	s11,24(sp)
 800:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 802:	0005c903          	lbu	s2,0(a1)
 806:	18090f63          	beqz	s2,9a4 <vprintf+0x1c0>
 80a:	8aaa                	mv	s5,a0
 80c:	8b32                	mv	s6,a2
 80e:	00158493          	addi	s1,a1,1
  state = 0;
 812:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 814:	02500a13          	li	s4,37
 818:	4c55                	li	s8,21
 81a:	00000c97          	auipc	s9,0x0
 81e:	47ec8c93          	addi	s9,s9,1150 # c98 <malloc+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 822:	02800d93          	li	s11,40
  putc(fd, 'x');
 826:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 828:	00000b97          	auipc	s7,0x0
 82c:	4c8b8b93          	addi	s7,s7,1224 # cf0 <digits>
 830:	a839                	j	84e <vprintf+0x6a>
        putc(fd, c);
 832:	85ca                	mv	a1,s2
 834:	8556                	mv	a0,s5
 836:	00000097          	auipc	ra,0x0
 83a:	ee0080e7          	jalr	-288(ra) # 716 <putc>
 83e:	a019                	j	844 <vprintf+0x60>
    } else if(state == '%'){
 840:	01498d63          	beq	s3,s4,85a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 844:	0485                	addi	s1,s1,1
 846:	fff4c903          	lbu	s2,-1(s1)
 84a:	14090d63          	beqz	s2,9a4 <vprintf+0x1c0>
    if(state == 0){
 84e:	fe0999e3          	bnez	s3,840 <vprintf+0x5c>
      if(c == '%'){
 852:	ff4910e3          	bne	s2,s4,832 <vprintf+0x4e>
        state = '%';
 856:	89d2                	mv	s3,s4
 858:	b7f5                	j	844 <vprintf+0x60>
      if(c == 'd'){
 85a:	11490c63          	beq	s2,s4,972 <vprintf+0x18e>
 85e:	f9d9079b          	addiw	a5,s2,-99
 862:	0ff7f793          	zext.b	a5,a5
 866:	10fc6e63          	bltu	s8,a5,982 <vprintf+0x19e>
 86a:	f9d9079b          	addiw	a5,s2,-99
 86e:	0ff7f713          	zext.b	a4,a5
 872:	10ec6863          	bltu	s8,a4,982 <vprintf+0x19e>
 876:	00271793          	slli	a5,a4,0x2
 87a:	97e6                	add	a5,a5,s9
 87c:	439c                	lw	a5,0(a5)
 87e:	97e6                	add	a5,a5,s9
 880:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 882:	008b0913          	addi	s2,s6,8
 886:	4685                	li	a3,1
 888:	4629                	li	a2,10
 88a:	000b2583          	lw	a1,0(s6)
 88e:	8556                	mv	a0,s5
 890:	00000097          	auipc	ra,0x0
 894:	ea8080e7          	jalr	-344(ra) # 738 <printint>
 898:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 89a:	4981                	li	s3,0
 89c:	b765                	j	844 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 89e:	008b0913          	addi	s2,s6,8
 8a2:	4681                	li	a3,0
 8a4:	4629                	li	a2,10
 8a6:	000b2583          	lw	a1,0(s6)
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	e8c080e7          	jalr	-372(ra) # 738 <printint>
 8b4:	8b4a                	mv	s6,s2
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b771                	j	844 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8ba:	008b0913          	addi	s2,s6,8
 8be:	4681                	li	a3,0
 8c0:	866a                	mv	a2,s10
 8c2:	000b2583          	lw	a1,0(s6)
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	e70080e7          	jalr	-400(ra) # 738 <printint>
 8d0:	8b4a                	mv	s6,s2
      state = 0;
 8d2:	4981                	li	s3,0
 8d4:	bf85                	j	844 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8d6:	008b0793          	addi	a5,s6,8
 8da:	f8f43423          	sd	a5,-120(s0)
 8de:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8e2:	03000593          	li	a1,48
 8e6:	8556                	mv	a0,s5
 8e8:	00000097          	auipc	ra,0x0
 8ec:	e2e080e7          	jalr	-466(ra) # 716 <putc>
  putc(fd, 'x');
 8f0:	07800593          	li	a1,120
 8f4:	8556                	mv	a0,s5
 8f6:	00000097          	auipc	ra,0x0
 8fa:	e20080e7          	jalr	-480(ra) # 716 <putc>
 8fe:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 900:	03c9d793          	srli	a5,s3,0x3c
 904:	97de                	add	a5,a5,s7
 906:	0007c583          	lbu	a1,0(a5)
 90a:	8556                	mv	a0,s5
 90c:	00000097          	auipc	ra,0x0
 910:	e0a080e7          	jalr	-502(ra) # 716 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 914:	0992                	slli	s3,s3,0x4
 916:	397d                	addiw	s2,s2,-1
 918:	fe0914e3          	bnez	s2,900 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 91c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 920:	4981                	li	s3,0
 922:	b70d                	j	844 <vprintf+0x60>
        s = va_arg(ap, char*);
 924:	008b0913          	addi	s2,s6,8
 928:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 92c:	02098163          	beqz	s3,94e <vprintf+0x16a>
        while(*s != 0){
 930:	0009c583          	lbu	a1,0(s3)
 934:	c5ad                	beqz	a1,99e <vprintf+0x1ba>
          putc(fd, *s);
 936:	8556                	mv	a0,s5
 938:	00000097          	auipc	ra,0x0
 93c:	dde080e7          	jalr	-546(ra) # 716 <putc>
          s++;
 940:	0985                	addi	s3,s3,1
        while(*s != 0){
 942:	0009c583          	lbu	a1,0(s3)
 946:	f9e5                	bnez	a1,936 <vprintf+0x152>
        s = va_arg(ap, char*);
 948:	8b4a                	mv	s6,s2
      state = 0;
 94a:	4981                	li	s3,0
 94c:	bde5                	j	844 <vprintf+0x60>
          s = "(null)";
 94e:	00000997          	auipc	s3,0x0
 952:	34298993          	addi	s3,s3,834 # c90 <malloc+0x1e8>
        while(*s != 0){
 956:	85ee                	mv	a1,s11
 958:	bff9                	j	936 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 95a:	008b0913          	addi	s2,s6,8
 95e:	000b4583          	lbu	a1,0(s6)
 962:	8556                	mv	a0,s5
 964:	00000097          	auipc	ra,0x0
 968:	db2080e7          	jalr	-590(ra) # 716 <putc>
 96c:	8b4a                	mv	s6,s2
      state = 0;
 96e:	4981                	li	s3,0
 970:	bdd1                	j	844 <vprintf+0x60>
        putc(fd, c);
 972:	85d2                	mv	a1,s4
 974:	8556                	mv	a0,s5
 976:	00000097          	auipc	ra,0x0
 97a:	da0080e7          	jalr	-608(ra) # 716 <putc>
      state = 0;
 97e:	4981                	li	s3,0
 980:	b5d1                	j	844 <vprintf+0x60>
        putc(fd, '%');
 982:	85d2                	mv	a1,s4
 984:	8556                	mv	a0,s5
 986:	00000097          	auipc	ra,0x0
 98a:	d90080e7          	jalr	-624(ra) # 716 <putc>
        putc(fd, c);
 98e:	85ca                	mv	a1,s2
 990:	8556                	mv	a0,s5
 992:	00000097          	auipc	ra,0x0
 996:	d84080e7          	jalr	-636(ra) # 716 <putc>
      state = 0;
 99a:	4981                	li	s3,0
 99c:	b565                	j	844 <vprintf+0x60>
        s = va_arg(ap, char*);
 99e:	8b4a                	mv	s6,s2
      state = 0;
 9a0:	4981                	li	s3,0
 9a2:	b54d                	j	844 <vprintf+0x60>
    }
  }
}
 9a4:	70e6                	ld	ra,120(sp)
 9a6:	7446                	ld	s0,112(sp)
 9a8:	74a6                	ld	s1,104(sp)
 9aa:	7906                	ld	s2,96(sp)
 9ac:	69e6                	ld	s3,88(sp)
 9ae:	6a46                	ld	s4,80(sp)
 9b0:	6aa6                	ld	s5,72(sp)
 9b2:	6b06                	ld	s6,64(sp)
 9b4:	7be2                	ld	s7,56(sp)
 9b6:	7c42                	ld	s8,48(sp)
 9b8:	7ca2                	ld	s9,40(sp)
 9ba:	7d02                	ld	s10,32(sp)
 9bc:	6de2                	ld	s11,24(sp)
 9be:	6109                	addi	sp,sp,128
 9c0:	8082                	ret

00000000000009c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9c2:	715d                	addi	sp,sp,-80
 9c4:	ec06                	sd	ra,24(sp)
 9c6:	e822                	sd	s0,16(sp)
 9c8:	1000                	addi	s0,sp,32
 9ca:	e010                	sd	a2,0(s0)
 9cc:	e414                	sd	a3,8(s0)
 9ce:	e818                	sd	a4,16(s0)
 9d0:	ec1c                	sd	a5,24(s0)
 9d2:	03043023          	sd	a6,32(s0)
 9d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9de:	8622                	mv	a2,s0
 9e0:	00000097          	auipc	ra,0x0
 9e4:	e04080e7          	jalr	-508(ra) # 7e4 <vprintf>
}
 9e8:	60e2                	ld	ra,24(sp)
 9ea:	6442                	ld	s0,16(sp)
 9ec:	6161                	addi	sp,sp,80
 9ee:	8082                	ret

00000000000009f0 <printf>:

void
printf(const char *fmt, ...)
{
 9f0:	711d                	addi	sp,sp,-96
 9f2:	ec06                	sd	ra,24(sp)
 9f4:	e822                	sd	s0,16(sp)
 9f6:	1000                	addi	s0,sp,32
 9f8:	e40c                	sd	a1,8(s0)
 9fa:	e810                	sd	a2,16(s0)
 9fc:	ec14                	sd	a3,24(s0)
 9fe:	f018                	sd	a4,32(s0)
 a00:	f41c                	sd	a5,40(s0)
 a02:	03043823          	sd	a6,48(s0)
 a06:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a0a:	00840613          	addi	a2,s0,8
 a0e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a12:	85aa                	mv	a1,a0
 a14:	4505                	li	a0,1
 a16:	00000097          	auipc	ra,0x0
 a1a:	dce080e7          	jalr	-562(ra) # 7e4 <vprintf>
}
 a1e:	60e2                	ld	ra,24(sp)
 a20:	6442                	ld	s0,16(sp)
 a22:	6125                	addi	sp,sp,96
 a24:	8082                	ret

0000000000000a26 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a26:	1141                	addi	sp,sp,-16
 a28:	e422                	sd	s0,8(sp)
 a2a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a2c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a30:	00000797          	auipc	a5,0x0
 a34:	2f87b783          	ld	a5,760(a5) # d28 <freep>
 a38:	a02d                	j	a62 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a3a:	4618                	lw	a4,8(a2)
 a3c:	9f2d                	addw	a4,a4,a1
 a3e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a42:	6398                	ld	a4,0(a5)
 a44:	6310                	ld	a2,0(a4)
 a46:	a83d                	j	a84 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a48:	ff852703          	lw	a4,-8(a0)
 a4c:	9f31                	addw	a4,a4,a2
 a4e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a50:	ff053683          	ld	a3,-16(a0)
 a54:	a091                	j	a98 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a56:	6398                	ld	a4,0(a5)
 a58:	00e7e463          	bltu	a5,a4,a60 <free+0x3a>
 a5c:	00e6ea63          	bltu	a3,a4,a70 <free+0x4a>
{
 a60:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a62:	fed7fae3          	bgeu	a5,a3,a56 <free+0x30>
 a66:	6398                	ld	a4,0(a5)
 a68:	00e6e463          	bltu	a3,a4,a70 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a6c:	fee7eae3          	bltu	a5,a4,a60 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a70:	ff852583          	lw	a1,-8(a0)
 a74:	6390                	ld	a2,0(a5)
 a76:	02059813          	slli	a6,a1,0x20
 a7a:	01c85713          	srli	a4,a6,0x1c
 a7e:	9736                	add	a4,a4,a3
 a80:	fae60de3          	beq	a2,a4,a3a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a84:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a88:	4790                	lw	a2,8(a5)
 a8a:	02061593          	slli	a1,a2,0x20
 a8e:	01c5d713          	srli	a4,a1,0x1c
 a92:	973e                	add	a4,a4,a5
 a94:	fae68ae3          	beq	a3,a4,a48 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a98:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a9a:	00000717          	auipc	a4,0x0
 a9e:	28f73723          	sd	a5,654(a4) # d28 <freep>
}
 aa2:	6422                	ld	s0,8(sp)
 aa4:	0141                	addi	sp,sp,16
 aa6:	8082                	ret

0000000000000aa8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aa8:	7139                	addi	sp,sp,-64
 aaa:	fc06                	sd	ra,56(sp)
 aac:	f822                	sd	s0,48(sp)
 aae:	f426                	sd	s1,40(sp)
 ab0:	f04a                	sd	s2,32(sp)
 ab2:	ec4e                	sd	s3,24(sp)
 ab4:	e852                	sd	s4,16(sp)
 ab6:	e456                	sd	s5,8(sp)
 ab8:	e05a                	sd	s6,0(sp)
 aba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 abc:	02051493          	slli	s1,a0,0x20
 ac0:	9081                	srli	s1,s1,0x20
 ac2:	04bd                	addi	s1,s1,15
 ac4:	8091                	srli	s1,s1,0x4
 ac6:	0014899b          	addiw	s3,s1,1
 aca:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 acc:	00000517          	auipc	a0,0x0
 ad0:	25c53503          	ld	a0,604(a0) # d28 <freep>
 ad4:	c515                	beqz	a0,b00 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ad8:	4798                	lw	a4,8(a5)
 ada:	02977f63          	bgeu	a4,s1,b18 <malloc+0x70>
 ade:	8a4e                	mv	s4,s3
 ae0:	0009871b          	sext.w	a4,s3
 ae4:	6685                	lui	a3,0x1
 ae6:	00d77363          	bgeu	a4,a3,aec <malloc+0x44>
 aea:	6a05                	lui	s4,0x1
 aec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 af0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 af4:	00000917          	auipc	s2,0x0
 af8:	23490913          	addi	s2,s2,564 # d28 <freep>
  if(p == (char*)-1)
 afc:	5afd                	li	s5,-1
 afe:	a895                	j	b72 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b00:	00008797          	auipc	a5,0x8
 b04:	24078793          	addi	a5,a5,576 # 8d40 <base>
 b08:	00000717          	auipc	a4,0x0
 b0c:	22f73023          	sd	a5,544(a4) # d28 <freep>
 b10:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b12:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b16:	b7e1                	j	ade <malloc+0x36>
      if(p->s.size == nunits)
 b18:	02e48c63          	beq	s1,a4,b50 <malloc+0xa8>
        p->s.size -= nunits;
 b1c:	4137073b          	subw	a4,a4,s3
 b20:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b22:	02071693          	slli	a3,a4,0x20
 b26:	01c6d713          	srli	a4,a3,0x1c
 b2a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b2c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b30:	00000717          	auipc	a4,0x0
 b34:	1ea73c23          	sd	a0,504(a4) # d28 <freep>
      return (void*)(p + 1);
 b38:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b3c:	70e2                	ld	ra,56(sp)
 b3e:	7442                	ld	s0,48(sp)
 b40:	74a2                	ld	s1,40(sp)
 b42:	7902                	ld	s2,32(sp)
 b44:	69e2                	ld	s3,24(sp)
 b46:	6a42                	ld	s4,16(sp)
 b48:	6aa2                	ld	s5,8(sp)
 b4a:	6b02                	ld	s6,0(sp)
 b4c:	6121                	addi	sp,sp,64
 b4e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b50:	6398                	ld	a4,0(a5)
 b52:	e118                	sd	a4,0(a0)
 b54:	bff1                	j	b30 <malloc+0x88>
  hp->s.size = nu;
 b56:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b5a:	0541                	addi	a0,a0,16
 b5c:	00000097          	auipc	ra,0x0
 b60:	eca080e7          	jalr	-310(ra) # a26 <free>
  return freep;
 b64:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b68:	d971                	beqz	a0,b3c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b6a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b6c:	4798                	lw	a4,8(a5)
 b6e:	fa9775e3          	bgeu	a4,s1,b18 <malloc+0x70>
    if(p == freep)
 b72:	00093703          	ld	a4,0(s2)
 b76:	853e                	mv	a0,a5
 b78:	fef719e3          	bne	a4,a5,b6a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b7c:	8552                	mv	a0,s4
 b7e:	00000097          	auipc	ra,0x0
 b82:	b78080e7          	jalr	-1160(ra) # 6f6 <sbrk>
  if(p == (char*)-1)
 b86:	fd5518e3          	bne	a0,s5,b56 <malloc+0xae>
        return 0;
 b8a:	4501                	li	a0,0
 b8c:	bf45                	j	b3c <malloc+0x94>
