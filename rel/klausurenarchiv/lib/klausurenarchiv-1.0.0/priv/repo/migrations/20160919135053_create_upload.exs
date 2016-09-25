defmodule Klausurenarchiv.Repo.Migrations.CreateUpload do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :description, :string
      add :files, {:array, :string}

      timestamps()
    end

  end
end
