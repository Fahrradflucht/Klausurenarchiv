defmodule Klausurenarchiv.User do
  use Klausurenarchiv.Web, :model

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :fb_id, :string
    field :name, :string
    field :is_admin, :boolean
    has_many :uploads, Klausurenarchiv.Upload

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :first_name, :last_name, :fb_id, :name, :is_admin])
    |> put_change_if(:is_admin, true, &is_initial_admin/1)
    |> validate_required([:email, :fb_id, :name])
  end

  defp put_change_if(changeset, key, value, condition) do
    if condition.(changeset) do
      put_change(changeset, key, value)
    else
      changeset
    end
  end

  defp is_initial_admin(changeset) do
    fb_id =
      changeset
      |> get_change(:fb_id)
    
    Application.get_env(:klausurenarchiv, :users)[:initial_admins] || []
    |> Enum.any?(&(&1 == fb_id))
  end
end
