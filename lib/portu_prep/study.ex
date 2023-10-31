defmodule PortuPrep.Study do
  alias PortuPrep.Study.Submission

  def change_submission(%Submission{} = submission, attrs \\ %{}) do
    Submission.changeset(submission, attrs)
  end

  def prepare_questions(questions) do
    questions
    |> Enum.reduce(%{}, fn question, acc ->
      question_id = "question-#{question.id}"

      Map.put(acc, question_id, change_submission(%Submission{}, %{
        question_id: question_id,
        problem: question.problem,
        answer: question.answer
      }))
    end)
  end
end
