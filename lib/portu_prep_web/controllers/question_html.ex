defmodule PortuPrepWeb.QuestionHTML do
  use PortuPrepWeb, :html

  embed_templates "question_html/*"

  @doc """
  Renders a question form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :topic_options, :list, required: true

  def question_form(assigns)
end
