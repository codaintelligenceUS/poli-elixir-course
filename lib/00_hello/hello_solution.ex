defmodule ElixirBeginnerCourse.Solution.Hello do
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
    name
    |> String.trim()
    |> format_greeting()
  end

  defp format_greeting(""), do: "Hello, world!"
  defp format_greeting(name), do: "Hello, #{String.capitalize(name)}!"
end
