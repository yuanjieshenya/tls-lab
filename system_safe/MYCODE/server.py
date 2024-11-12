from MyTLS.MyTLS import *

mytls_Socket = TLSServer()
mytls_Socket.loadCert("serverDir/ServerCert.mycert")
mytls_Socket.bind(8080)
mytls_Socket.listen()

while 1:
    server_Socket = mytls_Socket.accept()

    msg = server_Socket.recv(2048).decode("gbk")
    print("客户端请求：", msg)

    server_Socket.send("收到！".encode("gbk"))

    fd = open("serverDir/ocean.jpg", "rb")
    server_Socket.sendFile(fd)

    server_Socket.send("传输完毕！".encode("gbk"))
    print("该次请求完成")
    
    server_Socket.close()