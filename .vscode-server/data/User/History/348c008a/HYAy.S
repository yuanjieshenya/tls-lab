	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	    .globl thread_switch
thread_switch:
    # 保存 callee-saved 寄存器
    push {r4, r5, r6, r7, r8, r9, r10, r11, r12, r14}  # 保存必要的寄存器

    # 保存当前线程的栈指针
    str sp, [r0]  # r0 存储第一个参数，保存当前线程的栈指针

    # 切换到新线程的栈指针
    ldr sp, [r1]  # r1 存储第二个参数，加载新线程的栈指针

    # 恢复 callee-saved 寄存器
    pop {r4, r5, r6, r7, r8, r9, r10, r11, r12, r14}

    bx lr  # 返回到调用者



