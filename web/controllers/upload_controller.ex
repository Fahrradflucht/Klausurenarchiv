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
    filepath = save_file_from_upload(upload_params)
    upload = Map.put(upload_params, "files", [filepath])
    changeset = Upload.changeset(%Upload{}, upload)

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
    Plug.Conn.send_file(conn, 200, hd upload.files)
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

    File.rm(hd upload.files)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(upload)

    conn
    |> put_flash(:info, "Upload deleted successfully.")
    |> redirect(to: upload_path(conn, :index))
  end

  defp save_file_from_upload(upload_params) do
    if file = upload_params["file"] do
      basepath = Application.get_env(:klausurenarchiv, :store)[:path]
      dest = Path.join(basepath, file.filename)
      case cp_p(file.path, dest) do
        :ok -> dest
        _ -> nil
      end
    else
      nil
    end
  end

  # Works like `File.cp` with the addition that it creates
  # missing parent directories.
  defp cp_p(source, destination) do
    with :ok <- File.mkdir_p(Path.dirname(destination)),
         :ok <- File.cp(source, destination), do: :ok
  end

end
