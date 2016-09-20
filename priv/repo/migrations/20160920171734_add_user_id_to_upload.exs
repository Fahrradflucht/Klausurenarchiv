defmodule Klausurenarchiv.Repo.Migrations.AddUserIdToUpload do
  use Ecto.Migration

  def up do
    alter table(:uploads) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:uploads, [:user_id])
  end

  def down do
    drop index(:uploads, [:user_id])

    alter table(:uploads) do
      remove :user_id
    end
  end
end
