defmodule TTLCache do
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
  """
  @spec put(GenServer.server(), term(), term(), non_neg_integer()) :: :ok
  def put(server \\ __MODULE__, key, value, ttl_ms) do
    raise "not implemented"
  end

  @doc """
  Fetch a key. Returns {:ok, value} or :error.
  """
  @spec get(GenServer.server(), term()) :: {:ok, term()} | :error
  def get(server \\ __MODULE__, key) do
    raise "not implemented"
  end

  # Server callbacks

  @impl true
  def init(:ok) do
    # map: %{key => {value, timer_ref}}
    {:ok, %{}}
  end

  @impl true
  def handle_call({:put, key, value, ttl_ms}, _from, state) do
    raise "not implemented"
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    raise "not implemented"
  end

  @impl true
  def handle_info({:expire, key}, state) do
    raise "not implemented"
  end
end
