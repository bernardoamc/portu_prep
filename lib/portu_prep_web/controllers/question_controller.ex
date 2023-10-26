defmodule PortuPrepWeb.QuestionController do
  use PortuPrepWeb, :controller

  alias PortuPrep.Questions
  alias PortuPrep.Questions.Question
  alias PortuPrep.Topics

  def index(conn, _params) do
    questions = Questions.list_questions()
    render(conn, :index, questions: questions)
  end

  def new(conn, _params) do
    changeset = Questions.change_question(%Question{})

    render(conn, :new, changeset: changeset, topic_options: Topics.list_topics_by_name())
  end

  def create(conn, %{"question" => question_params}) do
    case Questions.create_question(question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question created successfully.")
        |> redirect(to: ~p"/questions/#{question}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, topic_options: Topics.list_topics_by_name())
    end
  end

  def show(conn, %{"id" => id}) do
    question = Questions.get_question!(id)
    render(conn, :show, question: question)
  end

  def edit(conn, %{"id" => id}) do
    question = Questions.get_question!(id)
    changeset = Questions.change_question(question)
    render(conn, :edit, question: question, changeset: changeset, topic_options: Topics.list_topics_by_name())
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Questions.get_question!(id)

    case Questions.update_question(question, question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question updated successfully.")
        |> redirect(to: ~p"/questions/#{question}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, question: question, changeset: changeset, topic_options: Topics.list_topics_by_name())
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Questions.get_question!(id)
    {:ok, _question} = Questions.delete_question(question)

    conn
    |> put_flash(:info, "Question deleted successfully.")
    |> redirect(to: ~p"/questions")
  end
end
