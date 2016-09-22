# Klausurenarchiv
A simple web app to share exams.

## Setup

Set the path where uploads are stored in `config.exs`
```elixir
config :klausurenarchiv, :store,
  path: "/storage"
```

Set the list of facebook id's of the initial set of admins in `config.exs`.
```
config :klausurenarchiv, :users,
  initial_admins: ["12345678910111213"]
```
Note that the IDs have to be set before the users logs in the first time.
