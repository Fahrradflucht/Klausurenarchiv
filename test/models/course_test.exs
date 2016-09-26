defmodule Klausurenarchiv.CourseTest do
  use Klausurenarchiv.ModelCase

  alias Klausurenarchiv.Course

  @valid_attrs %{name: "Finanzierung 1"}
  @invalid_attrs %{name: nil}

  test "changeset with valid attributes" do
    changeset = Course.changeset(%Course{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Course.changeset(%Course{}, @invalid_attrs)
    refute changeset.valid?
  end
end
