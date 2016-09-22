defmodule Klausurenarchiv.PageController do
  use Klausurenarchiv.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"name" => name}) do
    render conn, "#{name}.html"
  end
end
