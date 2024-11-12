from MyTLS.MyTLS import *

mytls_socket = TLSClient()
mytls_socket.connect(("localhost", 8080))

mytls_socket.send("请求服务端文件！".encode("gbk"))

msg = mytls_socket.recv(2048).decode("gbk")
print("服务端信息：", msg)

fd = open("clientDir/ocean.jpg", "wb")
mytls_socket.recvFile(fd)

msg = mytls_socket.recv(2048).decode("gbk")
print("服务端信息已经收到，可以在clientDir查看：", msg)

mytls_socket.close()