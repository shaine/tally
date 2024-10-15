defmodule Tally.Repo.Migrations.AddTypeToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :type, :string
    end
  end
end
