defmodule PortuPrepWeb.QuestionComponent do
  use PortuPrepWeb, :live_component

  alias PortuPrep.Study
  alias PortuPrep.Study.Submission

  def render(assigns) do
    ~H"""
    <div id={@id} class={[
      "mt-2 rounded",
       @submission.action && @submission.errors == [] && "border border-teal-300 focus:border-teal-400 bg-teal-200",
       @submission.action && @submission.errors != [] && "border border-rose-400 focus:border-rose-400 bg-rose-200",
    ]}>
      <.simple_form
        :let={f}
        for={@submission}
        phx-submit="verify"
        phx-target={@myself}
        class="flex-1"
        phx-value-id={@id}
      >
        <div class="flex items-center">
          <.input field={f[:problem]} value={f[:problem].value} type="hidden" />
          <.input field={f[:answer]} value={f[:answer].value} type="hidden" />
          <.problem attempt_field={f[:attempt]} problem={@submission.params["problem"]} />

          <.button class="ml-4">Validate</.button>
        </div>
      </.simple_form>
    </div>
    """
  end

  def problem(assigns) do
    assigns = assign(assigns, :result, String.split(assigns.problem, ~r/_/))

    ~H"""
    <div class="flex items-center">
      <span class="mr-3 inline-block align-middle"><%= hd(@result) %></span>
      <.input field={@attempt_field} value={@attempt_field.value} type="text" nofeedback={true} />
      <span class="ml-3 inline-block align-middle"><%= tl(@result) %></span>
    </div>
    """
  end

  def handle_event("verify", %{"id" => id, "submission" => submission}, socket) do
    submission = Study.change_submission(%Submission{}, submission)
      |> Map.put(:action, :validate)
      |> Map.put(:question_id, id)

    send self(), {:verify_submission, submission}
    {:noreply, socket}
  end
end
