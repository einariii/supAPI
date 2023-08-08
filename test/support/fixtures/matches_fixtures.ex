defmodule Supapi.MatchesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Supapi.Matches` context.
  """

  @spec match_fixture(any) :: any
  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        away_team: "some away_team",
        created_at: 1_684_297_023,
        home_team: "some home_team",
        kickoff_at: "2023-05-17T02:00:00Z"
      })
      |> Supapi.Matches.create_match()

    match
  end
end
