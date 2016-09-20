defmodule Klausurenarchiv.InstructorController do
  use Klausurenarchiv.Web, :controller
  plug :assign_course

  alias Klausurenarchiv.Instructor

  def index(conn, _params) do
    instructors = 
      conn.assigns[:course]
      |> assoc(:instructors)
      |> Repo.all()
    render(conn, "index.html", instructors: instructors)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:course]
      |> build_assoc(:instructors)
      |> Instructor.changeset()
    
    IO.inspect changeset

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"instructor" => instructor_params}) do
    changeset =
      conn.assigns[:course]
      |> build_assoc(:instructors)
      |> Instructor.changeset(instructor_params)

    case Repo.insert(changeset) do
      {:ok, _instructor} ->
        conn
        |> put_flash(:info, "Instructor created successfully.")
        |> redirect(to: course_instructor_path(conn, :index, conn.assigns[:course]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    instructor = Repo.get!(Instructor, id)
    render(conn, "show.html", instructor: instructor)
  end

  def edit(conn, %{"id" => id}) do
    instructor = Repo.get!(Instructor, id)
    changeset = Instructor.changeset(instructor)
    render(conn, "edit.html", instructor: instructor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "instructor" => instructor_params}) do
    instructor = Repo.get!(Instructor, id)
    changeset = Instructor.changeset(instructor, instructor_params)

    case Repo.update(changeset) do
      {:ok, instructor} ->
        conn
        |> put_flash(:info, "Instructor updated successfully.")
        |> redirect(to: course_instructor_path(conn, :show, conn.assigns[:course], instructor))
      {:error, changeset} ->
        render(conn, "edit.html", instructor: instructor, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    instructor = Repo.get!(Instructor, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(instructor)

    conn
    |> put_flash(:info, "Instructor deleted successfully.")
    |> redirect(to: course_instructor_path(conn, :index, conn.assigns[:course]))
  end

  defp assign_course(conn, _opts) do
    case conn.params do
      %{"course_id" => course_id} ->
        course = Repo.get(Klausurenarchiv.Course, course_id)
        assign(conn, :course, course)
      _ ->
        conn
    end
  end
end
