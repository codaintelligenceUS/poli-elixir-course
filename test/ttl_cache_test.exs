defmodule ElixirBeginnerCourse.GenServer.TTLCacheTest do
  use ExUnit.Case, async: false

  alias ElixirBeginnerCourse.GenServer.TTLCache

  # Notice: async: false — timing tests shouldn't run concurrently

  describe "put/4 and get/2 (synchronous)" do
    test "stores and retrieves values" do
      cache = start_supervised!({TTLCache, []})

      assert :ok == TTLCache.put(cache, :a, 123, 100)
      assert {:ok, 123} == TTLCache.get(cache, :a)
    end

    test "overwrites existing values" do
      cache = start_supervised!({TTLCache, []})

      TTLCache.put(cache, :key, "old", 1000)
      TTLCache.put(cache, :key, "new", 1000)

      assert {:ok, "new"} == TTLCache.get(cache, :key)
    end

    test "stores different types of values" do
      cache = start_supervised!({TTLCache, []})

      TTLCache.put(cache, :string, "hello", 100)
      TTLCache.put(cache, :number, 42, 100)
      TTLCache.put(cache, :list, [1, 2, 3], 100)
      TTLCache.put(cache, :map, %{name: "Alice"}, 100)

      assert {:ok, "hello"} == TTLCache.get(cache, :string)
      assert {:ok, 42} == TTLCache.get(cache, :number)
      assert {:ok, [1, 2, 3]} == TTLCache.get(cache, :list)
      assert {:ok, %{name: "Alice"}} == TTLCache.get(cache, :map)
    end

    test "returns :error for non-existent keys" do
      cache = start_supervised!({TTLCache, []})

      assert :error == TTLCache.get(cache, :missing)
    end

    @tag :slow
    test "expires keys after ttl" do
      cache = start_supervised!({TTLCache, []})

      TTLCache.put(cache, :a, 123, 50)
      assert {:ok, 123} == TTLCache.get(cache, :a)

      # Wait slightly longer than TTL
      Process.sleep(60)

      assert :error == TTLCache.get(cache, :a)
    end

    @tag :slow
    test "different keys expire independently" do
      cache = start_supervised!({TTLCache, []})

      TTLCache.put(cache, :short, "expires soon", 30)
      TTLCache.put(cache, :long, "stays longer", 100)

      # Short key expires
      Process.sleep(40)
      assert :error == TTLCache.get(cache, :short)
      assert {:ok, "stays longer"} == TTLCache.get(cache, :long)

      # Long key eventually expires
      Process.sleep(70)
      assert :error == TTLCache.get(cache, :long)
    end

    @tag :slow
    test "overwrites cancel old timers" do
      cache = start_supervised!({TTLCache, []})

      # Set with short TTL
      TTLCache.put(cache, :key, "first", 30)

      # Immediately overwrite with longer TTL
      TTLCache.put(cache, :key, "second", 100)

      # Wait past first TTL
      Process.sleep(40)

      # Should still exist (second timer is active)
      assert {:ok, "second"} == TTLCache.get(cache, :key)
    end
  end

  describe "put_async/4 (asynchronous)" do
    test "stores values without waiting" do
      cache = start_supervised!({TTLCache, []})

      assert :ok == TTLCache.put_async(cache, :async_key, "async_value", 100)

      # Give it a moment to process
      Process.sleep(10)

      assert {:ok, "async_value"} == TTLCache.get(cache, :async_key)
    end

    @tag :slow
    test "async put respects TTL" do
      cache = start_supervised!({TTLCache, []})

      TTLCache.put_async(cache, :temp, "expires", 50)
      Process.sleep(10)
      assert {:ok, "expires"} == TTLCache.get(cache, :temp)

      Process.sleep(50)
      assert :error == TTLCache.get(cache, :temp)
    end
  end

  describe "delete/2" do
    test "removes existing keys" do
      cache = start_supervised!({TTLCache, []})

      TTLCache.put(cache, :to_delete, "value", 1000)
      assert {:ok, "value"} == TTLCache.get(cache, :to_delete)

      TTLCache.delete(cache, :to_delete)
      Process.sleep(10)

      assert :error == TTLCache.get(cache, :to_delete)
    end

    test "handles deleting non-existent keys gracefully" do
      cache = start_supervised!({TTLCache, []})

      assert :ok == TTLCache.delete(cache, :does_not_exist)
    end

    test "cancels timers when deleting" do
      cache = start_supervised!({TTLCache, []})

      TTLCache.put(cache, :key, "value", 1000)
      TTLCache.delete(cache, :key)

      # Wait to ensure timer would have fired if not cancelled
      Process.sleep(1100)

      # Key should still not exist
      assert :error == TTLCache.get(cache, :key)
    end
  end

  describe "clear/1" do
    test "removes all entries" do
      cache = start_supervised!({TTLCache, []})

      TTLCache.put(cache, :key1, "value1", 1000)
      TTLCache.put(cache, :key2, "value2", 1000)
      TTLCache.put(cache, :key3, "value3", 1000)

      TTLCache.clear(cache)
      Process.sleep(10)

      assert :error == TTLCache.get(cache, :key1)
      assert :error == TTLCache.get(cache, :key2)
      assert :error == TTLCache.get(cache, :key3)
    end

    test "clears empty cache without error" do
      cache = start_supervised!({TTLCache, []})

      assert :ok == TTLCache.clear(cache)
    end

    test "cancels all timers when clearing" do
      cache = start_supervised!({TTLCache, []})

      TTLCache.put(cache, :a, 1, 1000)
      TTLCache.put(cache, :b, 2, 1000)

      TTLCache.clear(cache)

      # Wait to ensure timers would have fired
      Process.sleep(1100)

      # Keys should still not exist
      assert :error == TTLCache.get(cache, :a)
      assert :error == TTLCache.get(cache, :b)
    end
  end

  describe "concurrent operations" do
    test "handles multiple simultaneous puts" do
      cache = start_supervised!({TTLCache, []})

      tasks =
        for i <- 1..10 do
          Task.async(fn ->
            TTLCache.put(cache, :"key#{i}", i, 1000)
          end)
        end

      Task.await_many(tasks)

      for i <- 1..10 do
        assert {:ok, ^i} = TTLCache.get(cache, :"key#{i}")
      end
    end

    test "handles mixed operations" do
      cache = start_supervised!({TTLCache, []})

      # Pre-populate
      TTLCache.put(cache, :existing, "value", 1000)

      tasks = [
        Task.async(fn -> TTLCache.put(cache, :new1, 1, 1000) end),
        Task.async(fn -> TTLCache.get(cache, :existing) end),
        Task.async(fn -> TTLCache.put_async(cache, :new2, 2, 1000) end),
        Task.async(fn -> TTLCache.delete(cache, :existing) end)
      ]

      Task.await_many(tasks)
      Process.sleep(20)

      # After mixed operations
      assert {:ok, 1} == TTLCache.get(cache, :new1)
      assert {:ok, 2} == TTLCache.get(cache, :new2)
      assert :error == TTLCache.get(cache, :existing)
    end
  end
end
