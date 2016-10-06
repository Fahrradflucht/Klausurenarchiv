defmodule Klausurenarchiv.Repo.Migrations.AddIsResitToExam do
  use Ecto.Migration

  def change do
    alter table(:uploads) do
      add :is_resit, :boolean, null: false, default: false
    end
  end
end
