defmodule PlanningPoker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :description, :string
      add :state, :string

      timestamps(type: :utc_datetime)
    end
  end
end
