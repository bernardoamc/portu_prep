defmodule PortuPrep.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :problem, :string
    field :answer, :string

    belongs_to :topic, PortuPrep.Topics.Topic

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:topic_id, :problem, :answer])
    |> validate_required([:topic_id, :problem, :answer])
    |> validate_format(:problem, ~r/(?= _ )/i, message: "does not contain a placeholder")
  end
end
