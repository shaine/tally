defmodule Tally.Tracker.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tally.Tracker.Event
  alias Tally.Tracker.EventMetadataItem

  @scales [:day, :week, :month]

  schema "metrics" do
    field :name, :string
    field :description, :string
    field :scale, Ecto.Enum, values: @scales

    field :events_count, :integer, virtual: true
    field :events_within_range_count, :integer, virtual: true

    embeds_many :event_metadata_schema, EventMetadataItem, on_replace: :delete
    has_many :events, Event, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(metric, attrs) do
    metric
    |> cast(attrs, [:name, :description, :scale])
    |> validate_required([:name, :scale])
    |> cast_embed(:event_metadata_schema, with: &EventMetadataItem.changeset/2)
  end

  # Generate a metadata object for an event
  def event_metadata(%__MODULE__{event_metadata_schema: schema}) do
    for %{field: field, type: type} <- schema,
        into: %{},
        do: {field, %{"type" => type, "value" => nil}}
  end
end
