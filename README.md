# Interactive MCP Client

A general-purpose, interactive Model Context Protocol (MCP) client built with Spring AI for testing and interacting with MCP servers. This tool helps MCP server developers validate their implementations by providing a flexible, LLM-free client that supports multiple transport protocols.

## 🚀 Quick Start

```bash
# Run with the default STDIO profile
./mcp-client.sh

# Test SSE servers
./mcp-client.sh --profile sse
```

## 📋 Features

- **Multiple Transport Protocols**: Supports STDIO, SSE (Server-Sent Events), and Streamable HTTP
- **Spring Profile-Based Configuration**: Clean separation of transport configurations
- **AI Provider Integration**: Works with Anthropic Claude and OpenAI
- **Command-Line Interface**: Easy-to-use script for testing MCP servers
- **Extensible**: Add new MCP server configurations easily

## 🏗️ Architecture

This project is built on:
- **Java 21** - Modern Java features
- **Spring Boot 3.3.2** - Application framework
- **Spring AI 1.0.0** - AI integration and MCP client capabilities
- **WebFlux** - Reactive programming for SSE connections
- **Maven** - Build and dependency management

### Transport Types

| Transport | Description | Use Case |
|-----------|-------------|----------|
| **STDIO** | Process-based communication | Testing npm/node MCP servers |
| **SSE** | Server-Sent Events over HTTP | Web-based MCP servers |
| **Streamable HTTP** | HTTP with streaming responses | RESTful MCP servers |

## 🛠️ Installation & Setup

### Prerequisites

- Java 21 or later
- Maven 3.6+
- Node.js (for STDIO MCP servers)
- API Keys:
  - [Anthropic API Key](https://docs.anthropic.com/en/docs/initial-setup) (required)
  - [Brave Search API Key](https://brave.com/search/api/) (for Brave Search server)
  - [OpenAI API Key](https://platform.openai.com/api-keys) (optional)

### Environment Variables

```bash
# Required
export ANTHROPIC_API_KEY=your-anthropic-api-key

# Required for Brave Search MCP server (STDIO profile)
export BRAVE_API_KEY=your-brave-api-key

# Optional for OpenAI integration
export OPENAI_API_KEY=your-openai-api-key
```

### Build

```bash
# Clone and build
git clone <repository-url>
cd mcp-client
./mvnw clean install
```

## 🎯 Usage

### Command Line Interface

The `mcp-client` script provides a convenient interface:

```bash
./mcp-client [OPTIONS]

OPTIONS:
    -p, --profile PROFILE       Transport profile: stdio, sse, streamable (default: stdio)
    -q, --question QUESTION     Question to ask the MCP server
    -h, --help                  Show help message
    -v, --verbose               Enable verbose output
    --no-build                  Skip building if JAR is missing
    --build                     Force rebuild before running
```

### Examples

```bash
# Basic usage with STDIO (default)
./mcp-client

# Test with custom question
./mcp-client --question "What tools do you provide?"

# Test SSE servers
./mcp-client --profile sse

# Verbose output for debugging
./mcp-client --verbose --question "List available functions"

# Force rebuild and run
./mcp-client --build --profile stdio
```

### Direct Java Execution

```bash
# STDIO profile
java -jar target/mcp-starter-webflux-client-0.0.1-SNAPSHOT.jar \
  --spring.profiles.active=stdio \
  -Dai.user.input="What tools are available?"

# SSE profile
java -jar target/mcp-starter-webflux-client-0.0.1-SNAPSHOT.jar \
  --spring.profiles.active=sse \
  -Dai.user.input="Search for Spring Boot tutorials"
```

## ⚙️ Configuration

### Profiles

The application uses Spring profiles to determine transport configuration:

- **`stdio`** - Process-based MCP servers
- **`sse`** - Server-Sent Events MCP servers  
- **`streamable`** - Streamable HTTP MCP servers

### Adding MCP Servers

#### STDIO Servers

Edit `src/main/resources/application-stdio.properties`:

```properties
# Your custom STDIO server
spring.ai.mcp.client.stdio.connections.my-server.command=/path/to/server
spring.ai.mcp.client.stdio.connections.my-server.args=--arg1,value1
spring.ai.mcp.client.stdio.connections.my-server.env.API_KEY=${YOUR_API_KEY}
```

#### SSE Servers

Edit `src/main/resources/application-sse.properties`:

```properties
# Your SSE server
spring.ai.mcp.client.sse.connections.my-sse-server.url=http://localhost:8080
spring.ai.mcp.client.sse.connections.my-sse-server.sse-endpoint=/mcp/events
```

#### Streamable HTTP Servers

Edit `src/main/resources/application-streamable.properties`:

```properties
# Your HTTP server
spring.ai.mcp.client.streamable-http.connections.my-http-server.url=http://localhost:9000
```

### Common Configuration

Base settings in `src/main/resources/application.properties`:

```properties
# Application settings
spring.application.name=mcp-client
ai.user.input=What tools are available?

# MCP Client settings
spring.ai.mcp.client.toolcallback.enabled=true
spring.ai.mcp.client.type=SYNC

# Logging levels
logging.level.org.springframework.ai.mcp=INFO
```

## 🧪 Testing MCP Servers

### Testing Popular MCP Servers

```bash
# Brave Search (included in stdio profile)
./mcp-client --question "Search for MCP documentation"

# File System Server (uncomment in application-stdio.properties)
./mcp-client --question "List files in current directory"

# SQLite Server (uncomment in application-stdio.properties)
./mcp-client --question "Show database tables"
```

### Custom MCP Server Testing

1. **Configure your server** in the appropriate profile properties file
2. **Set environment variables** if your server requires API keys
3. **Run the client** with your profile:

```bash
./mcp-client --profile your-profile --question "Your test question"
```

## 🔧 Development

### Project Structure

```
src/main/java/org/springframework/ai/mcp/samples/client/
├── Application.java                 # Main Spring Boot application
src/main/resources/
├── application.properties           # Common configuration
├── application-stdio.properties     # STDIO transport config
├── application-sse.properties       # SSE transport config
├── application-streamable.properties # HTTP transport config
└── mcp-servers-config.json         # Alternative JSON config format
```

### Building and Running

```bash
# Development build
./mvnw spring-boot:run -Dspring.profiles.active=stdio

# Production build
./mvnw clean install
java -jar target/mcp-starter-webflux-client-0.0.1-SNAPSHOT.jar

# Run tests
./mvnw test
```

### Adding New Transport Types

1. Create new profile configuration file: `application-{profile}.properties`
2. Configure connections using Spring AI MCP client properties
3. Update the `mcp-client` script profile validation if needed

## 🐛 Troubleshooting

### Common Issues

**Missing API Keys**
```bash
# Error: ANTHROPIC_API_KEY environment variable is required
export ANTHROPIC_API_KEY=your-key
```

**STDIO Connection Failures**
```bash
# Ensure Node.js and npm packages are available
node --version
npm list -g @modelcontextprotocol/server-brave-search
```

**SSE Connection Issues**
```bash
# Verify your SSE server is running
curl -N http://localhost:8080/mcp/events
```

**Build Issues**
```bash
# Clean and rebuild
./mvnw clean install
# Or force rebuild via script
./mcp-client --build
```

### Debug Mode

Enable verbose logging:

```bash
# Script verbose mode
./mcp-client --verbose

# Java verbose logging
java -jar target/mcp-starter-webflux-client-0.0.1-SNAPSHOT.jar \
  --spring.profiles.active=stdio \
  --logging.level.org.springframework.ai.mcp=DEBUG
```

## 📚 Documentation

- [Spring AI MCP Documentation](https://docs.spring.io/spring-ai/reference/api/mcp/mcp-client-boot-starter-docs.html)
- [Model Context Protocol Specification](https://modelcontextprotocol.github.io/specification/)
- [Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-transport`
3. Make your changes and add tests
4. Commit with conventional commits: `git commit -m "feat: add new transport type"`
5. Push and create a pull request

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- [GitHub Issues](https://github.com/your-org/mcp-client/issues) - Bug reports and feature requests
- [Spring AI Documentation](https://docs.spring.io/spring-ai/reference/) - Framework documentation
- [MCP Specification](https://modelcontextprotocol.github.io/specification/) - Protocol documentation