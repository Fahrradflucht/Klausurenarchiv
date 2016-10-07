defmodule Klausurenarchiv.CourseControllerTest do
  use Klausurenarchiv.ConnCase

  alias Klausurenarchiv.Course
  @valid_attrs %{name: "Testing 101"}
  @invalid_attrs %{name: nil}
  
  setup %{conn: conn} = config do
    cond do
      name = config[:login_as] ->
        user = insert_user(name: name)
        conn = assign(conn, :current_user, user)
        {:ok, conn: conn, user: user}
      name = config[:login_as_admin] ->
        user = insert_user(%{name: name, is_admin: true})
        conn = assign(conn, :current_user, user)
        {:ok, conn: conn, user: user}
      true ->
        :ok
    end
  end

  test "lists all courses alphabetically on index", %{conn: conn} do
    course_m = Repo.insert! %Course{name: "M Testing"}
    course_z = Repo.insert! %Course{name: "Z Testing"}
    course_a = Repo.insert! %Course{name: "A Testing"}

    conn = get conn, course_path(conn, :index)

    assert html_response(conn, 200) =~
      ~r/#{course_a.name}.*#{course_m.name}.*#{course_z.name}/s
  end

  test ":new, :create, :edit, :update, :delete require auth", %{conn: conn} do
    Enum.each([
      get(conn, course_path(conn, :new)),
      post(conn, course_path(conn, :create, %{})),
      get(conn, course_path(conn, :edit, "1")),
      put(conn, course_path(conn, :update, "1", %{})),
      delete(conn, course_path(conn, :delete, "1")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag login_as: "Ernie Macmillan"
  test "renders new course form", %{conn: conn} do
    conn = get conn, course_path(conn, :new)

    assert html_response(conn, 200) =~ "Neuer Kurs"
  end
  
  @tag login_as: "Ernie Macmillan"
  test "creates course and redirects when data is valid", %{conn: conn} do
    conn = post conn, course_path(conn, :create), course: @valid_attrs
    assert redirected_to(conn) == course_path(conn, :index)
    assert Repo.get_by(Course, @valid_attrs)
  end

  @tag login_as: "Ernie Macmillan"
  test "does not create course and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, course_path(conn, :create), course: @invalid_attrs
    assert html_response(conn, 200) =~
      ~r/Neuer Kurs.*can.*t be blank/s
  end

  @tag login_as: "Ernie Macmillan"
  test "renders form for editing chosen course", %{conn: conn} do
    course = Repo.insert! %Course{name: "Testing 101"}
    conn = get conn, course_path(conn, :edit, course)
    assert html_response(conn, 200) =~ "#{course.name} bearbeiten"
  end

  @tag login_as: "Ernie Macmillan"
  test "updates chosen course and redirects when data is valid", %{conn: conn} do
    course = Repo.insert! %Course{name: "Testing"}
    conn = put conn, course_path(conn, :update, course), course: @valid_attrs
    assert redirected_to(conn) == course_path(conn, :index)
    assert Repo.get_by(Course, @valid_attrs)
  end

  @tag login_as: "Ernie Macmillan"
  test "does not update chosen course and renders errors when data is invalid", %{conn: conn} do
    course = Repo.insert! %Course{name: "Testing"}
    conn = put conn, course_path(conn, :update, course), course: @invalid_attrs
    assert html_response(conn, 200) =~ "#{course.name} bearbeiten"
  end

  @tag login_as: "Ernie Macmillan"
  test "delete requires admin rights", %{conn: conn} do
    conn = delete conn, course_path(conn, :delete, "1")

    assert redirected_to(conn) == "/"
    assert conn.halted
  end
  
  @tag login_as_admin: "Albus Dumbledore"
  test "delete existing course", %{conn: conn} do
    course = Repo.insert! %Course{name: "Testing 101"}
    conn = delete conn, course_path(conn, :delete, course)
    assert redirected_to(conn) == course_path(conn, :index)
    refute Repo.get(Course, course.id)
  end
end
