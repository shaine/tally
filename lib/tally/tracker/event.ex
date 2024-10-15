defmodule Tally.Tracker.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :occurred_at, :naive_datetime
    field :metric_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :occurred_at, :metric_id])
    |> validate_required([:name, :occurred_at, :metric_id])
  end
end
