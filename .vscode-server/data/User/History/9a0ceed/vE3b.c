#include <unistd.h>
#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/types.h"

int main(){
    int fd[2] = {0};
    int n = pipe(fd); 
    if(n < 0)
        return 1;
    pid_t id = fork(); 
    if(id < 0)
        return 2;
    if(id == 0)
    {
        close(fd[0]);
        for(int i = 0; i < 5; i++){
            int num = i;
            write(fd[1], &num, sizeof(int));
        }
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
