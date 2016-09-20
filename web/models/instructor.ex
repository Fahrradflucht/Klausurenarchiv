defmodule Klausurenarchiv.Instructor do
  use Klausurenarchiv.Web, :model

  schema "instructors" do
    field :name, :string
    belongs_to :course, Klausurenarchiv.Course

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
