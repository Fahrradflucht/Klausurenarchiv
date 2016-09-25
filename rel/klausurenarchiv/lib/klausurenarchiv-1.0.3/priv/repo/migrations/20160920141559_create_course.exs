defmodule Klausurenarchiv.Repo.Migrations.CreateCourse do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string

      timestamps()
    end

  end
end
