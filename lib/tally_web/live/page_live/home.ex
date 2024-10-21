defmodule TallyWeb.PageLive.Home do
  use TallyWeb, :live_view

  alias Tally.Tracker
  alias Tally.Tracker.Event
  alias Tally.Tracker.Metric

  @impl true
  def mount(_params, _session, socket) do
    metrics = Tracker.list_metrics()

    {:ok, assign(socket, :metrics, metrics)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Home")
     |> assign(:mode, nil)}
  end

  @impl true
  def handle_event("click", %{"id" => id} = params, socket) do
    metric = Tracker.get_metric!(id)

    {:noreply,
     if metric.event_metadata_schema && !Enum.empty?(metric.event_metadata_schema) do
       apply_action(socket, :trigger_form, params)
     else
       apply_action(socket, :create_from_click, params)
     end}
  end

  defp apply_action(socket, :create_from_click, %{"id" => id}) do
    {:ok, _} = Tracker.create_event(%{metric_id: id, occurred_at: DateTime.utc_now()})

    metrics = Tracker.list_metrics()

    assign(socket, :metrics, metrics)
  end

  defp apply_action(socket, :trigger_form, %{"id" => id}) do
    metric = Tracker.get_metric!(id)
    metadata = Metric.event_metadata(metric)

    socket
    |> assign(:event, %Event{
      metric_id: metric.id,
      metadata: metadata,
      occurred_at: DateTime.utc_now()
    })
    |> assign(:mode, :new_event)
    |> assign(:metric, metric)
  end

  @impl true
  def handle_info({TallyWeb.EventLive.FormComponent, {:saved, _event}}, socket) do
    metrics = Tracker.list_metrics()

    {:noreply, assign(socket, :metrics, metrics)}
  end
end
