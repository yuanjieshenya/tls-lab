	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
    # 保存旧线程的上下文
    sd ra, 0(a0)         # 保存返回地址 ra 到旧线程栈 (a0 是旧线程的栈顶)
    sd sp, 8(a0)         # 保存栈指针 sp 到旧线程栈

    sd s0, 16(a0)        # 保存寄存器 s0
    sd s1, 24(a0)        # 保存寄存器 s1
    sd s2, 32(a0)        # 保存寄存器 s2
    sd s3, 40(a0)        # 保存寄存器 s3
    sd s4, 48(a0)        # 保存寄存器 s4
    sd s5, 56(a0)        # 保存寄存器 s5
    sd s6, 64(a0)        # 保存寄存器 s6
    sd s7, 72(a0)        # 保存寄存器 s7
    sd s8, 80(a0)        # 保存寄存器 s8
    sd s9, 88(a0)        # 保存寄存器 s9
    sd s10, 96(a0)       # 保存寄存器 s10
    sd s11, 104(a0)      # 保存寄存器 s11

    # 恢复新线程的上下文
    ld ra, 0(a1)         # 恢复返回地址 ra 从新线程栈 (a1 是新线程的栈顶)
    ld sp, 8(a1)         # 恢复栈指针 sp

    ld s0, 16(a1)        # 恢复寄存器 s0
    ld s1, 24(a1)        # 恢复寄存器 s1
    ld s2, 32(a1)        # 恢复寄存器 s2
    ld s3, 40(a1)        # 恢复寄存器 s3
    ld s4, 48(a1)        # 恢复寄存器 s4
    ld s5, 56(a1)        # 恢复寄存器 s5
    ld s6, 64(a1)        # 恢复寄存器 s6
    ld s7, 72(a1)        # 恢复寄存器 s7
    ld s8, 80(a1)        # 恢复寄存器 s8
    ld s9, 88(a1)        # 恢复寄存器 s9
    ld s10, 96(a1)       # 恢复寄存器 s10
    ld s11, 104(a1)      # 恢复寄存器 s11
	ret    /* return to ra */
