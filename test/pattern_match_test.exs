defmodule ElixirBeginnerCourse.PatternMatchTest do
  use ExUnit.Case, async: true

  alias ElixirBeginnerCourse.Solution.PatternMatch
  doctest ElixirBeginnerCourse.PatternMatch

  describe "parse_response/1" do
    @tag :skip
    test "handles :ok tuple" do
      assert "Success: data loaded" == PatternMatch.parse_response({:ok, "data loaded"})
    end

    @tag :skip
    test "handles :error tuple" do
      assert "Error: not found" == PatternMatch.parse_response({:error, "not found"})
    end

    @tag :skip
    test "handles :redirect tuple" do
      assert "Redirecting to https://example.com" ==
               PatternMatch.parse_response({:redirect, "https://example.com"})
    end

    @tag :skip
    test "handles unknown response" do
      assert "Unknown response" == PatternMatch.parse_response(:invalid)
      assert "Unknown response" == PatternMatch.parse_response({:unknown, "data"})
    end
  end

  describe "extract_user/1" do
    @tag :skip
    test "extracts valid user data" do
      assert "Alice is 30 years old" ==
               PatternMatch.extract_user(%{name: "Alice", age: 30})
    end

    @tag :skip
    test "handles missing age" do
      assert "Invalid user data" == PatternMatch.extract_user(%{name: "Charlie"})
    end

    @tag :skip
    test "handles missing name" do
      assert "Invalid user data" == PatternMatch.extract_user(%{age: 40})
    end

    @tag :skip
    test "handles extra fields" do
      assert "Bob is 25 years old" ==
               PatternMatch.extract_user(%{name: "Bob", age: 25, email: "bob@example.com"})
    end
  end
end
