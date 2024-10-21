defmodule TallyWeb.EventLive.FormComponent do
  use TallyWeb, :live_component

  alias Tally.Tracker

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage event records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:occurred_at]} type="datetime-local" label="Occurred at" />

        <%= for {field, %{"type" => type, "value" => value}} <- @form[:metadata].value do %>
          <.input
            name={"#{@form[:metadata].name}[#{field}][value]"}
            label={field}
            value={value}
            type={input_type_for("#{type}")}
          />
          <.input name={"#{@form[:metadata].name}[#{field}][type]"} value={type} type="hidden" />
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving...">Save Event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  defp input_type_for("integer"), do: :number
  defp input_type_for("string"), do: :text
  defp input_type_for(_), do: :unknown

  @impl true
  def update(%{event: event} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Tracker.change_event(event))
     end)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset = Tracker.change_event(socket.assigns.event, event_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    save_event(socket, socket.assigns.action, event_params)
  end

  defp save_event(socket, :edit_event, event_params) do
    case Tracker.update_event(socket.assigns.event, event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_event(%{assigns: %{metric: metric}} = socket, :new_event, event_params) do
    case Tracker.create_event(Map.put(event_params, "metric_id", metric.id)) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
