from agents import discover_agents


def test_discover_agents():
    agents = discover_agents()
    names = sorted([a.name for a in agents])
    assert names == ["echo", "reverse"]
