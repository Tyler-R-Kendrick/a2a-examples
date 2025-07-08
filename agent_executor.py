from __future__ import annotations

import logging

from a2a.server.agent_execution.agent_executor import AgentExecutor
from a2a.server.agent_execution.context import RequestContext
from a2a.server.events.event_queue import EventQueue
from a2a.types import (
    TaskArtifactUpdateEvent,
    TaskState,
    TaskStatus,
    TaskStatusUpdateEvent,
)
from a2a.utils import new_task, new_text_artifact

from agents import discover_agents

logger = logging.getLogger(__name__)


class EchoReverseAgentExecutor(AgentExecutor):
    """Simple AgentExecutor that runs all discovered agents sequentially."""

    def __init__(self) -> None:
        self.agents = discover_agents()
        logger.info("Discovered agents: %s", [a.name for a in self.agents])

    async def execute(
        self, context: RequestContext, event_queue: EventQueue
    ) -> None:
        query = context.get_user_input()
        task = context.current_task
        if not task:
            task = new_task(context.message)
            await event_queue.enqueue_event(task)

        result = query
        for agent in self.agents:
            logger.debug("Running agent %s", agent.name)
            result = agent.run(result)

        await event_queue.enqueue_event(
            TaskArtifactUpdateEvent(
                append=False,
                contextId=task.contextId,
                taskId=task.id,
                lastChunk=True,
                artifact=new_text_artifact(
                    name="result",
                    description="Result of composed agents",
                    text=result,
                ),
            )
        )
        await event_queue.enqueue_event(
            TaskStatusUpdateEvent(
                status=TaskStatus(state=TaskState.completed),
                final=True,
                contextId=task.contextId,
                taskId=task.id,
            )
        )

    async def cancel(self, context: RequestContext, event_queue: EventQueue) -> None:
        raise Exception("cancel not supported")

