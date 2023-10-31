defmodule PortuPrepWeb.TopicController do
  use PortuPrepWeb, :controller

  alias PortuPrep.Material
  alias PortuPrep.Material.Topic

  def index(conn, _params) do
    topics = Material.list_topics()
    render(conn, :index, topics: topics)
  end

  def new(conn, _params) do
    changeset = Material.change_topic(%Topic{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Material.create_topic(topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: ~p"/topics/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Material.get_topic!(id)
    render(conn, :show, topic: topic)
  end

  def edit(conn, %{"id" => id}) do
    topic = Material.get_topic!(id)
    changeset = Material.change_topic(topic)
    render(conn, :edit, topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Material.get_topic!(id)

    case Material.update_topic(topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: ~p"/topics/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, topic: topic, changeset: changeset)
    end
  end
end
