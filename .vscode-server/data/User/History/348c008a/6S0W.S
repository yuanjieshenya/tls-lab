	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
        /* YOUR CODE HERE */
        pushal
        movl current_thread, %eax
        movl %esp, (%eax)

        movl next_thread, %ebx
        movl %ebx, current_thread
        movl (%ebx), %esp
        popal

        movl $0x0, next_thread
        ret                /* pop return address from stack */

    ret


