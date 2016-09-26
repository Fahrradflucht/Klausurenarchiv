defmodule Klausurenarchiv.UploadTest do
  use Klausurenarchiv.ModelCase

  alias Klausurenarchiv.Upload

  @valid_attrs %{
    description: nil,
    files: ["/tmp/test.txt"],
    semester: "WiSe 14/15"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Upload.changeset(%Upload{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Upload.changeset(%Upload{}, @invalid_attrs)
    refute changeset.valid?
  end
end
