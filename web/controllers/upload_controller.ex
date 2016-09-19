defmodule Klausurenarchiv.UploadController do
  use Klausurenarchiv.Web, :controller

  alias Klausurenarchiv.Upload

  def index(conn, _params) do
    uploads = Repo.all(Upload)
    render(conn, "index.html", uploads: uploads)
  end

  def new(conn, _params) do
    changeset = Upload.changeset(%Upload{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"upload" => upload_params}) do
    changeset = Upload.changeset(%Upload{}, upload_params)

    case Repo.insert(changeset) do
      {:ok, _upload} ->
        conn
        |> put_flash(:info, "Upload created successfully.")
        |> redirect(to: upload_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    upload = Repo.get!(Upload, id)
    render(conn, "show.html", upload: upload)
  end

  def edit(conn, %{"id" => id}) do
    upload = Repo.get!(Upload, id)
    changeset = Upload.changeset(upload)
    render(conn, "edit.html", upload: upload, changeset: changeset)
  end

  def update(conn, %{"id" => id, "upload" => upload_params}) do
    upload = Repo.get!(Upload, id)
    changeset = Upload.changeset(upload, upload_params)

    case Repo.update(changeset) do
      {:ok, upload} ->
        conn
        |> put_flash(:info, "Upload updated successfully.")
        |> redirect(to: upload_path(conn, :show, upload))
      {:error, changeset} ->
        render(conn, "edit.html", upload: upload, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    upload = Repo.get!(Upload, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(upload)

    conn
    |> put_flash(:info, "Upload deleted successfully.")
    |> redirect(to: upload_path(conn, :index))
  end
end
