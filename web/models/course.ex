defmodule Klausurenarchiv.Course do
  use Klausurenarchiv.Web, :model

  schema "courses" do
    field :name, :string
    has_many :instructors, Klausurenarchiv.Instructor


    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
