defmodule TallyWeb.MetricLive.Index do
  use TallyWeb, :live_view

  alias Tally.Tracker
  alias Tally.Tracker.Metric

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :metrics, Tracker.list_metrics())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Metric")
    |> assign(:metric, Tracker.get_metric!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Metric")
    |> assign(:metric, %Metric{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Metrics")
    |> assign(:metric, nil)
  end

  @impl true
  def handle_info({TallyWeb.MetricLive.FormComponent, {:saved, metric}}, socket) do
    {:noreply, stream_insert(socket, :metrics, metric)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    metric = Tracker.get_metric!(id)
    {:ok, _} = Tracker.delete_metric(metric)

    {:noreply, stream_delete(socket, :metrics, metric)}
  end
end
