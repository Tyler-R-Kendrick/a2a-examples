import pytest
from a2a.server.agent_execution.context import RequestContext
from a2a.server.events.event_queue import EventQueue
from a2a.types import (
    Message,
    MessageSendParams,
    Part,
    Role,
    TextPart,
    TaskArtifactUpdateEvent,
    TaskStatusUpdateEvent,
    TaskState,
)

from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from agent_executor import EchoReverseAgentExecutor  # noqa: E402


@pytest.mark.asyncio
async def test_executor_runs_agents_sequentially():
    executor = EchoReverseAgentExecutor()
    message = Message(
        role=Role.user,
        messageId="1",
        parts=[Part(root=TextPart(text="hello"))],
    )
    params = MessageSendParams(message=message)
    context = RequestContext(params)
    queue = EventQueue()

    await executor.execute(context, queue)

    events = []
    while not queue.queue.empty():
        events.append(await queue.dequeue_event())

    artifact_event = next(e for e in events if isinstance(e, TaskArtifactUpdateEvent))
    status_event = next(e for e in events if isinstance(e, TaskStatusUpdateEvent))

    assert artifact_event.artifact.parts[0].root.text == "olleh :ohcE"
    assert status_event.status.state == TaskState.completed
