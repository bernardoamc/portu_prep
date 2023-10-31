defmodule PortuPrep.Material.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  import Slugy

  schema "topics" do
    field :name, :string
    field :description, :string
    field :slug, :string

    belongs_to :category, PortuPrep.Material.Category
    has_many :questions, PortuPrep.Material.Question

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:category_id, :name, :description, :slug])
    |> validate_required([:category_id, :name, :description])
    |> slugify(:name)
    |> unique_constraint([:category_id, :slug])
  end
end
