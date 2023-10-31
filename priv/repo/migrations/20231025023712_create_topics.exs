defmodule PortuPrep.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :category_id, references(:categories, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :description, :string, null: false
      add :slug, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:topics, [:category_id, :slug])
  end
end
