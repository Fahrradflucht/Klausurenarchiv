defmodule Klausurenarchiv.Upload do
  use Klausurenarchiv.Web, :model

  schema "uploads" do
    field :description, :string
    field :files, {:array, :string}
    field :semester, :string
    field :is_resit, :boolean
    belongs_to :instructor, Klausurenarchiv.Instructor
    belongs_to :user, Klausurenarchiv.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :files, :semester, :is_resit])
    |> validate_required([:semester, :files])
  end
end
