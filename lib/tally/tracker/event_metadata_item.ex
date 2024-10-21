defmodule Tally.Tracker.EventMetadataItem do
  use Ecto.Schema
  import Ecto.Changeset

  @metric_types [:integer, :string]

  embedded_schema do
    field :field, :string
    field :type, Ecto.Enum, values: @metric_types
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:field, :type])
    |> validate_required([:field, :type])
  end

  def types, do: @metric_types
end
