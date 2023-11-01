defmodule PortuPrepWeb.StudyLive do
  use PortuPrepWeb, :live_view

  alias PortuPrep.Material
  alias PortuPrep.Study

  alias PortuPrepWeb.QuestionComponent

  def render(assigns) do
    ~H"""
    <div id="questions">
      <.header>
        <.back navigate={~p"/categories/#{@topic.category_id}"}>Back to category</.back>

        <.list>
          <:item title="Name"><%= @topic.name %></:item>
          <:item title="Description"><%= @topic.description %></:item>
        </.list>
      </.header>

      <div class="mt-5 mb-0 text-3xl">
        Exercises
      </div>

      <%= for {question_id, submission} <- @submissions do %>
        <.live_component module={QuestionComponent} submission={submission} id={question_id} />
      <% end %>
    </div>
    """
  end

  def mount(%{"id" => topic_id}, _session, socket) do
    topic = Material.get_topic!(topic_id)
    submissions =
      Material.list_questions_by_topic(topic)
      |> Study.prepare_questions()

    {:ok, assign(socket, topic: topic, submissions: submissions)}
  end

  def handle_info({:verify_submission, submission}, socket) do
    updated_socket =
      socket
      |> assign(:submissions, Map.put(socket.assigns.submissions, submission.question_id, submission))

    {:noreply, updated_socket}
  end
end
