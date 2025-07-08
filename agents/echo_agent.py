from . import Agent


class EchoAgent:
    name = "echo"

    def run(self, message: str) -> str:
        return f"Echo: {message}"


agent: Agent = EchoAgent()
