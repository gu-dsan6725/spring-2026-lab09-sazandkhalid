"""
FastAPI wrapper for the Memory Agent.

Provides REST endpoints for multi-tenant conversational interactions
with semantic memory. Maintains session caching so that multiple turns
within the same run_id reuse the same Agent instance.
"""

import uuid
import logging
from typing import Optional, Dict, Any

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

from agent import Agent


# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s,p%(process)s,{%(filename)s:%(lineno)d},%(levelname)s,%(message)s",
)
logger = logging.getLogger(__name__)


# ── Pydantic models ──────────────────────────────────────────────────────────

class InvocationRequest(BaseModel):
    """Request body for the /invocation endpoint."""
    user_id: str = Field(..., description="User identifier for memory isolation")
    run_id: Optional[str] = Field(None, description="Session ID (auto-generated if not provided)")
    query: str = Field(..., description="User's message")
    metadata: Optional[Dict[str, Any]] = Field(None, description="Additional context/tags")


class InvocationResponse(BaseModel):
    """Response body for the /invocation endpoint."""
    user_id: str
    run_id: str
    response: str


class PingResponse(BaseModel):
    """Response body for the /ping endpoint."""
    status: str
    message: str


# ── FastAPI app ──────────────────────────────────────────────────────────────

app = FastAPI(
    title="Memory Agent API",
    description="Multi-tenant conversational agent with semantic memory",
    version="1.0.0",
)

# Session cache: run_id -> Agent instance
# ONE Agent per session (run_id) maintained in memory
_session_cache: Dict[str, Agent] = {}


def _get_or_create_agent(user_id: str, run_id: str) -> Agent:
    """Get existing Agent for session or create a new one.

    Args:
        user_id: User identifier for memory isolation.
        run_id: Session identifier for agent reuse.

    Returns:
        An Agent instance bound to the given user_id and run_id.
    """
    if run_id in _session_cache:
        return _session_cache[run_id]

    logger.info(f"Creating new Agent for user={user_id}, run_id={run_id}")
    agent = Agent(user_id=user_id, run_id=run_id)
    _session_cache[run_id] = agent
    return agent


# ── Endpoints ────────────────────────────────────────────────────────────────

@app.get("/ping", response_model=PingResponse)
def ping():
    """Health check endpoint."""
    return PingResponse(status="ok", message="Memory Agent API is running")


@app.post("/invocation", response_model=InvocationResponse)
def invocation(request: InvocationRequest):
    """Main conversation endpoint.

    Takes a user query and returns the agent's response. Maintains
    session state via run_id so that multi-turn conversations share
    the same Agent instance and conversation history.
    """
    # Auto-generate run_id if not provided
    run_id = request.run_id or str(uuid.uuid4())[:8]

    try:
        agent = _get_or_create_agent(request.user_id, run_id)
        response_text = agent.chat(request.query)

        return InvocationResponse(
            user_id=request.user_id,
            run_id=run_id,
            response=response_text,
        )

    except Exception as e:
        logger.error(f"Error processing invocation: {e}")
        raise HTTPException(status_code=500, detail=str(e))
