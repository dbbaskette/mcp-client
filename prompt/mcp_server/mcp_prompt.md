# Model Context Protocol (MCP) Server Prompt

## Purpose
Assist with implementing an MCP server that exposes tools/capabilities to an AI client.

## Rules
1. Follow the client/tool semantics you are targeting; define clear tool schemas.
2. Keep handlers stateless and fast; enforce auth and rate limits.
3. Return structured JSON results and clear error objects.
4. Provide a local/dev runner and example client calls.
5. Add basic observability (request logs + latency counters).

## Example Stacks
- Java + Spring Boot (REST/JSON)
- Node.js + Express/Fastify
- Python + FastAPI
