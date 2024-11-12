from Crypto.Cipher import AES
from Crypto.Cipher import DES
from Crypto.Util.Padding import pad, unpad
from Crypto.Random import get_random_bytes
from MyTLS.TLSExceptions import WrongKeyException
from MyTLS.TLS_Types import myCipherType
from MyTLS.type_changer import *
from time import time
import hmac
import rsa

class MyAES:
    __mode = None #存储AES加密模式，例如 AES.MODE_ECB 或 AES.MODE_CBC
    __encodeKey  = None #存储加密密钥
    __encodeIV   = None #存储加密初始化向量
    __decodeKey  = None #存储解密用的密钥
    __decodeIV   = None #存储解密初始化向量

    __aesEncoder = None
    __aesDecoder = None #存储AES加密和解密器对象

    def __init__(self,
                 enKey: bytes,
                 deKey: bytes,
                 enIV: bytes = None,
                 deIV: bytes = None,
                 mode: int = AES.MODE_ECB):

        self.__encodeKey = enKey
        self.__decodeKey = deKey
        self.__encodeIV = enIV
        self.__decodeIV = deIV
        self.__mode = mode #初始化方法

    def encrypt(self, msg: bytes) -> bytes:#加密方法
        if not self.__aesEncoder:
            if self.__mode != AES.MODE_ECB:
                self.__aesEncoder = AES.new(self.__encodeKey, self.__mode, self.__encodeIV)
            else:
                self.__aesEncoder = AES.new(self.__encodeKey, self.__mode)

        tail = bytes(16 - ((msg.__len__() + 2) % 16)) 
        #AES 加密要求数据块长度是16字节的倍数。
        #因此，计算需要填充的字节数 tail，并填充 msg。
        leng = bytes(short_to_bytes(msg.__len__()))
        #在 msg 的前部加上一个2字节的长度标记 leng
        #然后将 leng + msg + tail 一起加密并返回结果。

        return self.__aesEncoder.encrypt(leng + msg + tail)

    def decrypt(self, msg: bytes) -> bytes:#解密方法
        if not self.__aesDecoder:
            if self.__mode != AES.MODE_ECB:
                self.__aesDecoder = AES.new(self.__decodeKey, self.__mode, self.__decodeIV)
            else:
                self.__aesDecoder = AES.new(self.__decodeKey, self.__mode)

        tmsg = self.__aesDecoder.decrypt(msg)#解析长度,解密msg
        leng = bytes_to_short(tmsg[0: 2])#获得原始信息
        return tmsg[2: 2 + leng]
    
class MyDES:
    __mode = None
    __encodeKey = None
    __encodeIV = None
    __decodeKey = None
    __decodeIV = None

    __desEncoder = None
    __desDecoder = None

    def __init__(self,
                 enKey: bytes,
                 deKey: bytes,
                 enIV: bytes = None,
                 deIV: bytes = None,
                 mode: int = DES.MODE_ECB):

        self.__encodeKey = enKey
        self.__decodeKey = deKey
        self.__encodeIV = enIV
        self.__decodeIV = deIV
        self.__mode = mode

    def encrypt(self, msg: bytes) -> bytes:
        if not self.__desEncoder:
            if self.__mode != DES.MODE_ECB:
                self.__desEncoder = DES.new(self.__encodeKey, self.__mode, self.__encodeIV)
            else:
                self.__desEncoder = DES.new(self.__encodeKey, self.__mode)

        # DES block size is 8 bytes, so we pad the message to a multiple of 8
        padded_msg = pad(msg, DES.block_size)
        return self.__desEncoder.encrypt(padded_msg)

    def decrypt(self, msg: bytes) -> bytes:
        if not self.__desDecoder:
            if self.__mode != DES.MODE_ECB:
                self.__desDecoder = DES.new(self.__decodeKey, self.__mode, self.__decodeIV)
            else:
                self.__desDecoder = DES.new(self.__decodeKey, self.__mode)

        decrypted_msg = self.__desDecoder.decrypt(msg)
        return unpad(decrypted_msg, DES.block_size)

class MyRSA:
    __publicKey  = None
    __privateKey = None

    def __init__(self, keySet: tuple = myCipherType.RSA_NEWKEYSET):
        if not keySet[0]:
            (self.__publicKey, self.__privateKey) = rsa.newkeys(myCipherType.RSA_KEYLENGTH)
        else:
            (self.__publicKey, self.__privateKey) = keySet

    def encrypt(self, msg: bytes) -> bytes:
        return rsa.encrypt(msg, self.__publicKey)

    def decrypt(self, msg: bytes) -> bytes:
        if not self.__privateKey:
            raise WrongKeyException("错误：RSA私钥未初始化，不可用于解密")
        return rsa.decrypt(msg, self.__privateKey)

    def getPublicKey(self) -> rsa.PublicKey:
        return self.__publicKey

    def getPrivateKey(self) -> rsa.PrivateKey:
        return self.__privateKey

    @staticmethod
    def generatePublicKey(n: int, e: int) -> rsa.PublicKey:
        return rsa.key.PublicKey(n, e)

    @staticmethod
    def generatePrivateKey(n: int, e: int, d: int, p: int, q: int) -> rsa.PrivateKey:
        return rsa.key.PrivateKey(n, e, d, p, q)



class MyHMac:
    __method = None
    __key    = None
    __verKey = None
    __hashLength = None

    def __init__(self, key: bytes, verKey: bytes, method: str = "sha256"):
        self.__method = method
        self.__key    = key
        self.__verKey = verKey
        if method == "sha256":
            self.__hashLength = 32

    def digest(self, msg: bytes) -> bytes:
        return hmac.digest(self.__key, msg, self.__method)

    def verify(self, msg: bytes) -> bytes:
        return hmac.digest(self.__verKey, msg, self.__method)

    def digestAndConcat(self, msg: bytes) -> bytes:
        return msg + hmac.digest(self.__key, msg, self.__method)

    def verifyAndSeparate(self, msg: bytes) -> bytes:
        realMsgLength = msg.__len__() - self.__hashLength
        realMsg = msg[0: realMsgLength]

        oldHash = msg[realMsgLength:]
        newHash = self.verify(realMsg)

        if oldHash != newHash:
            raise WrongKeyException("错误：hmac检查不相等")
        return realMsg

class MyCert:#主要是拿来生成证书的，证书文件在代码中已经附带了，不过多解释
    publicKey = None
    privateKey = None
    owner = None
    time = None

    def __init__(self, __publicKey__, __privateKey__, __owner__, __time__):
        self.publicKey = __publicKey__
        self.privateKey = __privateKey__
        self.owner = __owner__
        self.time = __time__

def makeCert(filename: str, owner: str) -> None:#用RSA生成证书
    fd = open(filename, "w")
    (publicKey, privateKey) = rsa.newkeys(myCipherType.RSA_KEYLENGTH)

    content = "publicKey:" + str(publicKey.n) + ":" +    \
              str(publicKey.e) + "\n" +    \
              "privateKey:" + str(privateKey.n) + ":" +   \
              str(privateKey.e) + ":" +   \
              str(privateKey.p) + ":" +   \
              str(privateKey.d) + ":" +   \
              str(privateKey.q) + "\n" +   \
              "owner:" + owner + "\n" +               \
              "time:" + str(int(time()))

    fd.write(content)

def loadCert(filename: str) -> MyCert:#读入证书
    fd = open(filename, "r")

    buf = fd.readline(2048).split(":")
    pbkn = int(buf[1])
    pbke = int(buf[2])

    buf = fd.readline(2048).split(":")
    pvkn = int(buf[1])
    pvke = int(buf[2])
    pvkp = int(buf[3])
    pvkd = int(buf[4])
    pvkq = int(buf[5])

    buf = fd.readline(2048).split(":")
    owner = buf[1][:buf[1].__len__() - 1]

    buf = fd.readline(2048).split(":")
    ttime = int(buf[1])

    pbk = rsa.PublicKey(pbkn, pbke)
    pvk = rsa.PrivateKey(pvkn, pvke, pvkd, pvkp, pvkq)

    return MyCert(pbk, pvk, owner, ttime)
