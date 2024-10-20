defmodule Tally.Tracker.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tally.Tracker.Metric

  schema "events" do
    field :name, :string
    field :occurred_at, :utc_datetime
    field :metadata, :map

    belongs_to :metric, Metric

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :occurred_at, :metric_id])
    |> validate_required([:occurred_at, :metric_id])
  end
end
