# Performance Optimizations in Pact Stub Server

This document outlines the performance optimizations implemented to improve the Pact Stub Server's response time and throughput, especially for high-volume API stub scenarios.

## Implemented Optimizations

1. **Method+Path Indexing**
   - Created an `InteractionIndex` structure to organize interactions for fast lookups
   - Implemented exact method+path matching using a HashMap lookup (O(1) complexity)
   - Precomputed path contexts during server initialization to avoid redundant calculations

2. **Early Bailout Optimizations**
   - Fast-track OPTIONS requests for CORS to avoid unnecessary matching
   - Implemented progressive filtering:
     - First filter by method and path (cheapest operations)
     - Then filter by provider state
     - Only perform full request matching on the best candidates

3. **Parallel Processing**
   - Used `FuturesUnordered` for concurrent matching of candidate interactions
   - Process multiple potential matches simultaneously for faster response times

4. **Memory Usage Improvements**
   - Reduced cloning of pacts and interactions
   - Used indices to reference interactions instead of cloning entire objects
   - Extracted lightweight provider state information for faster filtering

## Testing Performance

To test these optimizations:

1. **Build the optimized server**:
   ```bash
   cargo build --release
   ```

2. **Run performance tests**:
   ```bash
   # Create a test with many interactions
   mkdir -p test-pacts
   # Generate or copy pact files to test-pacts/
   
   # Run original implementation
   ./target/release/pact-stub-server -d test-pacts -p 8080
   
   # In another terminal, run JMeter or curl to measure performance
   ab -n 10000 -c 10 http://localhost:8080/path-to-test
   ```

3. **Measure improvement metrics**:
   - Response time (especially for high volume)
   - Throughput (requests per second)
   - Memory usage under load

## Expected Improvements

The optimizations should be particularly noticeable in these scenarios:

1. **Large number of pact files** - Index avoids scanning all pacts
2. **Complex provider state filtering** - Faster filtering through indexed states
3. **High concurrency** - Parallel matching improves throughput
4. **Repeated patterns/paths** - Exact method+path lookups avoid redundant matching

## Configuration

No additional configuration is needed to use the optimized implementation. The optimizations are automatically applied while maintaining 100% compatibility with the existing API.

If performance problems persist in specific scenarios, consider:

- Reducing the number of pact files by combining related ones
- Ensuring pact files have distinct provider states
- Testing with different JVM memory settings if running in JVM environments