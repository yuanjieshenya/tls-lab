#include <unistd.h>
#include "user/user.h"
#include "kernel/stat.h"
#include "kernel/types.h"

void Writer(int wfd)
{
    //随便准备一些用于通信的内容
    int s[5] = {0, 1, 2, 3,};
    pid_t self = getpid();

    char buffer[1024];
    while(true)
    {
        buffer[0] = 0; //清空字符串
        snprintf(buffer, sizeof(buffer), "%s, pid:%d", s.c_str(), self);
        //将内容格式化输入到目标字符串中
        write(wfd, buffer, strlen(buffer)); //将字符串写入管道
        sleep(1);
    }
}

void Reader(int rfd)
{
    char buffer[1024];
    while(true)
    {
        buffer[0] = 0;
        ssize_t n = read(rfd, buffer, sizeof(buffer)); //从管道读取内容
        if(n > 0)
        {
            buffer[n] = 0; //这里的0相当于'\0'
            cout << “child get a massage[” << getpid() << “]#” << buffer << endl;  
            //打印读取到的内容
        }
    }
}



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
        Writer(fd[1]);
        close(fd[1]); // 通信完毕
        exit(0);
    }
    //父进程
    close(fd[1]); //关闭写端
    //向管道读入
    Writer(fd[0]);
    //等待子进程
    pid_t rid = waitpid(id, nullptr, 0);
    if(rid < 0)
        return -1;
    close(fd[0]); // 通信完毕
    return 0;
}
