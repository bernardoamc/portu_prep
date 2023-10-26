defmodule PortuPrep.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :topic_id, references(:topics, on_delete: :delete_all), null: false
      add :problem, :string, null: false
      add :answer, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:questions, [:topic_id])
  end
end
