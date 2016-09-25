# Klausurenarchiv
A simple web app to share exams.

## Config

Set the path where uploads are stored in `config.exs`
```elixir
config :klausurenarchiv, :store,
  path: "/storage"
```

Set the list of facebook id's of the initial set of admins in `config.exs`.
```elixir
config :klausurenarchiv, :users,
  initial_admins: ["12345678910111213"]
```
Note that the IDs have to be set before the users logs in the first time.

## Release

To build a release on a Mac or a Windows PC you have to setup a Docker container
that mimics the production environment. To create such a container run this in
the project directory:
```
$ docker run --name=kabuild -v `pwd`:`pwd` -w `pwd` --env MIX_ENV=prod -dt elixir:1.3 bash
$ docker exec kabuild mix local.hex --force
```

Now you can use the `kabuild` container to exec the normal exrm commands. So after bumping the
version number just run:

``` 
$ ./node_modules/brunch/bin/brunch build --production
$ docker exec kabuild mix phoenix.digest
$ docker exec kabuild mix compile
$ docker exec kabuild mix release
```
