defmodule Tally.TrackerTest do
  use Tally.DataCase

  alias Tally.Tracker

  describe "categories" do
    alias Tally.Tracker.Category

    import Tally.TrackerFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Tracker.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Tracker.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Category{} = category} = Tracker.create_category(valid_attrs)
      assert category.name == "some name"
      assert category.description == "some description"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Category{} = category} = Tracker.update_category(category, update_attrs)
      assert category.name == "some updated name"
      assert category.description == "some updated description"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_category(category, @invalid_attrs)
      assert category == Tracker.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Tracker.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Tracker.change_category(category)
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
