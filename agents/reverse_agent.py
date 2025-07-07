from . import Agent

class ReverseAgent:
    name = "reverse"

    def run(self, message: str) -> str:
        return message[::-1]

agent: Agent = ReverseAgent()
