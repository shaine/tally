defmodule TallyWeb.EventController do
  use TallyWeb, :controller

  alias Tally.Tracker
  alias Tally.Tracker.Event

  def index(conn, %{"metric_id" => metric_id}) do
    events = Tracker.list_events(%{metric_id: metric_id})
    render(conn, :index, events: events, metric_id: metric_id)
  end

  def new(conn, %{"metric_id" => metric_id}) do
    changeset = Tracker.change_event(%Event{metric_id: metric_id})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"metric_id" => metric_id, "event" => event_params}) do
    case Tracker.create_event(Map.put(event_params, "metric_id", metric_id)) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: ~p"/events/#{event}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Tracker.get_event!(id)
    render(conn, :show, event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Tracker.get_event!(id)
    changeset = Tracker.change_event(event)
    render(conn, :edit, event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Tracker.get_event!(id)

    case Tracker.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: ~p"/events/#{event}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Tracker.get_event!(id)
    {:ok, _event} = Tracker.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: ~p"/metrics/#{event.metric_id}/events")
  end
end
