defmodule TallyWeb.MetricLive.Show do
  use TallyWeb, :live_view

  alias Tally.Tracker
  alias Tally.Tracker.Event

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply,
     socket
     |> assign(:metric, Tracker.get_metric!(id))
     |> stream(:events, Tracker.list_events(%{metric_id: id}))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Metric")
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Show Metric")
  end

  defp apply_action(socket, :new_event, %{"id" => id}) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{metric_id: id})
  end

  defp apply_action(socket, :edit_event, %{"event_id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Tracker.get_event!(id))
  end

  @impl true
  def handle_info({TallyWeb.EventLive.FormComponent, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :events, event)}
  end

  @impl true
  def handle_event("delete_event", %{"id" => id}, socket) do
    event = Tracker.get_event!(id)
    {:ok, _} = Tracker.delete_event(event)

    {:noreply, stream_delete(socket, :events, event)}
  end
end
