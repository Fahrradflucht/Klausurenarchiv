defmodule Klausurenarchiv.InstructorControllerTest do
  use Klausurenarchiv.ConnCase

  # alias Klausurenarchiv.Instructor
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  # @tag :skip
  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, instructor_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing instructors"
  # end

  # @tag :skip
  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, instructor_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New instructor"
  # end

  # @tag :skip
  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, instructor_path(conn, :create), instructor: @valid_attrs
  #   assert redirected_to(conn) == instructor_path(conn, :index)
  #   assert Repo.get_by(Instructor, @valid_attrs)
  # end

  # @tag :skip
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, instructor_path(conn, :create), instructor: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New instructor"
  # end

  # @tag :skip
  # test "shows chosen resource", %{conn: conn} do
  #   instructor = Repo.insert! %Instructor{}
  #   conn = get conn, instructor_path(conn, :show, instructor)
  #   assert html_response(conn, 200) =~ "Show instructor"
  # end

  # @tag :skip
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, instructor_path(conn, :show, -1)
  #   end
  # end

  # @tag :skip
  # test "renders form for editing chosen resource", %{conn: conn} do
  #   instructor = Repo.insert! %Instructor{}
  #   conn = get conn, instructor_path(conn, :edit, instructor)
  #   assert html_response(conn, 200) =~ "Edit instructor"
  # end

  # @tag :skip
  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   instructor = Repo.insert! %Instructor{}
  #   conn = put conn, instructor_path(conn, :update, instructor), instructor: @valid_attrs
  #   assert redirected_to(conn) == instructor_path(conn, :show, instructor)
  #   assert Repo.get_by(Instructor, @valid_attrs)
  # end

  # @tag :skip
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   instructor = Repo.insert! %Instructor{}
  #   conn = put conn, instructor_path(conn, :update, instructor), instructor: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit instructor"
  # end

  # @tag :skip
  # test "deletes chosen resource", %{conn: conn} do
  #   instructor = Repo.insert! %Instructor{}
  #   conn = delete conn, instructor_path(conn, :delete, instructor)
  #   assert redirected_to(conn) == instructor_path(conn, :index)
  #   refute Repo.get(Instructor, instructor.id)
  # end
end
