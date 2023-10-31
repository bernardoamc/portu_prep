defmodule PortuPrep.Repo.Migrations.AddCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :description, :string, null: false
      add :slug, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:categories, [:slug])
  end
end
