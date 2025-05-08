#!/bin/bash
# Script to run the optimized pact-stub-server from source

# First build the project
cargo build --release

# Run the server with the provided arguments
./target/release/pact-stub-server "$@"