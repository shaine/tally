defmodule Tally.Tracker.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tally.Tracker.Event

  @scales [:day, :week, :month]

  schema "metrics" do
    field :name, :string
    field :description, :string
    field :scale, Ecto.Enum, values: @scales
    field :events_count, :integer, virtual: true

    has_many :events, Event, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(metric, attrs) do
    metric
    |> cast(attrs, [:name, :description, :scale])
    |> validate_required([:name, :scale])
  end
end
