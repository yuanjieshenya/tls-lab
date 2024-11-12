# 这是几个helper方法，用来实现整型、短整型数据和字节数据之间的相互转换

def int_to_bytes(a: int) -> bytes:
    return bytes([(a & 0xff000000) >> 24, (a & 0xff0000) >> 16, (a & 0xff00) >> 8, a & 0xff])

def bytes_to_int(a: bytes) -> int:
    return (a[0] << 24) + (a[1] << 16) + (a[2] << 8) + a[3]

def short_to_bytes(a: int) -> bytes:
    return bytes([(a & 0xff00) >> 8, a & 0xff])

def bytes_to_short(a: bytes) -> int:
    return (a[0] << 8) + a[1]