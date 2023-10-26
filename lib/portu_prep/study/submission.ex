defmodule PortuPrep.Study.Submission do
  use Ecto.Schema

  alias PortuPrep.Study.Submission
  import Ecto.Changeset

  embedded_schema do
    field :question_id, :string
    field :problem, :string
    field :attempt, :string
    field :answer, :string
  end

  @doc false
  def changeset(%Submission{} = submission, attrs) do
    submission
    |> cast(attrs, [:question_id, :problem, :answer, :attempt])
    |> validate_required([:answer, :attempt])
    |> validate_submission(:attempt)
  end

  def validate_submission(changeset, field) when is_atom(field) do
    validate_change(changeset, field, fn field, value ->
      case value == changeset.changes.answer do
        true ->
          []

        false ->
          [{field, "incorrect answer"}]
      end
    end)
  end
end
