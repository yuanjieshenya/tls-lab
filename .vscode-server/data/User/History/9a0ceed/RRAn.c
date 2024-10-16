#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/types.h"

int main(){
    int fd[2] = {0};
    int n = pipe(fd);
    if(n < 0)
        return 1;
    int pid = fork();
    if(pid < 0)
        return 2;
    if(pid == 0)
    {
        close(fd[0]);
        int nums[5] = {1, 2, 3, 4, 5};
        write(fd[1], &num, sizeof(nums));
        close(fd[1]);
        exit(0);
    }
    close(fd[1]);
    int sum = 0;
    int num_read = 0;
    while (read(fd[0], &num_read, sizeof(int) > 0)){
        sum += num_read;
    }
    pid_t rid = waitpid(id, NULL, 0);
    if(rid < 0)
        return -1;
    printf("Sum of random integers received from child process: %d\n", sum);
    close(fd[0]); 
    return 0;
}
