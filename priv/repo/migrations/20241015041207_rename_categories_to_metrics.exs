defmodule Tally.Repo.Migrations.RenameCategoriesToMetrics do
  use Ecto.Migration

  def change do
    rename table("categories"), to: table(:metrics)
    rename table("events"), :category_id, to: :metric_id

    drop index(:events, [:category_id])
    create index(:events, [:metric_id])
  end
end
