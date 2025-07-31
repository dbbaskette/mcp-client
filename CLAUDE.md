# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a general-purpose MCP (Model Context Protocol) Client built with Spring AI that can test both STDIO and SSE servers. It's designed as a tool for MCP Server developers to validate their implementations.

**Tech Stack:**
- Java 21
- Spring Boot 3.5.3
- Spring AI 1.0.0
- WebFlux (reactive programming)
- Maven

## Architecture

**High-Level Architecture:**
- Command-line MCP client application
- Spring Boot application with WebFlux reactive support
- Configuration-driven MCP server connections
- Support for multiple concurrent MCP server connections

**Key Components:**
- `Application.java`: Main Spring Boot application with CommandLineRunner
- `ChatClient.Builder`: AI chat client with MCP tool integration
- `ToolCallbackProvider`: Bridges MCP server tools to Spring AI
- Configuration-based transport layer selection

**Directory Structure:**
- `src/main/java/com/baskettecase/mcpclient/`: Main application source
- `src/main/resources/`: Configuration files
- `docs/`: Project documentation

## MCP Transport Type Determination

Spring AI's MCP client uses **configuration-driven transport selection**:

### Transport Selection Logic

1. **Dependency-Based**: The Maven starter determines available transports
   - `spring-ai-starter-mcp-client-webflux`: Enables WebFlux SSE + STDIO
   - `spring-ai-starter-mcp-client`: Enables HTTP SSE + STDIO

2. **Configuration Namespace**: Property prefixes determine transport type
   ```properties
   # STDIO Transport (process-based)
   spring.ai.mcp.client.stdio.connections.{name}.command=npx
   spring.ai.mcp.client.stdio.connections.{name}.args=-y,@server-package
   
   # SSE Transport (WebFlux-based)
   spring.ai.mcp.client.sse.connections.{name}.url=http://localhost:8080
   spring.ai.mcp.client.sse.connections.{name}.sse-endpoint=/events
   
   # Streamable HTTP Transport
   spring.ai.mcp.client.streamable-http.connections.{name}.url=http://localhost:8080
   ```

3. **Auto-Configuration Classes**:
   - `StdioTransportAutoConfiguration`: Always available
   - `SseWebFluxTransportAutoConfiguration`: Requires WebFlux classes
   - `StreamableHttpWebFluxTransportAutoConfiguration`: Requires WebClient

4. **Multiple Transports**: Framework supports simultaneous connection types

## Common Development Commands

### Build and Run
```bash
# Clean build
./mvnw clean install

# Run with default question
java -jar target/mcp-starter-webflux-client-0.0.1-SNAPSHOT.jar

# Run with custom question
java -Dai.user.input='Your question here' -jar target/mcp-starter-webflux-client-0.0.1-SNAPSHOT.jar

# Run directly with Maven
./mvnw spring-boot:run -Dai.user.input='Your question here'

# Create mcp-client script (future enhancement)
# ./mcp-client --question "What tools are available?" --server brave-search
```

### Testing
```bash
# Run all tests
./mvnw test

# Run specific test
./mvnw test -Dtest=ApplicationTest

# Run with test profile
./mvnw test -Dspring.profiles.active=test
```

## Configuration

### Environment Variables
- `ANTHROPIC_API_KEY`: Required for Claude integration
- `OPENAI_API_KEY`: Optional, for OpenAI integration
- `BRAVE_API_KEY`: Required for Brave Search MCP server

### Key Configuration Patterns

**MCP Client Configuration:**
```properties
# Enable tool callback integration
spring.ai.mcp.client.toolcallback.enabled=true

# Client type (SYNC or ASYNC)
spring.ai.mcp.client.type=SYNC

# Application settings
spring.main.web-application-type=none
ai.user.input=What tools are available?
```

**STDIO Server Example:**
```properties
spring.ai.mcp.client.stdio.connections.brave-search.command=npx
spring.ai.mcp.client.stdio.connections.brave-search.args=-y,@modelcontextprotocol/server-brave-search
spring.ai.mcp.client.stdio.connections.brave-search.env.BRAVE_API_KEY=${BRAVE_API_KEY}
```

**SSE Server Example:**
```properties
spring.ai.mcp.client.sse.connections.my-server.url=http://localhost:8080
spring.ai.mcp.client.sse.connections.my-server.sse-endpoint=/mcp/events
```

## Development Patterns

### Adding New MCP Server Connections
1. Choose transport type (STDIO, SSE, or Streamable HTTP)
2. Add connection configuration with appropriate namespace prefix
3. Set required environment variables for the MCP server
4. Spring AI automatically discovers and integrates the tools

### Application Lifecycle Pattern
```java
@Bean
public CommandLineRunner predefinedQuestions(ChatClient.Builder chatClientBuilder, 
                                           ToolCallbackProvider tools,
                                           ConfigurableApplicationContext context) {
    return args -> {
        var chatClient = chatClientBuilder
                .defaultToolCallbacks(tools)
                .build();
        
        // Process user input with MCP tools
        String response = chatClient.prompt(userInput).call().content();
        System.out.println(">>> ASSISTANT: " + response);
        
        context.close(); // Auto-shutdown after processing
    };
}
```

## Coding Standards & Conventions

- **Code Style**: Spring Java conventions
- **Error Handling**: Use Spring Boot's exception handling patterns
- **Logging**: Use SLF4J with appropriate log levels
- **Configuration**: Externalize all configuration via properties files
- **Security**: Never commit API keys; use environment variables

## Important Guidelines

**DO:**
- Write unit tests for all new business logic
- Log important events and errors with appropriate levels
- Use configuration properties for all external dependencies
- Follow reactive programming patterns when using WebFlux

**DON'T:**
- Commit secrets or API keys to repository
- Hardcode server URLs or connection parameters
- Block reactive streams with synchronous operations

## AI Assistant Core Guidelines

### Persona
You are an expert-level Spring and Java developer focused on MCP client development.

### Development Workflow: Research → Plan → Implement → Validate
1. **Research:** Understand existing MCP patterns and Spring AI architecture
2. **Plan:** Propose clear implementation approach for MCP integration
3. **Implement:** Build features with proper Spring Boot patterns
4. **Validate:** Always run tests and verify MCP connections work

### Code Organization Principles
- **Small Functions**: Split complex MCP connection logic into focused methods
- **Clear Packaging**: Group MCP transport types into intuitive packages
- **Configuration-Driven**: Use Spring Boot properties for all MCP server configs

### Architecture Guidelines
- **Explicit Dependencies**: Clear MCP transport and tool dependencies
- **Reactive Patterns**: Use WebFlux patterns for SSE connections
- **Tool Integration**: Leverage Spring AI's ToolCallbackProvider pattern

## Troubleshooting

### Common Issues
- **Missing API Keys**: Verify all required environment variables are set
- **STDIO Connection Failures**: Ensure Node.js and npm packages are available
- **SSE Connection Issues**: Verify target server is running and accessible
- **Tool Discovery Problems**: Check MCP server tool registration and permissions
- **WebFlux Blocking**: Avoid blocking operations in reactive chains