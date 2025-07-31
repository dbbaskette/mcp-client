# Project Plan & Progress

This document outlines the development plan, tracks progress, and lists potential future enhancements for the Interactive MCP Client.

## 🎯 Project Goal

Create a general-purpose, interactive Model Context Protocol (MCP) client for testing and interacting with MCP servers. The tool must be LLM-free to allow developers to validate their server implementations directly. It should support multiple transport protocols via a clean, profile-based configuration.

---

## ✅ Progress Checklist

### Phase 1: Project Foundation & Setup (Completed)
- [x] **Initialize Project:** Set up a Spring Boot project using Maven.
- [x] **Stabilize Dependencies:** Lock versions to Java 21, Spring Boot 3.3.2, and Spring AI 1.0.0.
- [x] **Fix Build System:** Implement a correct and functional Maven Wrapper (`mvnw`).

### Phase 2: Architectural Pivot (Completed)
- [x] **Adopt LLM-Free Architecture:** Refactor the application to remove all dependencies on AI models (e.g., Anthropic, OpenAI) and their associated API keys.
- [x] **Implement Profile-Based Configuration:** Shift from a single configuration file to a Spring Profile-based model (`stdio`, `sse`, `streamable`) for managing transport connections.
- [x] **Create Profile-Specific Properties:** Add `application-stdio.properties`, `application-sse.properties`, and `application-streamable.properties`.

### Phase 3: Interactive CLI Implementation (Completed)
- [x] **Implement `CliRunner`:** Create the core interactive command-line interface that runs in a loop.
- [x] **Implement `ParameterParser`:** Add a utility to parse tool arguments in both `key=value` and JSON formats.
- [x] **Implement Core Commands:**
    - [x] `status`: Show the health and info of all connected servers.
    - [x] `list-tools`: List all tools available across all connected servers.
    - [x] `describe-tool`: Show details for a specific tool.
    - [x] `invoke-tool`: Execute a tool with specified parameters.
    - [x] `help`: Display available commands.
    - [x] `exit`: Gracefully shut down the application.
- [x] **Update Launcher Script:** Simplify `mcp-client.sh` to be a launcher that passes the selected profile to the Spring Boot application.

### Phase 4: Documentation (Completed)
- [x] **Update `README.md`:** Rewrite the project's README to accurately reflect its new purpose as an interactive, LLM-free testing tool.
- [x] **Create `PROJECT_PLAN.md`:** Document the project's progress and future roadmap (this file).

---

## 🔮 Future Enhancements

Here are some potential improvements to make the client even more powerful and user-friendly.

### Tier 1: Core Functionality & UX
- **Interactive Parameter Prompting:** If `invoke-tool` is called without arguments, prompt the user for each required parameter interactively, similar to the `generic-mcp-client`.
- **Color-Coded Output:** Add ANSI colors to the CLI output to distinguish between commands, server names, successes (✅), and errors (❌) for better readability.
- **Enhanced `describe-tool`:** Improve the `describe-tool` command to parse and pretty-print the full JSON schema for parameters, including types, descriptions, and whether they are required.
- **List Resources:** Implement a `list-resources` command to display available resources from connected servers, another key feature of the MCP specification.

### Tier 2: Robustness & Testing
- **Unit Tests:** Add JUnit tests for the `ParameterParser` to ensure it correctly handles various argument formats.
- **Integration Tests:** Create integration tests for the `CliRunner` using Spring Boot's testing framework (`@SpringBootTest`) and `MockBean` to verify command logic without needing live servers.
- **Graceful Disconnect Handling:** Improve the `status` command to more gracefully handle servers that disconnect during a session.

### Tier 3: Advanced CLI Features
- **Command History:** Use a library like JLine to provide persistent command history (using up/down arrows).
- **Auto-Completion:** Implement tab-completion for commands and discovered tool names.
- **Alias Support:** Allow users to create short aliases for frequently used commands (e.g., `alias lt=list-tools`).

### Tier 4: Broader MCP Support
- **Streaming Tool Calls:** For tools that support streaming responses, update `invoke-tool` to handle and display the stream of events correctly.
- **Authentication:** Add support for connecting to secure MCP servers that require authentication tokens or other credentials.

---

This plan provides a clear overview of our progress and a solid roadmap for future development. The client is now a functional and valuable tool for any MCP developer.