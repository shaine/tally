defmodule Tally.Tracker.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  @types boolean: "The metric occurred for a day, or not", count: "Events are counted per day"

  schema "metrics" do
    field :name, :string
    field :description, :string
    field :type, Ecto.Enum, values: Keyword.keys(@types)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(metric, attrs) do
    metric
    |> cast(attrs, [:name, :description, :type])
    |> validate_required([:name, :description, :type])
  end

  def types, do: @types
end
