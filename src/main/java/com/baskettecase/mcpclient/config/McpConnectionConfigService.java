package com.baskettecase.mcpclient.config;

import org.springframework.stereotype.Service;

import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Properties;

@Service
public class McpConnectionConfigService {

    private static final Path RESOURCES_PATH = Paths.get("src", "main", "resources");

    public boolean sseConnectionExists(String serverName) throws IOException {
        return connectionExists("sse", "spring.ai.mcp.client.sse.connections." + serverName + ".url");
    }

    public boolean stdioConnectionExists(String serverName) throws IOException {
        return connectionExists("stdio", "spring.ai.mcp.client.stdio.connections." + serverName + ".command");
    }

    private boolean connectionExists(String profile, String key) throws IOException {
        Path propertiesPath = RESOURCES_PATH.resolve("application-" + profile + ".properties");
        if (!Files.exists(propertiesPath)) {
            return false;
        }
        Properties properties = new Properties();
        try (FileReader reader = new FileReader(propertiesPath.toFile())) {
            properties.load(reader);
            return properties.containsKey(key);
        }
    }

    public void addSseConnection(String serverName, String url) throws IOException {
        Path propertiesPath = RESOURCES_PATH.resolve("application-sse.properties");
        if (!Files.exists(propertiesPath)) {
            Files.createFile(propertiesPath);
        }
        String config = String.format(
                "\n# Connection for %s\n" +
                "spring.ai.mcp.client.sse.connections.%s.url=%s\n" +
                "spring.ai.mcp.client.sse.connections.%s.sse-endpoint=/sse\n",
                serverName, serverName, url, serverName);
        Files.writeString(propertiesPath, config, StandardOpenOption.APPEND);
    }

    public void addStdioConnection(String serverName, String jarPath) throws IOException {
        addStdioConnection(serverName, jarPath, null);
    }

    public void addStdioConnection(String serverName, String jarPath, String profile) throws IOException {
        Path propertiesPath = RESOURCES_PATH.resolve("application-stdio.properties");
        if (!Files.exists(propertiesPath)) {
            Files.createFile(propertiesPath);
        }
        
        // Use provided profile or default to "stdio" if none specified
        String springProfile = (profile != null && !profile.trim().isEmpty()) ? profile : "stdio";
        
        String config = String.format(
                "\n# Connection for %s\n" +
                "spring.ai.mcp.client.stdio.connections.%s.command=java\n" +
                "spring.ai.mcp.client.stdio.connections.%s.args=-Dspring.profiles.active=%s,-jar,%s\n",
                serverName, serverName, serverName, springProfile, jarPath);
        Files.writeString(propertiesPath, config, StandardOpenOption.APPEND);
    }
}