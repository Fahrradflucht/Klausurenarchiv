defmodule Klausurenarchiv.InstructorViewTest do
  use Klausurenarchiv.ConnCase, async: true
  
  alias Klausurenarchiv.InstructorView
  import Phoenix.View

  alias Klausurenarchiv.Course
  
  test "index.html contains new instructor link" do
    course = %Course{id: 1, name: "Herbology"}
    assert render_to_string(
        InstructorView,
        "index.html",
        [course: course, instructors: [], conn: build_conn()]
    ) =~ "Neue*r Lehrende*r"
  end
  
end