defmodule PortuPrep.Material.Category do
  use Ecto.Schema
  import Ecto.Changeset
  import Slugy

  schema "categories" do
    field :name, :string
    field :description, :string
    field :slug, :string

    has_many :topics, PortuPrep.Material.Topic

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :slug])
    |> validate_required([:name, :description])
    |> slugify(:name)
    |> unique_constraint(:slug)
  end
end
