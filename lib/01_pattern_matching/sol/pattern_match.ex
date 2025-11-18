defmodule PatternMatchSolution do
  @moduledoc """
  Practice pattern matching with function clauses, tuples, and maps.
  """

  @doc """
  Parses HTTP-style response tuples using pattern matching.
  """
  @spec parse_response(tuple() | atom()) :: String.t()
  def parse_response({:ok, data}), do: "Success: #{data}"
  def parse_response({:error, reason}), do: "Error: #{reason}"
  def parse_response({:redirect, url}), do: "Redirecting to #{url}"
  def parse_response(_), do: "Unknown response"

  @doc """
  Extracts user information from a map using pattern matching.
  """
  @spec extract_user(map()) :: String.t()
  def extract_user(%{name: name, age: age}) do
    "#{name} is #{age} years old"
  end

  def extract_user(_), do: "Invalid user data"
end
