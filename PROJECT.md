# Project Instructions: [PROJECT NAME]

> **Instructions for the User**:
> Fill out this template with details specific to your project.
> The AI assistant will use this file as its primary source of truth for your project's context, goals, and constraints.
> Be as specific as possible.

---

## 1. Project Overview & Goal

*   **What is the primary goal of this project?**
    *   This is meant to general purpose MCP CLient that can be used to test STDIO and SSE Servers.  It is based on the code in this repo, but we should modify where we need to. I would like a mcp-client script that runs it. 
*   **Who are the end-users?**
    *   MCP Server Developers

## 2. Tech Stack

*   **Language(s) & Version(s)**: Java 21
*   **Framework(s)**: Spring Boot 3.5.3
*   **Database(s)**:n/a
*   **Key Libraries**: Spring AI 1.0.0
*   **Build/Package Manager**: MVN and Git


## 3. Architecture & Design

*   **High-Level Architecture**: High level arch shouldnt change
*  
*   **Directory Structure**: Briefly describe the purpose of key directories.
    *   `src/main/java/com/baskettecase/mcpclient/`: Main application source
    *   `src/main/resources/`: Configuration files
    *   `docs/`: Project documentation

## 4. Coding Standards & Conventions

*   **Code Style**: Spring Java

*   **Error Handling**: (e.g., "Use custom exception classes", "Return standardized JSON error responses")

## 5. Important "Do's and Don'ts"

*   **DO**:  "Write unit tests for all new business logic."
*   **DON'T**:  "Do not commit secrets or API keys directly into the repository.
*   **DO**:  "Log important events and errors."