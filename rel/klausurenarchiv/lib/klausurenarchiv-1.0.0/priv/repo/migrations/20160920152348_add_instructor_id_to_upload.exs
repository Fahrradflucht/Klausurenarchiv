defmodule Klausurenarchiv.Repo.Migrations.AddInstructorIdToUpload do
  use Ecto.Migration

  def up do
    alter table(:uploads) do
      add :instructor_id, references(:instructors, on_delete: :nilify_all)
    end

    create index(:uploads, [:instructor_id])
  end

  def down do
    drop index(:uploads, [:instructor_id])

    alter table(:uploads) do
      remove :instructor_id
    end
  end
end
