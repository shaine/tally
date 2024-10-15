defmodule Tally.Tracker.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  schema "metrics" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(metric, attrs) do
    metric
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
