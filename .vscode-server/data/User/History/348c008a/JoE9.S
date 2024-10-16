	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
    /* 保存当前线程的上下文 */
    push {r4-r11, lr}            /* 保存 r4 到 r11 及链接寄存器 lr */

    /* 将当前线程的栈指针保存 */
    ldr r0, =current_thread      /* 加载 current_thread 的地址到 r0 */
    str sp, [r0]                 /* 将当前栈指针保存到 current_thread 中 */

    /* 切换到下一个线程 */
    ldr r1, =next_thread         /* 加载 next_thread 的地址到 r1 */
    ldr r2, [r1]                 /* 从 next_thread 中加载下一个线程的指针到 r2 */
    str r2, =current_thread      /* 更新 current_thread */

    /* 恢复下一个线程的栈指针 */
    mov sp, r2                   /* 将栈指针设置为下一个线程的栈指针 */

    /* 恢复保存的上下文 */
    pop {r4-r11}                 /* 恢复 r4 到 r11 */
    bx lr                        /* 返回到调用者 */

    /* 结束标记 */
    bx lr                        /* 退出 */


