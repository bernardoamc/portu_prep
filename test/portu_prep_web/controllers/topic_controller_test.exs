defmodule PortuPrepWeb.TopicControllerTest do
  use PortuPrepWeb.ConnCase

  import PortuPrep.TopicsFixtures

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}

  describe "index" do
    test "lists all topics", %{conn: conn} do
      conn = get(conn, ~p"/topics")
      assert html_response(conn, 200) =~ "Listing Topics"
    end
  end

  describe "new topic" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/topics/new")
      assert html_response(conn, 200) =~ "New Topic"
    end
  end

  describe "create topic" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/topics", topic: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/topics/#{id}"

      conn = get(conn, ~p"/topics/#{id}")
      assert html_response(conn, 200) =~ "Topic #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/topics", topic: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Topic"
    end
  end

  describe "edit topic" do
    setup [:create_topic]

    test "renders form for editing chosen topic", %{conn: conn, topic: topic} do
      conn = get(conn, ~p"/topics/#{topic}/edit")
      assert html_response(conn, 200) =~ "Edit Topic"
    end
  end

  describe "update topic" do
    setup [:create_topic]

    test "redirects when data is valid", %{conn: conn, topic: topic} do
      conn = put(conn, ~p"/topics/#{topic}", topic: @update_attrs)
      assert redirected_to(conn) == ~p"/topics/#{topic}"

      conn = get(conn, ~p"/topics/#{topic}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, topic: topic} do
      conn = put(conn, ~p"/topics/#{topic}", topic: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Topic"
    end
  end

  describe "delete topic" do
    setup [:create_topic]

    test "deletes chosen topic", %{conn: conn, topic: topic} do
      conn = delete(conn, ~p"/topics/#{topic}")
      assert redirected_to(conn) == ~p"/topics"

      assert_error_sent 404, fn ->
        get(conn, ~p"/topics/#{topic}")
      end
    end
  end

  defp create_topic(_) do
    topic = topic_fixture()
    %{topic: topic}
  end
end
