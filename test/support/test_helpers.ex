defmodule Klausurenarchiv.TestHelpers do
    alias Klausurenarchiv.Repo
    
    import Plug.Conn, only: [assign: 3]

    def insert_user(attrs \\ %{}) do
        changes = Dict.merge(%{
            email: "mail@example.com",
            fb_id: "12345678910111213",
            first_name: "First",
            last_name: "Last",
            name: "First Last",
            is_admin: false
        }, attrs)
        
        %Klausurenarchiv.User{}
        |> Klausurenarchiv.User.changeset(changes)
        |> Repo.insert!
    end
    
    def setup_login(%{conn: conn} = config) do
        cond do
        name = config[:login_as] ->
            user = insert_user(name: name)
            conn = assign(conn, :current_user, user)
            {:ok, conn: conn, user: user}
        name = config[:login_as_admin] ->
            user = insert_user(%{name: name, is_admin: true})
            conn = assign(conn, :current_user, user)
            {:ok, conn: conn, user: user}
        true ->
            :ok
        end
    end
    
end