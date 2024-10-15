defmodule TallyWeb.MetricController do
  use TallyWeb, :controller

  alias Tally.Tracker
  alias Tally.Tracker.Metric

  def index(conn, _params) do
    metrics = Tracker.list_metrics()
    render(conn, :index, metrics: metrics)
  end

  def new(conn, _params) do
    changeset = Tracker.change_metric(%Metric{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"metric" => metric_params}) do
    case Tracker.create_metric(metric_params) do
      {:ok, metric} ->
        conn
        |> put_flash(:info, "Metric created successfully.")
        |> redirect(to: ~p"/metrics/#{metric}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    metric = Tracker.get_metric!(id)
    render(conn, :show, metric: metric)
  end

  def edit(conn, %{"id" => id}) do
    metric = Tracker.get_metric!(id)
    changeset = Tracker.change_metric(metric)
    render(conn, :edit, metric: metric, changeset: changeset)
  end

  def update(conn, %{"id" => id, "metric" => metric_params}) do
    metric = Tracker.get_metric!(id)

    case Tracker.update_metric(metric, metric_params) do
      {:ok, metric} ->
        conn
        |> put_flash(:info, "Metric updated successfully.")
        |> redirect(to: ~p"/metrics/#{metric}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, metric: metric, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    metric = Tracker.get_metric!(id)
    {:ok, _metric} = Tracker.delete_metric(metric)

    conn
    |> put_flash(:info, "Metric deleted successfully.")
    |> redirect(to: ~p"/metrics")
  end
end
