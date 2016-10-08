defmodule Klausurenarchiv.UploadControllerTest do
  use Klausurenarchiv.ConnCase

  alias Klausurenarchiv.{Course, Instructor, Upload}
  
  @valid_attrs %{semester_kind: "SoSe", semester_year: "13", files: []}
  @invalid_attrs %{files: nil, semester_kind: nil, semester_year: "13"}
  
  setup :setup_login

  test "lists all uploads of the given course instructor sorted by semester on index", %{conn: conn} do
    course = Repo.insert! %Course{name: "History of Magic"}
    instructor = Repo.insert! %Instructor{name: "Binns", course: course}
    
    u_sose13 = Repo.insert! %Upload{semester: "SoSe 13", files: [], instructor: instructor}
    u_wise13_14 = Repo.insert! %Upload{semester: "WiSe 13/14", files: [], instructor: instructor}
    u_wise12_13 = Repo.insert! %Upload{semester: "Wise 12/13", files: [], instructor: instructor}

    conn = get conn, course_instructor_upload_path(conn, :index, course, instructor)
    assert html_response(conn, 200) =~ "Klausuren für #{course.name} - #{instructor.name}"
    assert html_response(conn, 200) =~ ~r/#{u_wise12_13.semester}.*#{u_sose13.semester}.*#{u_wise13_14.semester}/s
  end
  
  test ":new, :create, and :delete require auth", %{conn: conn} do
    course = Repo.insert! %Course{name: "History of Magic"}
    instructor = Repo.insert! %Instructor{name: "Binns", course: course}
    
    Enum.each([
      get(conn, course_instructor_upload_path(conn, :new, course, instructor)),
      post(conn, course_instructor_upload_path(conn, :create, course, instructor, %{})),
      delete(conn, course_instructor_upload_path(conn, :delete, course, instructor, "1")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag login_as: "Lavender Brown"
  test "renders form for new resources", %{conn: conn} do
    course = Repo.insert! %Course{name: "History of Magic"}
    instructor = Repo.insert! %Instructor{name: "Binns", course: course}
    
    conn = get conn, course_instructor_upload_path(conn, :new, course, instructor)
    assert html_response(conn, 200) =~ "Neue Klausur"
  end

  @tag login_as: "Lavender Brown"
  test "creates upload and redirects when data is valid", %{conn: conn, user: user} do
    course = Repo.insert! %Course{name: "History of Magic"}
    instructor = Repo.insert! %Instructor{name: "Binns", course: course}
    
    conn = post conn, course_instructor_upload_path(conn, :create, course, instructor), upload: @valid_attrs
    assert redirected_to(conn) == course_instructor_upload_path(conn, :index, course, instructor)
    assert Repo.get_by(Upload, %{user_id: user.id, files: [], semester: "SoSe 13"})
  end

  @tag login_as: "Lavender Brown"
  test "does not create upload and renders errors when data is invalid", %{conn: conn} do
    course = Repo.insert! %Course{name: "History of Magic"}
    instructor = Repo.insert! %Instructor{name: "Binns", course: course}
    
    conn = post conn, course_instructor_upload_path(conn, :create, course, instructor), upload: @invalid_attrs
    assert html_response(conn, 200) =~ "Neue Klausur"
  end

  @tag login_as: "Lavender Brown"
  test "delete requires ownership or admin rights", %{conn: conn} do
    course = Repo.insert! %Course{name: "History of Magic"}
    instructor = Repo.insert! %Instructor{name: "Binns", course: course}
    
    user = insert_user(name: "Marcus Belby")
    upload = Repo.insert! %Upload{semester: "WiSe 12/13", files: [], instructor: instructor, user: user}
    
    conn = delete conn, course_instructor_upload_path(conn, :delete, course, instructor, upload)
    assert redirected_to(conn) == course_instructor_upload_path(conn, :index, course, instructor)
    assert conn.halted
    assert Repo.get(Upload, upload.id)
  end

  @tag login_as: "Lavender Brown"
  test "delete existing upload as owner", %{conn: conn, user: user} do
    course = Repo.insert! %Course{name: "History of Magic"}
    instructor = Repo.insert! %Instructor{name: "Binns", course: course}

    upload = Repo.insert! %Upload{semester: "WiSe 12/13", files: [], instructor: instructor, user: user}
    
    conn = delete conn, course_instructor_upload_path(conn, :delete, course, instructor, upload)
    assert redirected_to(conn) == course_instructor_upload_path(conn, :index, course, instructor)
    refute Repo.get(Upload, upload.id)
  end
  
  @tag login_as_admin: "Albus Dumbledore"
  test "delete existing upload as admin", %{conn: conn} do
    course = Repo.insert! %Course{name: "History of Magic"}
    instructor = Repo.insert! %Instructor{name: "Binns", course: course}

    user = insert_user(name: "Marcus Belby")
    upload = Repo.insert! %Upload{semester: "WiSe 12/13", files: [], instructor: instructor, user: user}
    
    conn = delete conn, course_instructor_upload_path(conn, :delete, course, instructor, upload)
    assert redirected_to(conn) == course_instructor_upload_path(conn, :index, course, instructor)
    refute Repo.get(Upload, upload.id)
  end
end
