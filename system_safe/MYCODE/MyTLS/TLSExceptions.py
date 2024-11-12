class TLSExceptions(Exception):
    def __init__(self, info: str):
        super().__init__(info)

class WrongMessageException(TLSExceptions):
    def __init__(self, info: str):
        super().__init__(info)

class WrongKeyException(TLSExceptions):
    def __init__(self, info: str):
        super().__init__(info)

class TCPSocketException(TLSExceptions):
    def __init__(self, info: str):
        super().__init__(info)