defmodule Klausurenarchiv.AuthController do
    use Klausurenarchiv.Web, :controller
    plug Ueberauth

    def delete(conn, _params) do
        conn
        |> put_flash(:info, "Du hast dich erfolgreich ausgeloggt!")
        |> configure_session(drop: true)
        |> redirect(to: "/")
    end

    def callback(%{ assigns: %{ ueberauth_failure: fails } } = conn, _params) do
        conn
        |> put_flash(:error, "Oops! Fehler beim einloggen!")
        |> redirect(to: "/")
    end

    def callback(%{ assigns: %{ ueberauth_auth: auth } } = conn, _params) do
        IO.inspect auth
        conn |> redirect(to: "/")
        # case User.find_or_create_from_auth(auth) do
        #     {:ok, user} ->
        #         conn
        #         |> put_flash(:info, "Successfully authenticated.")
        #         |> put_session(:current_user, user)
        #         |> redirect(to: "/")
        #     {:error, reason} ->
        #         conn
        #         |> put_flash(:error, reason)
        #         |> redirect(to: "/")
        # end
    end
end