# Processes
In Elixir, all code runs inside processes. Processes are isolated from each other, run concurrent to one another and communicate via message passing. Processes are not only the basis for concurrency in Elixir, but they also provide the means for building distributed and fault-tolerant programs.

Elixir's processes should not be confused with operating system processes. Processes in Elixir are extremely lightweight in terms of memory and CPU (even compared to threads as used in many other programming languages). Because of this, it is not uncommon to have tens or even hundreds of thousands of processes running simultaneously.

In this chapter, we will learn about the basic constructs for spawning new processes, as well as sending and receiving messages between processes.

**Learning goals**
- Spawn processes with `spawn/1`
- Send and receive messages with `send/2` and `receive`

**Your task**
Implement `Processes.ping_pong/0` that creates two processes that exchange messages.
- Spawn two processes that send `:ping` and `:pong` messages to each other
- Return the tuple `{pid1, pid2}` of the spawned processes

## Running
```bash
mix test test/processes_test.exs
```
