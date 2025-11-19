defmodule ElixirBeginnerCourse.Solution.Processes do
  @moduledoc """
  Practice working with Elixir processes, message passing, and concurrency.
  """

  @doc """
  Creates two processes that exchange ping-pong messages.
  """
  @spec ping_pong() :: {pid(), pid()}
  def ping_pong do
    parent = self()

    pid1 =
      spawn(fn ->
        receive do
          {:ping, from} ->
            send(from, :pong)
            send(parent, {:done, self()})
        end
      end)

    pid2 =
      spawn(fn ->
        send(pid1, {:ping, self()})

        receive do
          :pong ->
            send(parent, {:done, self()})
        end
      end)

    {pid1, pid2}
  end
end
