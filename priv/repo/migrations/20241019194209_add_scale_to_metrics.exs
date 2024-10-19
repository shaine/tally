defmodule Tally.Repo.Migrations.AddScaleToMetrics do
  use Ecto.Migration

  def change do
    alter table(:metrics) do
      add :scale, :string
    end
  end
end
