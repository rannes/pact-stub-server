# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Pact Stub Server is a standalone server that generates responses based on pact files. It implements the [V4 Pact specification](https://github.com/pact-foundation/pact-specification/tree/version-4) and works by taking all the interactions (requests and responses) from pact files, comparing incoming requests against those defined in the pact files, and returning appropriate responses when matches are found.

## Common Commands

### Building the Project

```bash
# Build the project in debug mode
cargo build

# Build the project in release mode (for distribution)
cargo build --release
```

### Running Tests

```bash
# Run all tests
cargo test

# Run a specific test
cargo test test_name

# Run CLI tests
cargo test cli_tests
```

### Running the Project

```bash
# Run in debug mode
cargo run -- [OPTIONS]

# Example with common options
cargo run -- --file path/to/pact.json --port 8080
```

### Checking Code Quality

```bash
# Format code using rustfmt
cargo fmt

# Run clippy to check for common issues
cargo clippy
```

## Architecture

The project is structured around these main components:

1. **Main Entry Point** (`src/main.rs`): Handles command-line arguments and bootstraps the server.

2. **Server** (`src/server.rs`): Contains the server implementation that listens for requests and matches them against pact definitions.

3. **Loading** (`src/loading.rs`): Responsible for loading pact files from various sources (files, directories, URLs, Pact broker).

4. **Pact Support** (`src/pact_support.rs`): Utility functions for working with pact models and converting between different request/response formats.

The application flow:
1. Parse command line arguments
2. Load pact files from specified sources
3. Start the server on the specified port
4. For each incoming request:
   - Compare against the loaded pact interactions
   - Return the matching response or a 404 if no match is found

## Tests

The project uses standard Rust tests with the following patterns:
- Unit tests are typically included in the same file as the code being tested
- Integration tests are in the `tests/` directory
- The project uses the `trycmd` crate for testing CLI functionality