defmodule TTLCacheTest do
  use ExUnit.Case, async: false

  # Notice: async: false — timing tests shouldn't run concurrently

  describe "ttl cache" do
    test "stores and retrieves values" do
      {:ok, cache} = TTLCache.start_link([])

      assert :ok == TTLCache.put(cache, :a, 123, 100)
      assert {:ok, 123} == TTLCache.get(cache, :a)
    end

    @tag :slow
    test "expires keys after ttl" do
      {:ok, cache} = TTLCache.start_link([])

      TTLCache.put(cache, :a, 123, 50)
      assert {:ok, 123} == TTLCache.get(cache, :a)

      # Wait slightly longer than TTL
      Process.sleep(60)

      assert :error == TTLCache.get(cache, :a)
    end
  end
end
