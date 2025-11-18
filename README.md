# Elixir Beginner Course

A hands-on, test-driven learning path for mastering Elixir fundamentals.

## 📚 Overview

This course teaches Elixir through progressive exercises, each building on previous concepts. You'll learn by writing code that passes tests, getting immediate feedback on your understanding.

## 🗂️ Structure

- **Exercises**: Located in `lib/NN_slug/` (e.g., `lib/00_hello/`)
- **Your code**: Edit files in `lib/NN_slug/lib/`
- **Solutions**: Reference implementations in `lib/NN_slug/sol/`
- **Tests**: Run tests from each exercise directory

## 🚀 Getting Started

### Prerequisites

- [mise](https://mise.jdx.dev/) - manages Elixir/Erlang versions (don't forget to [activate mise after installation](https://mise.jdx.dev/getting-started.html#activate-mise))

### Installation

```bash
# Install Elixir and Erlang
mise install

# Verify installation
elixir --version
```

## 💡 How to Learn

1. **Read the module documentation** - understand what you're building
2. **Run the tests** - see what's expected
3. **Implement the function** - make tests pass
4. **Compare with solutions** - review alternative approaches in `sol/`
5. **Move to next exercise** - progress sequentially

## 🎯 Tips

- Tests marked with `@tag :skip` are for later - focus on active tests first
- Use `mix format` to keep your code clean
- Read error messages carefully - they're helpful!
- Experiment in `iex` (Interactive Elixir): `iex -S mix`

## 📖 Resources

- [Elixir Documentation](https://hexdocs.pm/elixir/)
- [Elixir School](https://elixirschool.com/)
- [Exercism Elixir Track](https://exercism.org/tracks/elixir)

## 🤝 Contributing

Found an issue or have suggestions? Open an issue or pull request!
