## ✨ Interactive MCP Client

<p align="center">
  <img src="https://img.shields.io/badge/Java-21-007396?logo=java&logoColor=white" alt="Java 21"/>
  <img src="https://img.shields.io/badge/Spring%20Boot-3.3.2-6DB33F?logo=springboot&logoColor=white" alt="Spring Boot"/>
  <img src="https://img.shields.io/badge/Spring%20AI-1.0.0-13aa52" alt="Spring AI"/>
  <img src="https://img.shields.io/badge/Protocol-MCP-6E56CF" alt="MCP"/>
  <img src="https://img.shields.io/badge/Release-2.0.0-1f6feb" alt="Release"/>
  <img src="https://img.shields.io/badge/License-Apache%202.0-blue" alt="License"/>
</p>

<p align="center">
  <b>Test and interact with MCP servers directly — no LLM required.</b><br/>
  Built with Spring Boot + Spring AI + WebFlux. Supports STDIO, SSE, and Streamable HTTP transports.
</p>

<p align="center">
<pre>
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  🚀 Interactive Model Context Protocol (MCP) Client  ┃
┃      Debug • Inspect • Call • Validate • Repeat      ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
</pre>
</p>

---

### 🔗 Table of Contents
- [⚡ Highlights](#-highlights)
- [🧰 Requirements](#-requirements)
- [🚀 Quick Start](#-quick-start)
- [🧩 Transports & Profiles](#-transports--profiles)
- [🔐 JWT Setup (OpenMetadata)](#-jwt-setup-openmetadata)
- [🖥️ CLI Usage](#️-cli-usage)
- [🧪 Examples](#-examples)
- [🧯 Troubleshooting](#-troubleshooting)
- [❓ FAQ](#-faq)
- [🗂️ Project Structure](#️-project-structure)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🔗 Useful Links](#-useful-links)

---

## ⚡ Highlights
- 🧵 Multiple transports: **STDIO**, **SSE**, **Streamable HTTP**
- 🧪 Built for testing MCP servers without an LLM
- 🔐 First-class support for **JWT Bearer** authentication (e.g., OpenMetadata)
- 🧭 Interactive CLI: list tools, describe tools, invoke tools with JSON
- 🧱 Spring profile-based configuration for clean separation
- 🛡️ Resilient SSE handling with compatibility tweaks for OpenMetadata

---

## 🧰 Requirements
- Java 21+
- Maven 3.6+
- Node.js (only if testing STDIO servers like npm MCP servers)

Set environment variables as needed:

```bash
# If using Anthropic (optional LLM use in other contexts)
export ANTHROPIC_API_KEY=your-anthropic-api-key

# If testing Brave Search server via STDIO
export BRAVE_API_KEY=your-brave-api-key

# If connecting to OpenMetadata via SSE with JWT
export OPENMETADATA_PAT=your-openmetadata-pat
```

---

## 🚀 Quick Start
```bash
# Clone
git clone https://github.com/dbbaskette/mcp-client.git
cd mcp-client

# Run (default: stdio profile)
./mcp-client.sh

# Run with SSE
./mcp-client.sh --profile sse

# Rebuild and run (any profile)
./mcp-client.sh --rebuild -p sse
```

Pro tip: add `-v/--verbose` to the script for extra logs during local debugging.

---

## 🧩 Transports & Profiles
- 🔌 **stdio**: process-based servers (great for npm MCP servers)
- 📡 **sse**: Server-Sent Events over HTTP (great for web MCP servers)
- 🌊 **streamable**: HTTP with streaming responses (experimental servers)

Files live under `src/main/resources`:
- `application-stdio.properties`
- `application-sse.properties`
- `application-streamable.properties`

---

## 🔐 JWT Setup (OpenMetadata)
OpenMetadata SSE typically authenticates at a base path (e.g., `/mcp`) and streams at `/sse`.

Edit `src/main/resources/application-sse.properties`:

```properties
# OpenMetadata SSE (JWT via Authorization header)
spring.ai.mcp.client.sse.connections.omd.url=http://your-host:8585/mcp
spring.ai.mcp.client.sse.connections.omd.sse-endpoint=/sse
spring.ai.mcp.client.sse.connections.omd.headers.Authorization=Bearer ${OPENMETADATA_PAT}

# Connection resilience (optional)
spring.ai.mcp.client.sse.connections.omd.timeout=60s
spring.ai.mcp.client.sse.connections.omd.connect-timeout=30s
spring.ai.mcp.client.sse.connections.omd.read-timeout=60s
```

Global application settings (already tuned for clean output and resilience) in `application.properties`:

```properties
spring.application.name=mcp-client
spring.ai.mcp.client.toolcallback.enabled=true
spring.ai.mcp.client.type=SYNC

# Trim noisy logs, keep essentials
logging.level.io.modelcontextprotocol.client=INFO
logging.level.io.modelcontextprotocol.spec=INFO
logging.level.org.springframework.ai.mcp=INFO
logging.level.reactor.core.publisher.Operators=WARN

# Resilient SSE handling
spring.ai.mcp.client.connection.resilient=true
spring.ai.mcp.client.sse.lenient-parsing=true
```

Compatibility: Some OpenMetadata servers may emit occasional `null` SSE event types — the client is configured to gracefully ignore these.

---

## 🖥️ CLI Usage
Start the client and use the interactive shell:

```text
mcp-client> help
mcp-client> list-tools
mcp-client> describe-tool <toolName>
mcp-client> tool <toolName> {"param":"value"}
mcp-client> status
mcp-client> exit
```

Script options:

```bash
./mcp-client.sh [OPTIONS]
  -p, --profile <stdio|sse|streamable>
  --rebuild                 # clean build before run
  -v, --verbose             # verbose script logging
  -h, --help                # help
```

---

## 🧪 Examples
- List all available tools from connected servers:

```text
mcp-client> list-tools
```

- Describe a tool’s input schema and usage:

```text
mcp-client> describe-tool spring_ai_mcp_client_omd_search_metadata
```

- Invoke a tool with JSON parameters:

```text
mcp-client> tool spring_ai_mcp_client_omd_search_metadata {"query":"warehouses","limit":5}
```

---

## 🧯 Troubleshooting
- 500 on `/mcp/sse` (SSE): ensure the `Authorization` header is set with a valid JWT and the base URL is `/mcp` with `sse-endpoint=/sse`.
- SSE null event errors: handled silently by default; they’re benign on some OpenMetadata versions.
- Timeouts while listing tools: increase timeouts in `application-sse.properties` (see example above).
- Still stuck? Run with `--rebuild` and verify env vars: `echo $OPENMETADATA_PAT`.

---

## ❓ FAQ
- Do I need an LLM?  
  No. This client is purposely LLM-free for server testing and validation.

- Can I add my own servers easily?  
  Yes — add them to the appropriate profile properties file.

- Can I use this for other JWT-protected SSE servers?  
  Absolutely. Set the `Authorization` header and correct base/endpoint paths.

---

## 🗂️ Project Structure
```text
src/main/java/com/baskettecase/mcpclient/
├─ McpClientApplication.java        # Main Spring Boot app
├─ cli/
│  └─ CliRunner.java                # Interactive CLI
└─ config/
   ├─ McpConnectionConfigService.java
   ├─ McpErrorHandlingConfig.java    # SSE event compatibility handling
   ├─ SslConfiguration.java          # SSL relax (opt-in via properties)
   └─ WebClientConfig.java           # Global WebClient customization

src/main/resources/
├─ application.properties            # Common settings
├─ application-stdio.properties      # STDIO profile config
├─ application-sse.properties        # SSE profile config (JWT-ready)
└─ application-streamable.properties # Streamable HTTP profile config
```

---

## 🤝 Contributing
- Fork the repo, create a feature branch, commit, and open a PR  
- Use clear commit messages (e.g., `feat: add X`, `fix: handle Y`)

```bash
git checkout -b feat/my-improvement
# make changes
git commit -m "feat: my improvement"
git push origin feat/my-improvement
```

---

## 📄 License
Licensed under the **Apache 2.0** License. See `LICENSE` for details.

---

## 🔗 Useful Links
- [Spring AI MCP Docs](https://docs.spring.io/spring-ai/reference/api/mcp/mcp-client-boot-starter-docs.html)
- [MCP Specification](https://modelcontextprotocol.github.io/specification/)
- [Spring Boot Docs](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [OpenMetadata Docs](https://docs.open-metadata.org/)
- [OpenMetadata Slack](https://slack.open-metadata.org/)