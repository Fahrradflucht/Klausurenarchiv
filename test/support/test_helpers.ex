defmodule Klausurenarchiv.TestHelpers do
    alias Klausurenarchiv.Repo
    
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
    
end