#include <unistd.h>
#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/types.h"

int main(){
    int fd[2] = {0};
    int n = pipe(fd); //父进程建立匿名管道
    if(n < 0)
        return 1;
    pid_t id = fork(); //创建子进程
    if(id < 0)
        return 2;
    if(id == 0) //子进程
    {
        close(fd[0]); //关闭读端
        //向管道写入
        for(int i = 0; i < 5; i++){
            int num = i;
            write(fd[1], &num, sizeof(int));
        }
        close(fd[1]); // 通信完毕
        exit(0);
    }
    //父进程
    close(fd[1]); //关闭写端
    //向管道读入
    //Reader(fd[0]);
    //等待子进程
    pid_t rid = waitpid(id, nullptr, 0);
    if(rid < 0)
        return -1;
    close(fd[0]); // 通信完毕
    return 0;
}
