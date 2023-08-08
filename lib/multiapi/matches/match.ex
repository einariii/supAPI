defmodule Supapi.Matches.Match do
  @moduledoc """
  Schema and changeset for matches entering the database.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    field :away_team, :string
    field :created_at, :integer
    field :home_team, :string
    field :kickoff_at, :string

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:home_team, :away_team, :kickoff_at, :created_at])
    |> validate_required([:home_team, :away_team, :kickoff_at, :created_at])
  end
end
