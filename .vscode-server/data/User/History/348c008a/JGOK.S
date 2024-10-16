	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
    // C语言函数调用会压入 ip
	pushal
	// eax 指向 sp
	movl current_thread, %eax
    subl $72, %eax                    // 减去 9 个 uint64 (9 * 8 = 72)
	// save sp
	movl %esp, (%eax)

	
	movl next_thread, %eax
	movl %eax, current_thread
	// restore sp
	movl (%eax), %esp
	
	popal

	movl $0x0, next_thread

	ret    /* return to ra */
