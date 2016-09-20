defmodule Klausurenarchiv.PageControllerTest do
  use Klausurenarchiv.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Klausurenarchiv Sozialökonomie"
  end
end
