defmodule Tally.Tracker do
  @tz "America/Denver"

  @moduledoc """
  The Tracker context.
  """

  import Ecto.Query, warn: false
  alias Tally.Repo

  alias Tally.Tracker.Metric

  @doc """
  Returns the list of metrics.

  ## Examples

      iex> list_metrics()
      [%Metric{}, ...]

  """
  def list_metrics do
    query =
      from m in Metric,
        left_join: e in assoc(m, :events),
        group_by: m.id,
        select: %{m | events_count: count(e.id)}

    Repo.all(query)
  end

  @doc """
  Returns the list of metrics.

  ## Examples

      iex> list_current_metrics()
      [%Metric{}, ...]

  """
  def list_current_metrics do
    day_limit = start_of_day()
    week_limit = start_of_week()
    month_limit = start_of_month()
    now = DateTime.utc_now()

    query =
      from m in Metric,
        left_join: e in assoc(m, :events),
        group_by: m.id,
        select: %{
          m
          | events_count: count(e.id),
            events_within_range_count:
              count(
                fragment(
                  """
                    CASE
                      WHEN scale = 'day' AND occurred_at > ? AND occurred_at <= ? THEN 1
                      WHEN scale = 'week' AND occurred_at > ? AND occurred_at <= ? THEN 1
                      WHEN scale = 'month' AND occurred_at > ? AND occurred_at <= ? THEN 1
                      ELSE NULL
                    END
                  """,
                  ^day_limit,
                  ^now,
                  ^week_limit,
                  ^now,
                  ^month_limit,
                  ^now
                )
              )
        }

    Repo.all(query)
  end

  @doc """
  Gets a single metric.

  Raises `Ecto.NoResultsError` if the Metric does not exist.

  ## Examples

      iex> get_metric!(123)
      %Metric{}

      iex> get_metric!(456)
      ** (Ecto.NoResultsError)

  """
  def get_metric!(id) do
    query =
      from m in Metric,
        left_join: e in assoc(m, :events),
        group_by: m.id,
        select: %{m | events_count: count(e.id)},
        where: m.id == ^id

    Repo.one!(query)
  end

  @doc """
  Creates a metric.

  ## Examples

      iex> create_metric(%{field: value})
      {:ok, %Metric{}}

      iex> create_metric(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_metric(attrs \\ %{}) do
    %Metric{}
    |> Metric.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a metric.

  ## Examples

      iex> update_metric(metric, %{field: new_value})
      {:ok, %Metric{}}

      iex> update_metric(metric, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_metric(%Metric{} = metric, attrs) do
    metric
    |> Metric.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a metric.

  ## Examples

      iex> delete_metric(metric)
      {:ok, %Metric{}}

      iex> delete_metric(metric)
      {:error, %Ecto.Changeset{}}

  """
  def delete_metric(%Metric{} = metric) do
    Repo.delete(metric)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking metric changes.

  ## Examples

      iex> change_metric(metric)
      %Ecto.Changeset{data: %Metric{}}

  """
  def change_metric(%Metric{} = metric, attrs \\ %{}) do
    Metric.changeset(metric, attrs)
  end

  alias Tally.Tracker.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events(%{metric_id: 1})
      [%Event{}, ...]

  """
  def list_events(%{metric_id: metric_id}) do
    Repo.all(from e in Event, where: e.metric_id == ^metric_id)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  defp start_of_day do
    DateTime.now!(@tz)
    |> DateTime.to_date()
    |> DateTime.new!(~T[00:00:00], @tz)
    |> DateTime.shift_zone!("Etc/UTC")
  end

  defp start_of_week do
    DateTime.now!(@tz)
    |> DateTime.to_date()
    |> Date.beginning_of_week()
    |> DateTime.new!(~T[00:00:00], @tz)
    |> DateTime.shift_zone!("Etc/UTC")
  end

  defp start_of_month do
    DateTime.now!(@tz)
    |> DateTime.to_date()
    |> Date.beginning_of_month()
    |> DateTime.new!(~T[00:00:00], @tz)
    |> DateTime.shift_zone!("Etc/UTC")
  end
end
