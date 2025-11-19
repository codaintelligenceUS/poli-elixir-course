defmodule ElixirBeginnerCourse.GenServer.TTLCache do
  @moduledoc """
  A simple TTL key/value cache implemented using a GenServer.

  Keys expire using scheduled messages (`Process.send_after/3`).
  """

  use GenServer

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Store a key/value pair for a given TTL in milliseconds.

  This is a synchronous operation - waits for confirmation.
  If the key already exists, overwrites it and cancels the old timer.

  ## Examples

      iex> {:ok, cache} = TTLCache.start_link()
      iex> TTLCache.put(cache, :user_id, 123, 5000)
      :ok
  """
  @spec put(GenServer.server(), term(), term(), non_neg_integer()) :: :ok
  def put(_server \\ __MODULE__, _key, _value, _ttl_ms) do
    raise "not implemented"
  end

  @doc """
  Fetch a key. Returns `{:ok, value}` or `:error`.

  This is a synchronous operation.

  ## Examples

      iex> {:ok, cache} = TTLCache.start_link()
      iex> TTLCache.put(cache, :key, "value", 1000)
      iex> TTLCache.get(cache, :key)
      {:ok, "value"}
      iex> TTLCache.get(cache, :missing)
      :error
  """
  @spec get(GenServer.server(), term()) :: {:ok, term()} | :error
  def get(_server \\ __MODULE__, _key) do
    raise "not implemented"
  end

  @doc """
  Asynchronously store a key/value pair. Does not wait for confirmation.

  Useful when you don't need to know if the operation succeeded.

  ## Examples

      iex> {:ok, cache} = TTLCache.start_link()
      iex> TTLCache.put_async(cache, :key, "value", 1000)
      :ok
  """
  @spec put_async(GenServer.server(), term(), term(), non_neg_integer()) :: :ok
  def put_async(_server \\ __MODULE__, _key, _value, _ttl_ms) do
    raise "not implemented"
  end

  @doc """
  Asynchronously delete a key. Does not wait for confirmation.

  Cancels the timer if the key exists.

  ## Examples

      iex> {:ok, cache} = TTLCache.start_link()
      iex> TTLCache.put(cache, :key, "value", 1000)
      iex> TTLCache.delete(cache, :key)
      :ok
  """
  @spec delete(GenServer.server(), term()) :: :ok
  def delete(_server \\ __MODULE__, _key) do
    raise "not implemented"
  end

  @doc """
  Asynchronously clear all entries. Does not wait for confirmation.

  Cancels all active timers.

  ## Examples

      iex> {:ok, cache} = TTLCache.start_link()
      iex> TTLCache.clear(cache)
      :ok
  """
  @spec clear(GenServer.server()) :: :ok
  def clear(_server \\ __MODULE__) do
    raise "not implemented"
  end

  # Server callbacks

  @impl true
  def init(:ok) do
    # map: %{key => {value, timer_ref}}
    {:ok, %{}}
  end

  @impl true
  def handle_call({:put, _key, _value, _ttl_ms}, _from, _state) do
    # TODO:
    # 1. Check if key exists and cancel old timer if present
    # 2. Schedule a new expiration message with Process.send_after/3
    # 3. Store {value, timer_ref} in state
    # 4. Reply with :ok
    raise "not implemented"
  end

  @impl true
  def handle_call({:get, _key}, _from, _state) do
    # TODO:
    # 1. Look up the key in state
    # 2. Return {:ok, value} if found, :error otherwise
    # 3. Don't modify state
    raise "not implemented"
  end

  @impl true
  def handle_cast({:put, _key, _value, _ttl_ms}, _state) do
    # TODO: Same logic as handle_call(:put, ...) but:
    # 1. Use {:noreply, new_state} instead of {:reply, :ok, new_state}
    # 2. This is the async version - no reply needed
    raise "not implemented"
  end

  @impl true
  def handle_cast({:delete, _key}, _state) do
    # TODO:
    # 1. Check if key exists and cancel timer if present
    # 2. Remove key from state
    # 3. Return {:noreply, new_state}
    raise "not implemented"
  end

  @impl true
  def handle_cast(:clear, _state) do
    # TODO:
    # 1. Cancel all active timers (iterate through state)
    # 2. Return empty state: {:noreply, %{}}
    raise "not implemented"
  end

  @impl true
  def handle_info({:expire, _key}, _state) do
    raise "not implemented"
  end
end
