defmodule Tally.Repo.Migrations.AddMetricsFields do
  use Ecto.Migration

  def change do
    alter table(:metrics) do
      add :event_metadata_schema, :jsonb
    end

    alter table(:events) do
      add :metadata, :jsonb
    end
  end
end
