defmodule Tally.TrackerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tally.Tracker` context.
  """

  @doc """
  Generate a metric.
  """
  def metric_fixture(attrs \\ %{}) do
    {:ok, metric} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Tally.Tracker.create_metric()

    metric
  end

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name",
        occurred_at: ~N[2024-10-14 00:48:00]
      })
      |> Tally.Tracker.create_event()

    event
  end

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name",
        occurred_at: ~N[2024-10-14 01:39:00]
      })
      |> Tally.Tracker.create_event()

    event
  end
end
