defmodule Klausurenarchiv.AdminPlug do
    import Plug.Conn
    import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

    def init(opts) do
        opts
    end

    def call(conn, _opts) do
        case conn.assigns.current_user do
            %{is_admin: true} ->
                conn
            _ ->
                conn
                |> put_flash(:error, "Unauthorized")
                |> redirect(to: "/")
                |> halt()
        end
    end
end