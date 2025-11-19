defmodule ElixirBeginnerCourse.Processes do
  @moduledoc """
  Practice working with Elixir processes, message passing, and concurrency.
  """

  @doc """
  Creates two processes that exchange ping-pong messages.

  Returns a tuple with both process PIDs.

  ## Examples

      iex> {pid1, pid2} = Processes.ping_pong()
      iex> Process.alive?(pid1) or Process.alive?(pid2)
      true
  """
  @spec ping_pong() :: {pid(), pid()}
  def ping_pong do
    raise "not implemented"
  end
end
