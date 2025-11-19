defmodule ElixirBeginnerCourse.GenServer.Solution.TTLCache do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Synchronous operations (wait for response)
  def put(server \\ __MODULE__, key, value, ttl_ms) do
    GenServer.call(server, {:put, key, value, ttl_ms})
  end

  def get(server \\ __MODULE__, key) do
    GenServer.call(server, {:get, key})
  end

  # Asynchronous operations (fire-and-forget)

  @doc """
  Asynchronously store a key/value pair. Does not wait for confirmation.
  """
  def put_async(server \\ __MODULE__, key, value, ttl_ms) do
    GenServer.cast(server, {:put, key, value, ttl_ms})
  end

  @doc """
  Asynchronously delete a key. Does not wait for confirmation.
  """
  def delete(server \\ __MODULE__, key) do
    GenServer.cast(server, {:delete, key})
  end

  @doc """
  Asynchronously clear all entries. Does not wait for confirmation.
  """
  def clear(server \\ __MODULE__) do
    GenServer.cast(server, :clear)
  end

  # Callbacks

  @impl true
  def init(:ok), do: {:ok, %{}}

  @impl true
  def handle_call({:put, key, value, ttl_ms}, _from, state) do
    # Cancel old timer if key already exists
    state =
      case Map.get(state, key) do
        {_old_val, old_ref} when is_reference(old_ref) ->
          Process.cancel_timer(old_ref)
          state

        _ ->
          state
      end

    timer = Process.send_after(self(), {:expire, key}, ttl_ms)
    new_state = Map.put(state, key, {value, timer})

    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    reply =
      case Map.get(state, key) do
        {value, _ref} -> {:ok, value}
        nil -> :error
      end

    {:reply, reply, state}
  end

  @impl true
  def handle_cast({:put, key, value, ttl_ms}, state) do
    # Cancel old timer if key already exists
    state =
      case Map.get(state, key) do
        {_old_val, old_ref} when is_reference(old_ref) ->
          Process.cancel_timer(old_ref)
          state

        _ ->
          state
      end

    timer = Process.send_after(self(), {:expire, key}, ttl_ms)
    new_state = Map.put(state, key, {value, timer})

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:delete, key}, state) do
    new_state =
      case Map.get(state, key) do
        {_value, timer_ref} when is_reference(timer_ref) ->
          Process.cancel_timer(timer_ref)
          Map.delete(state, key)

        _ ->
          Map.delete(state, key)
      end

    {:noreply, new_state}
  end

  @impl true
  def handle_cast(:clear, state) do
    # Cancel all timers before clearing
    Enum.each(state, fn
      {_key, {_value, timer_ref}} when is_reference(timer_ref) ->
        Process.cancel_timer(timer_ref)

      _ ->
        :ok
    end)

    {:noreply, %{}}
  end

  @impl true
  def handle_info({:expire, key}, state) do
    new_state = Map.delete(state, key)
    {:noreply, new_state}
  end
end
