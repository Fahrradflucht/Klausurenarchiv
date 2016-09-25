defmodule Klausurenarchiv.Repo.Migrations.CreateInstructor do
  use Ecto.Migration

  def change do
    create table(:instructors) do
      add :name, :string
      add :course_id, references(:courses, on_delete: :delete_all)

      timestamps()
    end
    create index(:instructors, [:course_id])

  end
end
