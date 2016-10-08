defmodule Klausurenarchiv.InstructorControllerTest do
  use Klausurenarchiv.ConnCase
  
  alias Klausurenarchiv.Instructor
  alias Klausurenarchiv.Course
  @valid_attrs %{name: "Sprout"}
  @invalid_attrs %{name: nil}

  setup :setup_login

  test "list all instructors of a given course alphabetically on index", %{conn: conn} do
    course = Repo.insert! %Course{name: "Test Course"}
    instructor_a = Repo.insert! %Instructor{name: "A Instructor", course: course}
    instructor_z = Repo.insert! %Instructor{name: "Z Instructor", course: course}
    instructor_m = Repo.insert! %Instructor{name: "M Instructor", course: course}
    
    conn = get conn, course_instructor_path(conn, :index, course)
    assert html_response(conn, 200) =~
      ~r/Lehrende für #{course.name}.*#{instructor_a.name}.*#{instructor_m.name}.*#{instructor_z.name}/s
  end

  test ":new, :create, :edit, :update, :delete require auth", %{conn: conn} do
    course = Repo.insert! %Course{name: "Herbology"}
    
    Enum.each([
      get(conn, course_instructor_path(conn, :new, course)),
      post(conn, course_instructor_path(conn, :create, course, %{})),
      get(conn, course_instructor_path(conn, :edit, course, "1")),
      put(conn, course_instructor_path(conn, :update, course, "1", %{})),
      delete(conn, course_instructor_path(conn, :delete, course, "1")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag login_as: "Hannah Abbott"
  test "renders new instructor form", %{conn: conn} do
    course = Repo.insert! %Course{name: "Herbology"}
    conn = get conn, course_instructor_path(conn, :new, course)
    assert html_response(conn, 200) =~ "Neue*r Lehrende*r"
  end

  @tag login_as: "Hannah Abbott"
  test "creates instructor and redirects when data is valid", %{conn: conn} do
    course = Repo.insert! %Course{name: "Herbology"}

    conn = post conn, course_instructor_path(conn, :create, course), instructor: @valid_attrs
    assert redirected_to(conn) == course_instructor_path(conn, :index, course)
    assert Repo.get_by(Instructor, @valid_attrs)
  end

  @tag login_as: "Hannah Abbott"
  test "does not create instructor and renders errors when data is invalid", %{conn: conn} do
    course = Repo.insert! %Course{name: "Herbology"}
    
    conn =
      post conn, course_instructor_path(conn, :create, course), instructor: @invalid_attrs
    assert html_response(conn, 200) =~ ~r/Neue\*r Lehrende\*r.*can.*t be blank/s
  end

  @tag login_as: "Hannah Abbott"
  test "renders form for editing chosen instructor", %{conn: conn} do
    course = Repo.insert! %Course{name: "Herbology"}
    instructor = Repo.insert! %Instructor{name: "Sprout"}

    conn = get conn, course_instructor_path(conn, :edit, course, instructor)
    assert html_response(conn, 200) =~ "Lehrende*n bearbeiten"
  end

  @tag login_as: "Hannah Abbott"
  test "updates chosen instructor and redirects when data is valid", %{conn: conn} do
    course = Repo.insert! %Course{name: "Herbology"}
    instructor = Repo.insert! %Instructor{name: "Beery"}

    conn = put conn, course_instructor_path(conn, :update, course, instructor), instructor: @valid_attrs
    assert redirected_to(conn) == course_instructor_path(conn, :index, course)
    assert Repo.get_by(Instructor, @valid_attrs)
  end

  @tag login_as: "Hannah Abbott"
  test "does not update chosen instructor and renders errors when data is invalid", %{conn: conn} do
    course = Repo.insert! %Course{name: "Herbology"}
    instructor = Repo.insert! %Instructor{name: "Beery"}

    conn = put conn, course_instructor_path(conn, :update, course, instructor), instructor: @invalid_attrs
    assert html_response(conn, 200) =~ "Lehrende*n bearbeiten"
  end

  @tag login_as: "Hannah Abbott"
  test "delete requires admin rights", %{conn: conn} do
    conn = delete conn, course_instructor_path(conn, :delete, "1", "1")

    assert redirected_to(conn) == "/"
    assert conn.halted
  end

  @tag login_as_admin: "Severus Snape"
  test "deletes existing instructor", %{conn: conn} do
    course = Repo.insert! %Course{name: "Herbology"}
    instructor = Repo.insert! %Instructor{name: "Beery"}
    
    conn = delete conn, course_instructor_path(conn, :delete, course, instructor)
    assert redirected_to(conn) == course_instructor_path(conn, :index, course)
    refute Repo.get(Instructor, instructor.id)
  end
end
