defmodule Supapi.MatchesTest do
  use Supapi.DataCase, async: true
  # use ExUnit.Case, async: true
  import Supapi.MatchesFixtures
  alias Supapi.Matches
  alias Supapi.Matches.Match
  # matches.match and fixtures used to be in describe block
  describe "matches" do
    @invalid_attrs %{away_team: nil, created_at: nil, home_team: nil, kickoff_at: nil}

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Matches.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Matches.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      valid_attrs = %{
        away_team: "some away_team",
        created_at: 1_684_297_023,
        home_team: "some home_team",
        kickoff_at: "2023-05-17T02:00:00Z"
      }

      assert {:ok, %Match{} = match} = Matches.create_match(valid_attrs)
      assert match.away_team == "some away_team"
      assert match.created_at == 1_684_297_023
      assert match.home_team == "some home_team"
      assert match.kickoff_at == "2023-05-17T02:00:00Z"
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()

      update_attrs = %{
        away_team: "some updated away_team",
        created_at: 1_684_297_024,
        home_team: "some updated home_team",
        kickoff_at: "2023-05-17T03:00:00Z"
      }

      assert {:ok, %Match{} = match} = Matches.update_match(match, update_attrs)
      assert match.away_team == "some updated away_team"
      assert match.created_at == 1_684_297_024
      assert match.home_team == "some updated home_team"
      assert match.kickoff_at == "2023-05-17T03:00:00Z"
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Matches.update_match(match, @invalid_attrs)
      assert match == Matches.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Matches.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Matches.change_match(match)
    end
  end
end
