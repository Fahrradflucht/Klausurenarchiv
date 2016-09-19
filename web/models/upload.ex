defmodule Klausurenarchiv.Upload do
  use Klausurenarchiv.Web, :model

  schema "uploads" do
    field :description, :string
    field :files, {:array, :string}

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :files])
    |> validate_required([:description, :files])
  end
end
