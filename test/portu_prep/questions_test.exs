defmodule PortuPrep.MaterialTest do
  use PortuPrep.DataCase

  alias PortuPrep.Material

  describe "questions" do
    alias PortuPrep.Material.Question

    import PortuPrep.MaterialFixtures

    @invalid_attrs %{topic_id: nil, problem: nil, answer: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Questions.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Questions.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{topic_id: 42, problem: "some problem", answer: "some answer"}

      assert {:ok, %Question{} = question} = Questions.create_question(valid_attrs)
      assert question.topic_id == 42
      assert question.problem == "some problem"
      assert question.answer == "some answer"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{topic_id: 43, problem: "some updated problem", answer: "some updated answer"}

      assert {:ok, %Question{} = question} = Questions.update_question(question, update_attrs)
      assert question.topic_id == 43
      assert question.problem == "some updated problem"
      assert question.answer == "some updated answer"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
      assert question == Questions.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Questions.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Questions.change_question(question)
    end
  end
end
