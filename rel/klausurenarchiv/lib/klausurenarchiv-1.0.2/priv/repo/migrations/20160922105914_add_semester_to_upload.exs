defmodule Klausurenarchiv.Repo.Migrations.AddSemesterToUpload do
  use Ecto.Migration

  def change do
    alter table(:uploads) do
      add :semester, :string
    end
  end
end
