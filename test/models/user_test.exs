defmodule Klausurenarchiv.UserTest do
  use Klausurenarchiv.ModelCase

  alias Klausurenarchiv.User

  @valid_attrs %{
    email: "mail@example.com",
    fb_id: "12345678910111213",
    first_name: "Rita",
    last_name: "Skeeter",
    name: "Rita Skeeter"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
