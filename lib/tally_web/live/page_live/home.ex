defmodule TallyWeb.PageLive.Home do
  use TallyWeb, :live_view

  alias Tally.Tracker

  @impl true
  def mount(_params, _session, socket) do
    metrics = Tracker.list_current_metrics()

    {:ok, assign(socket, :metrics, metrics)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Home")}
  end

  @impl true
  def handle_event("click", %{"id" => id, "name" => name}, socket) do
    {:ok, _} = Tracker.create_event(%{name: name, metric_id: id, occurred_at: DateTime.utc_now()})

    metrics = Tracker.list_current_metrics()

    {:noreply, assign(socket, :metrics, metrics)}
  end
end
