# Pattern Matching
`=` in Elixir is called the match operator. As it turns out, it can do much more than just a simple assignment! [Read More](https://hexdocs.pm/elixir/pattern-matching.html)

**Learning goals**
- Understand the match operator `=`
- Use pattern matching with function clauses
- Match on tuples and atoms

**Your task**
Implement `PatternMatch.parse_response/1` that parses HTTP-style response tuples.
- Match on `{:ok, data}` tuples and return `"Success: <data>"`
- Match on `{:error, reason}` tuples and return `"Error: <reason>"`
- Match on `{:redirect, url}` tuples and return `"Redirecting to <url>"`
- Match on any other value and return `"Unknown response"`

Implement `PatternMatch.extract_user/1` that extracts user info from maps.
- Match on `%{name: name, age: age}` and return `"<name> is <age> years old"`
- Handle missing keys by returning `"Invalid user data"`

## Running
```bash
mix test test/pattern_match_test.exs
```
