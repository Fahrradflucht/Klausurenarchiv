defmodule Klausurenarchiv.UploadController do
  use Klausurenarchiv.Web, :controller
  plug :assign_course_and_instructor
  plug :authenticate_user when action in [:new, :create, :edit, :update, :delete]

  alias Klausurenarchiv.Upload

  def index(conn, _params) do
    uploads =
      conn.assigns[:instructor]
      |> assoc(:uploads)
      |> Repo.all()
      |> Enum.sort(fn(a, b) ->
          Klausurenarchiv.Semester.compare_strings(a.semester, b.semester)
        end)
    render(conn, "index.html", uploads: uploads)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:instructor]
      |> build_assoc(:uploads, user_id: conn.assigns[:current_user].id)
      |> Upload.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"upload" => upload_params}) do

    # Files
    files = save_files_from_upload(conn, upload_params)
    upload = Map.put(upload_params, "files", files)

    # Semester
    %{"semester_kind" => kind, "semester_year" => year} = upload
    upload = Map.put(upload, "semester", to_string %Klausurenarchiv.Semester{kind: kind, year: year})

    # Assocs
    changeset =
      conn.assigns[:instructor]
      |> build_assoc(:uploads, user_id: conn.assigns[:current_user].id)
      |> Upload.changeset(upload)
    
    case Repo.insert(changeset) do
      {:ok, _upload} ->
        conn
        |> put_flash(:info, "Upload created successfully.")
        |> redirect(to: course_instructor_upload_path(
          conn,
          :index,
          conn.assigns[:course],
          conn.assigns[:instructor]
        ))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
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
        |> redirect(to: course_instructor_upload_path(
          conn,
          :show,
          conn.assigns[:course],
          conn.assigns[:instructor],
          upload))
      {:error, changeset} ->
        render(conn, "edit.html", upload: upload, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user

    upload = Repo.get!(Upload, id)

    if current_user.is_admin || (current_user.id == upload.user_id) do
      # Delete files from storage
      upload.files
      |> Enum.map(&(File.rm(&1)))

      Repo.delete!(upload)

      conn
      |> put_flash(:info, "Upload deleted successfully.")
      |> redirect(to: course_instructor_upload_path(
        conn,
        :index,
        conn.assigns[:course],
        conn.assigns[:instructor]
        ))
    else
      conn
      |> put_flash(:error, "Unauthorized")
      |> redirect(to: course_instructor_upload_path(
        conn,
        :index,
        conn.assigns[:course],
        conn.assigns[:instructor]
        ))
      |> halt()
    end
  end

  defp save_files_from_upload(conn, upload_params) do
    file_saver = fn file ->
      save_file(conn, file)
    end

    if files = upload_params["files"] do
      files
      |> Enum.map(file_saver)
      |> Enum.filter(&(&1 != nil))
    else
      nil
    end
  end

  defp save_file(conn, file) do
    basepath = Application.get_env(:klausurenarchiv, :store)[:path]
    dest =
      Path.join(
        [
          basepath,
          conn.assigns[:course].name,
          conn.assigns[:instructor].name,
          to_string(System.os_time),
          file.filename
        ]
      )
    case cp_p(file.path, dest) do
      :ok -> dest
      _ -> nil
    end
  end

  # Works like `File.cp` with the addition that it creates
  # missing parent directories.
  defp cp_p(source, destination) do
    with :ok <- File.mkdir_p(Path.dirname(destination)),
         :ok <- File.cp(source, destination), do: :ok
  end

  defp assign_course_and_instructor(conn, _opts) do
    case conn.params do
      %{"course_id" => course_id, "instructor_id" => instructor_id} ->
        course = Repo.get(Klausurenarchiv.Course, course_id)
        instructor = Repo.get(Klausurenarchiv.Instructor, instructor_id)
        conn
        |> assign(:course, course)
        |> assign(:instructor, instructor)
      _ ->
        conn
    end
  end

  defp authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      state = URI.encode_query(%{
        "state" => course_instructor_upload_path(
          conn,
          :index,
          conn.assigns[:course],
          conn.assigns[:instructor]
      )})
      
      conn
      |> redirect(to: "/auth/facebook?#{state}")
      |> halt()
    end
  end
end
