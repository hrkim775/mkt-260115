import random

class RandomUserAgentMiddleware:
    USER_AGENT = [
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36"
    ]

    def process_request(self, request, spider) :
        request.headers.setdefault("accept-language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7")
        request.headers["USER_AGENT"] = random.choice(self.USER_AGENT).encode("UTF-8")
        return None