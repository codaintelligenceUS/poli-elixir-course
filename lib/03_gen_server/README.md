# GenServer TTL Cache

Build a time-to-live (TTL) cache using GenServer to learn about stateful processes and message handling.

**Learning goals**
- Understand GenServer callbacks and their purposes
- Implement synchronous operations with `handle_call/3`
- Implement asynchronous operations with `handle_cast/2`
- Handle non-GenServer messages with `handle_info/2`
- Manage timers with `Process.send_after/3`

**Your task**
Implement a TTL cache backed by a GenServer where entries automatically expire.

Create a module `ElixirBeginnerCourse.GenServer.TTLCache` with:

### Required functions
- `start_link(opts)` – starts the GenServer  
- `put(server, key, value, ttl_ms)` – stores value, expires after `ttl_ms` milliseconds (synchronous)
- `get(server, key)` – returns `{:ok, value}` or `:error` if missing (synchronous)
- `put_async(server, key, value, ttl_ms)` – async version of put (fire-and-forget)
- `delete(server, key)` – removes a key immediately (asynchronous)
- `clear(server)` – removes all entries (asynchronous)

### Behaviors
- When a key is inserted, schedule expiration using `Process.send_after/3`
- Store each value as `{value, timer_ref}` in state map
- When the timer fires, remove the expired key via `handle_info`
- Overwriting a key must cancel the old timer to prevent leaks
- Deleting or clearing must cancel all affected timers

## Running
```bash
mix test test/ttl_cache_test.exs
```