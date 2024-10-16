	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
    /* Save the registers of the current thread */
    pushq   %rbx
    pushq   %rbp
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %r15

    /* Save the stack pointer of the current thread */
    movq    %rsp, (%rdi)

    /* Load the stack pointer of the next thread */
    movq    (%rsi), %rsp

    /* Restore the registers of the next thread */
    popq    %r15
    popq    %r14
    popq    %r13
    popq    %r12
    popq    %rbp
    popq    %rbx

    ret

