#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

void generateFibonacci(int n) {
    int fib0 = 0, fib1 = 1;
    printf("Fibonacci Sequence for %d numbers: ", n);
    
    if (n >= 1) {
        printf("%d ", fib0);
    }
    if (n >= 2) {
        printf("%d ", fib1);
    }
    
    for (int i = 2; i < n; i++) {
        int fib = fib0 + fib1;
        printf("%d ", fib);
        fib0 = fib1;
        fib1 = fib;
    }
    printf("\n");
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <number>\n", argv[0]);
        return 1;
    }
    
    int n = atoi(argv[1]);
    
    if (n < 0) {
        fprintf(stderr, "Number must be non-negative.\n");
        return 1;
    }
    
    pid_t pid = fork();
    
    if (pid < 0) {
        fprintf(stderr, "Fork failed.\n");
        return 1;
    } else if (pid == 0) {
        // Child process
        generateFibonacci(n);
    } else {
        // Parent process
        wait(NULL); // Wait for the child process to complete
        printf("Child process completed.\n");
    }
    
    return 0;
}
