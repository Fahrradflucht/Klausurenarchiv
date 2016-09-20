defmodule Klausurenarchiv.AuthController do
    use Klausurenarchiv.Web, :controller
    plug Ueberauth

    alias Klausurenarchiv.User
    
    def delete(conn, _params) do
        conn
        |> put_flash(:info, "Du hast dich erfolgreich ausgeloggt!")
        |> configure_session(drop: true)
        |> redirect(to: "/")
    end

    def callback(%{ assigns: %{ ueberauth_failure: _fails } } = conn, _params) do
        conn
        |> put_flash(:error, "Oops! Fehler beim einloggen!")
        |> redirect(to: "/")
    end

    def callback(%{ assigns: %{ ueberauth_auth: auth } } = conn, _params) do
        IO.inspect auth
        conn |> redirect(to: "/")
        case find_or_create_from_auth(auth) do
            {:ok, user} ->
                conn
                |> put_flash(:info, "Successfully authenticated.")
                |> put_session(:current_user, user)
                |> redirect(to: "/")
            {:error, reason} ->
                conn
                |> put_flash(:error, reason)
                |> redirect(to: "/")
        end
    end

    defp find_or_create_from_auth(%Ueberauth.Auth{} = auth) do
        auth_user =
            auth.extra.raw_info.user
            |> Map.put("fb_id", auth.extra.raw_info.user["id"])
            |> Map.drop(["id"])

        case Repo.get_by(User, fb_id: auth_user["fb_id"]) do
            %User{} = user ->
                {:ok, user}
            _ ->
                changeset = User.changeset(%User{}, auth_user)
                case Repo.insert(changeset) do
                    {:ok, user} ->
                        {:ok, user}
                    {:error, _changeset} ->
                        {:ok, "Fehler beim anlegen eines neuen Accounts"}
                end
        end
    end
end