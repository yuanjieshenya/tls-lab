	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	 # 参数：寄存器 a0 - 当前线程的上下文地址，寄存器 a1 - 新线程的上下文地址

    # 保存当前线程的寄存器
    # 将 caller-saved 寄存器保存到当前线程的堆栈
    mv t0, a0            # 保存当前线程指针到 t0
    sd ra, 0(t0)         # 保存返回地址 ra
    sd sp, 8(t0)         # 保存栈指针 sp
    sd s0, 16(t0)        # 保存帧指针 s0
    sd s1, 24(t0)        # 保存保存寄存器 s1
    sd s2, 32(t0)        # 保存保存寄存器 s2
    sd s3, 40(t0)        # 保存保存寄存器 s3
    sd s4, 48(t0)        # 保存保存寄存器 s4
    sd s5, 56(t0)        # 保存保存寄存器 s5
    sd s6, 64(t0)        # 保存保存寄存器 s6
    sd s7, 72(t0)        # 保存保存寄存器 s7
    sd s8, 80(t0)        # 保存保存寄存器 s8
    sd s9, 88(t0)        # 保存保存寄存器 s9
    sd s10, 96(t0)       # 保存保存寄存器 s10
    sd s11, 104(t0)      # 保存保存寄存器 s11

    # 加载新线程的寄存器
    mv t1, a1            # 保存新线程指针到 t1
    ld ra, 0(t1)         # 恢复返回地址 ra
    ld sp, 8(t1)         # 恢复栈指针 sp
    ld s0, 16(t1)        # 恢复帧指针 s0
    ld s1, 24(t1)        # 恢复保存寄存器 s1
    ld s2, 32(t1)        # 恢复保存寄存器 s2
    ld s3, 40(t1)        # 恢复保存寄存器 s3
    ld s4, 48(t1)        # 恢复保存寄存器 s4
    ld s5, 56(t1)        # 恢复保存寄存器 s5
    ld s6, 64(t1)        # 恢复保存寄存器 s6
    ld s7, 72(t1)        # 恢复保存寄存器 s7
    ld s8, 80(t1)        # 恢复保存寄存器 s8
    ld s9, 88(t1)        # 恢复保存寄存器 s9
    ld s10, 96(t1)       # 恢复保存寄存器 s10
    ld s11, 104(t1)      # 恢复保存寄存器 s11
	ret    /* return to ra */
