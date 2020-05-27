defmodule ProcessManager.Repo.Migrations.CreateProcesses do
  use Ecto.Migration

  def change do
    create table(:processes) do
      add :name, :string
      add :pid, :integer

      timestamps()
    end

  end
end
