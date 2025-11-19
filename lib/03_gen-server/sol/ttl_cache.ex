defmodule ElixirBeginnerCourse.GenServer.Solution.TTLCache do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def put(server \\ __MODULE__, key, value, ttl_ms) do
    GenServer.call(server, {:put, key, value, ttl_ms})
  end

  def get(server \\ __MODULE__, key) do
    GenServer.call(server, {:get, key})
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
  def handle_info({:expire, key}, state) do
    new_state = Map.delete(state, key)
    {:noreply, new_state}
  end
end
