defmodule Klausurenarchiv.Repo.Migrations.RemoveUniqueConstraintFromInstructors do
  use Ecto.Migration

  def change do
    drop unique_index(:instructors, [:name])
  end
end
