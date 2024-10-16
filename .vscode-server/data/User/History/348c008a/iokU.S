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
    # 64 位寄存器在 32 位模式中不可用，删除这些寄存器的保存和恢复
    # pushl %r12
    # pushl %r13
    # pushl %r14
    # pushl %r15

    # 保存当前线程的栈指针
    movl %esp, (%edi)  # %edi 存储第一个参数，保存当前线程的栈指针

    # 切换到新线程的栈指针
    movl (%esi), %esp  # %esi 存储第二个参数，加载新线程的栈指针

    # 恢复 callee-saved 寄存器
    # popl %r15
    # popl %r14
    # popl %r13
    # popl %r12
    popl %ebp
    popl %ebx

    ret


