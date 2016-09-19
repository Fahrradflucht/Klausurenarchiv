defmodule Klausurenarchiv.UploadControllerTest do
  use Klausurenarchiv.ConnCase

  alias Klausurenarchiv.Upload
  @valid_attrs %{description: "some content", files: []}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, upload_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing uploads"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, upload_path(conn, :new)
    assert html_response(conn, 200) =~ "New upload"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, upload_path(conn, :create), upload: @valid_attrs
    assert redirected_to(conn) == upload_path(conn, :index)
    assert Repo.get_by(Upload, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, upload_path(conn, :create), upload: @invalid_attrs
    assert html_response(conn, 200) =~ "New upload"
  end

  test "shows chosen resource", %{conn: conn} do
    upload = Repo.insert! %Upload{}
    conn = get conn, upload_path(conn, :show, upload)
    assert html_response(conn, 200) =~ "Show upload"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, upload_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    upload = Repo.insert! %Upload{}
    conn = get conn, upload_path(conn, :edit, upload)
    assert html_response(conn, 200) =~ "Edit upload"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    upload = Repo.insert! %Upload{}
    conn = put conn, upload_path(conn, :update, upload), upload: @valid_attrs
    assert redirected_to(conn) == upload_path(conn, :show, upload)
    assert Repo.get_by(Upload, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    upload = Repo.insert! %Upload{}
    conn = put conn, upload_path(conn, :update, upload), upload: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit upload"
  end

  test "deletes chosen resource", %{conn: conn} do
    upload = Repo.insert! %Upload{}
    conn = delete conn, upload_path(conn, :delete, upload)
    assert redirected_to(conn) == upload_path(conn, :index)
    refute Repo.get(Upload, upload.id)
  end
end
