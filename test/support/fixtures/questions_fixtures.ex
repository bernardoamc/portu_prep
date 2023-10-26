defmodule PortuPrep.QuestionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PortuPrep.Questions` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        problem: "some problem",
        topic_id: 42
      })
      |> PortuPrep.Questions.create_question()

    question
  end
end
