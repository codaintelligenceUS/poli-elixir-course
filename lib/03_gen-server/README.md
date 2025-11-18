# GenServer TTL Cache

**Learning goals**
- Understand basic GenServer lifecycle
- Store key/value pairs with expiration (TTL)
- Use `Process.send_after/3` for scheduled cleanup
- Test GenServers with `start_supervised!/1`

**Your task**
Implement a small TTL cache backed by a GenServer.

Create a module `TTLCache` with:

### Required functions
- `start_link(opts)` – starts the GenServer  
- `put(key, value, ttl_ms)` – stores the value for `ttl_ms` milliseconds  
- `get(key)` – returns `{:ok, value}` or `:error` if missing  
- automatic removal of expired entries

### Behaviors
- When a key is inserted, schedule its expiration using `Process.send_after/3`
- When the timer fires, remove the expired key
- Keys should only expire after the full TTL

## Running
```bash
mix test lib/02_gen-server
```