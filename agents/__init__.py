from __future__ import annotations
import importlib
import pkgutil
from dataclasses import dataclass
from typing import Iterable, List, Protocol


class Agent(Protocol):
    name: str

    def run(self, message: str) -> str:
        ...


def discover_agents() -> List[Agent]:
    agents: List[Agent] = []
    package = __name__
    for _, mod_name, _ in pkgutil.iter_modules([__path__[0]]):
        if mod_name == '__init__':
            continue
        module = importlib.import_module(f'{package}.{mod_name}')
        agent_obj = getattr(module, 'agent', None)
        if agent_obj is not None:
            agents.append(agent_obj)
    return agents
