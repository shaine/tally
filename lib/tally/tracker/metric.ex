defmodule Tally.Tracker.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tally.Tracker.Event

  @types boolean: "The metric occurred for a day, or not", count: "Events are counted per day"
  @scales [:day, :week, :month]

  schema "metrics" do
    field :name, :string
    field :description, :string
    field :type, Ecto.Enum, values: Keyword.keys(@types)
    field :scale, Ecto.Enum, values: @scales
    field :events_count, :integer, virtual: true

    has_many :events, Event, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(metric, attrs) do
    metric
    |> cast(attrs, [:name, :description, :type, :scale])
    |> validate_required([:name, :type, :scale])
  end

  def types, do: @types
end
