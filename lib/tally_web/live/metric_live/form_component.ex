defmodule TallyWeb.MetricLive.FormComponent do
  use TallyWeb, :live_component

  alias Tally.Tracker
  alias Tally.Tracker.EventMetadataItem

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage metric records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="metric-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input
          field={@form[:scale]}
          type="select"
          label="Scale"
          prompt="Choose a value"
          options={Ecto.Enum.values(Tally.Tracker.Metric, :scale)}
        />

        <h2>Event Schema</h2>
        <.inputs_for :let={f_nested} field={@form[:event_metadata_schema]}>
          <.input type="text" field={f_nested[:field]} label="Field name" />
          <.input
            type="select"
            field={f_nested[:type]}
            options={schema_type_options()}
            label="Field type"
          />
          <.button
            type="button"
            phx-click="remove_schema_item"
            phx-value-index={f_nested.index}
            phx-target={@myself}
          >
            Remove
          </.button>
        </.inputs_for>

        <.button type="button" phx-click="add_schema_item" phx-target={@myself}>
          Add Schema Item
        </.button>

        <:actions>
          <.button phx-disable-with="Saving...">Save Metric</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def schema_type_options do
    EventMetadataItem.types()
  end

  @impl true
  def update(%{metric: metric} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Tracker.change_metric(metric))
     end)}
  end

  @impl true
  def handle_event("validate", %{"metric" => metric_params}, socket) do
    changeset = Tracker.change_metric(socket.assigns.metric, metric_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"metric" => metric_params}, socket) do
    save_metric(socket, socket.assigns.action, metric_params)
  end

  def handle_event("add_schema_item", _params, socket) do
    changeset = socket.assigns.form.source
    items = Ecto.Changeset.get_field(changeset, :event_metadata_schema) || []
    new_item = %EventMetadataItem{}

    updated_changeset =
      Ecto.Changeset.put_embed(changeset, :event_metadata_schema, items ++ [new_item])

    {:noreply, assign(socket, form: to_form(updated_changeset, action: :validate))}
  end

  def handle_event("remove_schema_item", %{"index" => index}, socket) do
    changeset = socket.assigns.form.source
    items = Ecto.Changeset.get_field(changeset, :event_metadata_schema)
    updated_entries = List.delete_at(items, String.to_integer(index))

    updated_changeset =
      Ecto.Changeset.put_embed(changeset, :event_metadata_schema, updated_entries)

    {:noreply, assign(socket, form: to_form(updated_changeset))}
  end

  defp save_metric(socket, :edit, metric_params) do
    metric_params = Map.put_new(metric_params, "event_metadata_schema", %{})

    case Tracker.update_metric(socket.assigns.metric, metric_params) do
      {:ok, metric} ->
        notify_parent({:saved, metric})

        {:noreply,
         socket
         |> put_flash(:info, "Metric updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_metric(socket, :new, metric_params) do
    case Tracker.create_metric(metric_params) do
      {:ok, metric} ->
        notify_parent({:saved, metric})

        {:noreply,
         socket
         |> put_flash(:info, "Metric created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
