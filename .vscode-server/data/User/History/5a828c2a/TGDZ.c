#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define O_RDONLY  0x000
#define O_WRONLY  0x001
#define O_RDWR    0x002
#define O_CREATE  0x200
#define O_TRUNC   0x400

int main(){
    int output_fd = open("lab1_output.txt", O_WRONLY | O_CREATE);
    if (output_fd < 0) {
            fprintf(2, "Error opening output file: %s\n", "lab1_output.txt");
            exit(1);
    }

    dup(output_fd);
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
        read(fd[0], nums, sizeof(nums));
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