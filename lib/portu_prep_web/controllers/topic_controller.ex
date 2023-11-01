defmodule PortuPrepWeb.TopicController do
  use PortuPrepWeb, :controller

  alias PortuPrep.Material

  def show(conn, %{"id" => id}) do
    topic = Material.get_topic!(id)
    render(conn, :show, topic: topic)
  end
end
