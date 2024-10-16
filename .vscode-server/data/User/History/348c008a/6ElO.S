	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
    # 保存 callee-saved 寄存器
    addi sp, sp, -40          # 为寄存器分配空间
    sw ra, 36(sp)             # 保存返回地址
    sw s0, 32(sp)             # 保存 s0
    sw s1, 28(sp)             # 保存 s1
    sw s2, 24(sp)             # 保存 s2
    sw s3, 20(sp)             # 保存 s3
    sw s4, 16(sp)             # 保存 s4
    sw s5, 12(sp)             # 保存 s5
    sw s6, 8(sp)              # 保存 s6
    sw s7, 4(sp)              # 保存 s7
    sw s8, 0(sp)              # 保存 s8

    # 保存当前线程的栈指针
    sw sp, 0(a0)              # a0 存储第一个参数，保存当前线程的栈指针

    # 切换到新线程的栈指针
    lw sp, 0(a1)              # a1 存储第二个参数，加载新线程的栈指针

    # 恢复 callee-saved 寄存器
    lw s8, 0(sp)              # 恢复 s8
    lw s7, 4(sp)              # 恢复 s7
    lw s6, 8(sp)              # 恢复 s6
    lw s5, 12(sp)             # 恢复 s5
    lw s4, 16(sp)             # 恢复 s4
    lw s3, 20(sp)             # 恢复 s3
    lw s2, 24(sp)             # 恢复 s2
    lw s1, 28(sp)             # 恢复 s1
    lw s0, 32(sp)             # 恢复 s0
    lw ra, 36(sp)             # 恢复返回地址
    addi sp, sp, 40           # 释放寄存器分配的空间

    jr ra                      # 返回到调用者
