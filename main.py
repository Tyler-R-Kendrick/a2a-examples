from agents import discover_agents


def main():
    agents = discover_agents()
    print(f"Discovered {len(agents)} agents: {[a.name for a in agents]}")

    input_message = "Hello, Agents!"
    print(f"Input: {input_message}")
    for agent in agents:
        response = agent.run(input_message)
        print(f"{agent.name} -> {response}")


if __name__ == "__main__":
    main()
