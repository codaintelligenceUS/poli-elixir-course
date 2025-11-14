defmodule PatternMatch do
  @moduledoc """
  Practice pattern matching with function clauses, tuples, and maps.
  """

  @doc """
  Parses HTTP-style response tuples.

  ## Examples

      iex> PatternMatch.parse_response({:ok, "data loaded"})
      "Success: data loaded"

      iex> PatternMatch.parse_response({:error, "not found"})
      "Error: not found"

      iex> PatternMatch.parse_response({:redirect, "https://example.com"})
      "Redirecting to https://example.com"

      iex> PatternMatch.parse_response(:invalid)
      "Unknown response"
  """
  @spec parse_response(tuple() | atom()) :: String.t()
  def parse_response(response) do
    raise "Not implemented"
  end

  @doc """
  Extracts user information from a map.

  ## Examples

      iex> PatternMatch.extract_user(%{name: "Alice", age: 30})
      "Alice is 30 years old"

      iex> PatternMatch.extract_user(%{name: "Bob", age: 25})
      "Bob is 25 years old"

      iex> PatternMatch.extract_user(%{name: "Charlie"})
      "Invalid user data"

      iex> PatternMatch.extract_user(%{age: 40})
      "Invalid user data"
  """
  @spec extract_user(map()) :: String.t()
  def extract_user(map) do
    raise "Not implemented"
  end
end
