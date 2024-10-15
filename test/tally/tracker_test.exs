defmodule Tally.TrackerTest do
  use Tally.DataCase

  alias Tally.Tracker

  describe "metrics" do
    alias Tally.Tracker.Metric

    import Tally.TrackerFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_metrics/0 returns all metrics" do
      metric = metric_fixture()
      assert Tracker.list_metrics() == [metric]
    end

    test "get_metric!/1 returns the metric with given id" do
      metric = metric_fixture()
      assert Tracker.get_metric!(metric.id) == metric
    end

    test "create_metric/1 with valid data creates a metric" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Metric{} = metric} = Tracker.create_metric(valid_attrs)
      assert metric.name == "some name"
      assert metric.description == "some description"
    end

    test "create_metric/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_metric(@invalid_attrs)
    end

    test "update_metric/2 with valid data updates the metric" do
      metric = metric_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %metrics)
      assert metric.name == "some updated name"
      assert metric.description == "some updated description"
    end

    test "update_metric/2 with invalid data returns error changeset" do
      metric = metric_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_metric(metric, @invalid_attrs)
      assert metric == Tracker.get_metric!(metric.id)
    end

    test "delete_metric/1 deletes the metric" do
      metric = metric_fixture()
      assert {:ok, %Metric{}} = Tracker.delete_metric(metric)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_metric!(metric.id) end
    end

    test "change_metric/1 returns a metric changeset" do
      metric = metric_fixture()
      assert %Ecto.Changeset{} = Tracker.change_metric(metric)
    end
  end

  describe "events" do
    alias Tally.Tracker.Event

    import Tally.TrackerFixtures

    @invalid_attrs %{name: nil, occurred_at: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Tracker.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Tracker.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{name: "some name", occurred_at: ~N[2024-10-14 00:48:00]}

      assert {:ok, %Event{} = event} = Tracker.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.occurred_at == ~N[2024-10-14 00:48:00]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{name: "some updated name", occurred_at: ~N[2024-10-15 00:48:00]}

      assert {:ok, %Event{} = event} = Tracker.update_event(event, update_attrs)
      assert event.name == "some updated name"
      assert event.occurred_at == ~N[2024-10-15 00:48:00]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_event(event, @invalid_attrs)
      assert event == Tracker.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Tracker.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Tracker.change_event(event)
    end
  end

  describe "events" do
    alias Tally.Tracker.Event

    import Tally.TrackerFixtures

    @invalid_attrs %{name: nil, occurred_at: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Tracker.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Tracker.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{name: "some name", occurred_at: ~N[2024-10-14 01:39:00]}

      assert {:ok, %Event{} = event} = Tracker.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.occurred_at == ~N[2024-10-14 01:39:00]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{name: "some updated name", occurred_at: ~N[2024-10-15 01:39:00]}

      assert {:ok, %Event{} = event} = Tracker.update_event(event, update_attrs)
      assert event.name == "some updated name"
      assert event.occurred_at == ~N[2024-10-15 01:39:00]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_event(event, @invalid_attrs)
      assert event == Tracker.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Tracker.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Tracker.change_event(event)
    end
  end
end
