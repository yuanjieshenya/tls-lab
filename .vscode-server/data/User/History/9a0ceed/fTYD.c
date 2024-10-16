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
        write(fd[1], nums, sizeof(nums));
        close(fd[1]);
        exit(0);
    }
    else{
        close(fd[1]);
        int nums[5];
        read(fd[0], nums, sizeof(int));
        close(fd[0]);

        int sum = 0;
        for (int i = 0; i < 5; i++) {
            sum += nums[i];
        }

        printf("Sum of numbers: %d\n", sum);

        wait(0);
    }
    return 0;
}
