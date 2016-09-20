defmodule Klausurenarchiv.User do
  use Klausurenarchiv.Web, :model

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :fb_id, :string
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :first_name, :last_name, :fb_id, :name])
    |> validate_required([:email, :fb_id, :name])
  end
end
