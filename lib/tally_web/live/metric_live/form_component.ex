defmodule TallyWeb.MetricLive.FormComponent do
  use TallyWeb, :live_component

  alias Tally.Tracker

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
        <:actions>
          <.button phx-disable-with="Saving...">Save Metric</.button>
        </:actions>
      </.simple_form>
    </div>
    """
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

  defp save_metric(socket, :edit, metric_params) do
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
