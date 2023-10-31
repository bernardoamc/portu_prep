defmodule PortuPrep.MaterialFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PortuPrep.Material` context.
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
      |> PortuPrep.Material.create_question()

    question
  end
end
