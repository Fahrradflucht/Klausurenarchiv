defmodule Klausurenarchiv.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :fb_id, :string
      add :name, :string

      timestamps()
    end

  end
end
