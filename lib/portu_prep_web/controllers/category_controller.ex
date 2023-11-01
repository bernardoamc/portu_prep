defmodule PortuPrepWeb.CategoryController do
  use PortuPrepWeb, :controller

  alias PortuPrep.Material

  def index(conn, _params) do
    categories = Material.list_categories()
    render(conn, :index, categories: categories)
  end

  def show(conn, %{"id" => id}) do
    category = Material.get_category!(id)
    topics = Material.list_topics_by_category(category)
    render(conn, :show, category: category, topics: topics)
  end
end
