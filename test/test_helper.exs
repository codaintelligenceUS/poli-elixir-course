# Starts ExUnit (the test framework)
ExUnit.start()

# By default, skip tests tagged with :skip
ExUnit.configure(exclude: [:skip])
