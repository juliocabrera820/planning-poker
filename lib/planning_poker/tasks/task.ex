defmodule PlanningPoker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlanningPoker.Repo

  schema "tasks" do
    field :description, :string
    field :name, :string
    field :state, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :state])
    |> validate_required([:name, :description, :state])
  end

  def list_tasks do
    Repo.all(__MODULE__)
  end

  def get_task(id) do
    Repo.get(__MODULE__, id)
  end
end
