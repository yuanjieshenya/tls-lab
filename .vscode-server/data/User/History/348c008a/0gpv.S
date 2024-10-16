	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
    pusha                        // 保存所有寄存器的值
    
    movl current_thread, %eax     // eax 指向 current_thread
    movl %esp, (%eax)             // 保存当前线程的栈指针

    movl next_thread, %eax        // eax 指向 next_thread
    movl %eax, current_thread     // 更新 current_thread 为 next_thread
    movl (%eax), %esp             // 恢复新线程的栈指针

    popa                         // 恢复所有寄存器的值

    movl $0x0, next_thread        // 清除 next_thread

    ret                           // 返回
