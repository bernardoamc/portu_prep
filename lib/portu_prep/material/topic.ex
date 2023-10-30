defmodule PortuPrep.Material.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  import Slugy

  schema "topics" do
    field :name, :string
    field :description, :string
    field :slug, :string

    has_many :questions, PortuPrep.Material.Question

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:name, :description, :slug])
    |> validate_required([:name, :description])
    |> slugify(:name)
    |> unique_constraint(:slug)
  end
end
