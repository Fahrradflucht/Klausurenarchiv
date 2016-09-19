defmodule Klausurenarchiv.PageController do
  use Klausurenarchiv.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
