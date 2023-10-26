defmodule PortuPrep.Topics.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :name, :string
    field :description, :string

    has_many :questions, PortuPrep.Questions.Question

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
