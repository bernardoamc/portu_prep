defmodule PortuPrepWeb.QuestionControllerTest do
  use PortuPrepWeb.ConnCase

  import PortuPrep.QuestionsFixtures

  @create_attrs %{topic_id: 42, problem: "some problem", answer: "some answer"}
  @update_attrs %{topic_id: 43, problem: "some updated problem", answer: "some updated answer"}
  @invalid_attrs %{topic_id: nil, problem: nil, answer: nil}

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, ~p"/questions")
      assert html_response(conn, 200) =~ "Listing Questions"
    end
  end

  describe "new question" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/questions/new")
      assert html_response(conn, 200) =~ "New Question"
    end
  end

  describe "create question" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/questions", question: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/questions/#{id}"

      conn = get(conn, ~p"/questions/#{id}")
      assert html_response(conn, 200) =~ "Question #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/questions", question: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Question"
    end
  end

  describe "edit question" do
    setup [:create_question]

    test "renders form for editing chosen question", %{conn: conn, question: question} do
      conn = get(conn, ~p"/questions/#{question}/edit")
      assert html_response(conn, 200) =~ "Edit Question"
    end
  end

  describe "update question" do
    setup [:create_question]

    test "redirects when data is valid", %{conn: conn, question: question} do
      conn = put(conn, ~p"/questions/#{question}", question: @update_attrs)
      assert redirected_to(conn) == ~p"/questions/#{question}"

      conn = get(conn, ~p"/questions/#{question}")
      assert html_response(conn, 200) =~ "some updated problem"
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = put(conn, ~p"/questions/#{question}", question: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Question"
    end
  end

  describe "delete question" do
    setup [:create_question]

    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, ~p"/questions/#{question}")
      assert redirected_to(conn) == ~p"/questions"

      assert_error_sent 404, fn ->
        get(conn, ~p"/questions/#{question}")
      end
    end
  end

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end
end
