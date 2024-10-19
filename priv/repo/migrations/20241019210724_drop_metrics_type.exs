defmodule Tally.Repo.Migrations.DropMetricsType do
  use Ecto.Migration

  def change do
    alter table(:metrics) do
      remove :type, :string
    end
  end
end
