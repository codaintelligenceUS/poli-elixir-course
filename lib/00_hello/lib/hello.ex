defmodule Hello do
  @moduledoc """
  First contact with modules, functions, and doctests.
  """

  @doc """
  Greets someone by name.

  Trims whitespace. Capitalizes only the first character if present.

  ## Examples

      iex> Hello.greet("alice")
      "Hello, Alice!"

      iex> Hello.greet("  Bob")
      "Hello, Bob!"

      iex> Hello.greet("  ")
      "Hello, world!"
  """
  @spec greet(String.t()) :: String.t()
  def greet(name) when is_binary(name) do
    raise "not implemented"
  end
end
