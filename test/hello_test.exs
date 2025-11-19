defmodule ElixirBeginnerCourse.HelloTest do
  use ExUnit.Case, async: true

  alias ElixirBeginnerCourse.Hello
  doctest ElixirBeginnerCourse.Hello

  describe "greet/1" do
    test "basic" do
      assert "Hello, Alice!" == Hello.greet("alice")
    end

    test "trims" do
      assert "Hello, Bob!" == Hello.greet("  Bob")
    end

    @tag :skip
    test "empty -> world" do
      assert "Hello, world!" == Hello.greet("   ")
    end
  end
end
