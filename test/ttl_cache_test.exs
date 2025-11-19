defmodule ElixirBeginnerCourse.GenServer.TTLCacheTest do
  use ExUnit.Case, async: false

  alias ElixirBeginnerCourse.GenServer.TTLCache

  # Notice: async: false — timing tests shouldn't run concurrently

  describe "put/4 and get/2 (synchronous)" do
    test "stores and retrieves values" do
      start_supervised!({TTLCache, []})

      assert :ok == TTLCache.put(:a, 123, 100)
      assert {:ok, 123} == TTLCache.get(:a)
    end

    test "overwrites existing values" do
      start_supervised!({TTLCache, []})

      TTLCache.put(:key, "old", 1000)
      TTLCache.put(:key, "new", 1000)

      assert {:ok, "new"} == TTLCache.get(:key)
    end

    test "stores different types of values" do
      start_supervised!({TTLCache, []})

      TTLCache.put(:string, "hello", 100)
      TTLCache.put(:number, 42, 100)
      TTLCache.put(:list, [1, 2, 3], 100)
      TTLCache.put(:map, %{name: "Alice"}, 100)

      assert {:ok, "hello"} == TTLCache.get(:string)
      assert {:ok, 42} == TTLCache.get(:number)
      assert {:ok, [1, 2, 3]} == TTLCache.get(:list)
      assert {:ok, %{name: "Alice"}} == TTLCache.get(:map)
    end

    test "returns :error for non-existent keys" do
      start_supervised!({TTLCache, []})

      assert :error == TTLCache.get(:missing)
    end

    @tag :slow
    test "expires keys after ttl" do
      start_supervised!({TTLCache, []})

      TTLCache.put(:a, 123, 50)
      assert {:ok, 123} == TTLCache.get(:a)

      # Wait slightly longer than TTL
      Process.sleep(60)

      assert :error == TTLCache.get(:a)
    end

    @tag :slow
    test "different keys expire independently" do
      start_supervised!({TTLCache, []})

      TTLCache.put(:short, "expires soon", 30)
      TTLCache.put(:long, "stays longer", 100)

      # Short key expires
      Process.sleep(40)
      assert :error == TTLCache.get(:short)
      assert {:ok, "stays longer"} == TTLCache.get(:long)

      # Long key eventually expires
      Process.sleep(70)
      assert :error == TTLCache.get(:long)
    end

    @tag :slow
    test "overwrites cancel old timers" do
      start_supervised!({TTLCache, []})

      # Set with short TTL
      TTLCache.put(:key, "first", 30)

      # Immediately overwrite with longer TTL
      TTLCache.put(:key, "second", 100)

      # Wait past first TTL
      Process.sleep(40)

      # Should still exist (second timer is active)
      assert {:ok, "second"} == TTLCache.get(:key)
    end
  end

  describe "put_async/4 (asynchronous)" do
    test "stores values without waiting" do
      start_supervised!({TTLCache, []})

      assert :ok == TTLCache.put_async(:async_key, "async_value", 100)

      # Give it a moment to process
      Process.sleep(10)

      assert {:ok, "async_value"} == TTLCache.get(:async_key)
    end

    @tag :slow
    test "async put respects TTL" do
      start_supervised!({TTLCache, []})

      TTLCache.put_async(:temp, "expires", 50)
      Process.sleep(10)
      assert {:ok, "expires"} == TTLCache.get(:temp)

      Process.sleep(50)
      assert :error == TTLCache.get(:temp)
    end
  end

  describe "delete/2" do
    test "removes existing keys" do
      start_supervised!({TTLCache, []})

      TTLCache.put(:to_delete, "value", 1000)
      assert {:ok, "value"} == TTLCache.get(:to_delete)

      TTLCache.delete(:to_delete)
      Process.sleep(10)

      assert :error == TTLCache.get(:to_delete)
    end

    test "handles deleting non-existent keys gracefully" do
      start_supervised!({TTLCache, []})

      assert :ok == TTLCache.delete(:does_not_exist)
    end

    test "cancels timers when deleting" do
      start_supervised!({TTLCache, []})

      TTLCache.put(:key, "value", 1000)
      TTLCache.delete(:key)

      # Wait to ensure timer would have fired if not cancelled
      Process.sleep(1100)

      # Key should still not exist
      assert :error == TTLCache.get(:key)
    end
  end

  describe "clear/1" do
    test "removes all entries" do
      start_supervised!({TTLCache, []})

      TTLCache.put(:key1, "value1", 1000)
      TTLCache.put(:key2, "value2", 1000)
      TTLCache.put(:key3, "value3", 1000)

      TTLCache.clear()
      Process.sleep(10)

      assert :error == TTLCache.get(:key1)
      assert :error == TTLCache.get(:key2)
      assert :error == TTLCache.get(:key3)
    end

    test "clears empty cache without error" do
      start_supervised!({TTLCache, []})

      assert :ok == TTLCache.clear()
    end

    test "cancels all timers when clearing" do
      start_supervised!({TTLCache, []})

      TTLCache.put(:a, 1, 1000)
      TTLCache.put(:b, 2, 1000)

      TTLCache.clear()

      # Wait to ensure timers would have fired
      Process.sleep(1100)

      # Keys should still not exist
      assert :error == TTLCache.get(:a)
      assert :error == TTLCache.get(:b)
    end
  end

  describe "concurrent operations" do
    test "handles multiple simultaneous puts" do
      start_supervised!({TTLCache, []})

      tasks =
        for i <- 1..10 do
          Task.async(fn ->
            TTLCache.put(:"key#{i}", i, 1000)
          end)
        end

      Task.await_many(tasks)

      for i <- 1..10 do
        assert {:ok, ^i} = TTLCache.get(:"key#{i}")
      end
    end

    test "handles mixed operations" do
      start_supervised!({TTLCache, []})

      # Pre-populate
      TTLCache.put(:existing, "value", 1000)

      tasks = [
        Task.async(fn -> TTLCache.put(:new1, 1, 1000) end),
        Task.async(fn -> TTLCache.get(:existing) end),
        Task.async(fn -> TTLCache.put_async(:new2, 2, 1000) end),
        Task.async(fn -> TTLCache.delete(:existing) end)
      ]

      Task.await_many(tasks)
      Process.sleep(20)

      # After mixed operations
      assert {:ok, 1} == TTLCache.get(:new1)
      assert {:ok, 2} == TTLCache.get(:new2)
      assert :error == TTLCache.get(:existing)
    end
  end
end
