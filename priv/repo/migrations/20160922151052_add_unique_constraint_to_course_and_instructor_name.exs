defmodule Klausurenarchiv.Repo.Migrations.AddUniqueConstraintToCourseAndInstructorName do
  use Ecto.Migration

  def change do
    create unique_index(:courses, [:name])
    create unique_index(:instructors, [:name])
  end
end
