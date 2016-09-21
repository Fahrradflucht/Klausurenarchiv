# Klausurenarchiv
A simple web app to share exams.

DISCLAIMER: The app is currently coded in English but all strings are inlined and in German.

## Setup

Set the path where uploads are stored in `config.exs`
```elixir
config :klausurenarchiv, :store,
  path: "/storage"
```

Set the list of facebook id's of the initial set of admins in `config.exs`
```
config :klausurenarchiv, :users,
  initial_admins: ["12345678910111213"]
```
