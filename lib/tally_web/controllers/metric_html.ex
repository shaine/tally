defmodule TallyWeb.MetricHTML do
  use TallyWeb, :html

  embed_templates "metric_html/*"

  @doc """
  Renders a metric form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def metric_form(assigns)
end
