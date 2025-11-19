defmodule ElixirBeginnerCourse.ProcessesTest do
  use ExUnit.Case, async: true

  alias ElixirBeginnerCourse.Processes
  doctest ElixirBeginnerCourse.Processes

  describe "ping_pong/0" do
    @tag :skip
    test "spawns two processes" do
      {pid1, pid2} = Processes.ping_pong()

      assert is_pid(pid1)
      assert is_pid(pid2)
      assert pid1 != pid2
    end

    @tag :skip
    test "processes exchange messages" do
      {pid1, pid2} = Processes.ping_pong()

      # Give processes time to exchange messages
      Process.sleep(50)

      # At least one should have completed
      refute Process.alive?(pid1) and Process.alive?(pid2)
    end
  end
end
