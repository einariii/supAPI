defmodule Supapi.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :home_team, :string
      add :away_team, :string
      add :kickoff_at, :naive_datetime
      add :created_at, :string

      timestamps()
    end
  end
end
