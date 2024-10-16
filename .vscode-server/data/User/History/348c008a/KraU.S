	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
    # 保存 callee-saved 寄存器
    pushl %ebx
    pushl %ebp
    pushl %r12
    pushl %r13
    pushl %r14
    pushl %r15

    # 保存当前线程的栈指针
    movl %esp, (%edi)  # %edi 是 32 位的 %rdi

    # 切换到新线程的栈指针
    movl (%esi), %esp  # %esi 是 32 位的 %rsi

    # 恢复 callee-saved 寄存器
    popl %r15
    popl %r14
    popl %r13
    popl %r12
    popl %ebp
    popl %ebx

    ret

