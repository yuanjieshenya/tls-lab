	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
    # 保存 callee-saved 寄存器
    push %ebx      # 32位系统下使用 push 指令
    push %ebp

    # 保存当前线程的栈指针
    mov %esp, (%edi)  # %edi 存储第一个参数，保存当前线程的栈指针

    # 切换到新线程的栈指针
    mov (%esi), %esp  # %esi 存储第二个参数，加载新线程的栈指针

    # 恢复 callee-saved 寄存器
    pop %ebp
    pop %ebx

    ret


