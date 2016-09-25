defmodule Klausurenarchiv.Repo.Migrations.AddFbIdIndexToUser do
  use Ecto.Migration

  def change do
    create index(:users, [:fb_id])
  end
end
