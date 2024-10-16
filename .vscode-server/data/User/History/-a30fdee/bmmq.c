#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int
main(void)
{
  int fd = open("output.txt", O_WRONLY | O_CREATE);
  if(fd < 0){
    printf("Failed to open output.txt\n");
    exit(1);
  }

  // 使用 dup2 将标准输出重定向到文件
  dup2(fd, 1);

  // 这条信息将会被写入 output.txt 文件，而不是终端
  printf("This is redirected to output.txt\n");

  close(fd);
  exit(0);
}
