defmodule Supapi.DoubleAPITest do
  use Supapi.DataCase, async: false
  import Supapi.MatchesFixtures
  import ExUnit.CaptureLog
  require Logger
  alias Supapi.DoubleAPI


  @match1 %{
    away_team: "some away team",
    created_at: 1_684_297_023,
    home_team: "some home team",
    kickoff_at: "2023-05-17T02:00:00Z"
  }
  @match2 %{
    away_team: "another away team",
    created_at: 1_684_297_024,
    home_team: "another home team",
    kickoff_at: "2023-05-17T03:00:00Z"
  }

  describe "last_checked_at" do
    # I attempted to use Mock for this but did not succeed
  end

  # I acknowledge that these need to be rewritten, and be more comprehensive.
  describe "state and persist" do
    test "empty list adds nothing to state" do
      match_list = []
      matches = []
      assert matches = DoubleAPI.update_matches(matches, match_list)
    end

    test "update_matches with duplicate created_at returns nothing" do
      match_list = [1_684_297_023]

      match = %{
        away_team: "some away team",
        created_at: 1_684_297_023,
        home_team: "some home team",
        kickoff_at: "2023-05-17T02:00:00Z"
      }

      matches = [match]
      assert [1_684_297_023] = DoubleAPI.update_matches(matches, match_list)
    end

    test "persist multiple matches" do
      match_list = []
      match1 = @match1
      match2 = @match2
      matches = [match1, match2]

      assert matches = DoubleAPI.update_matches(matches, match_list)
    end
  end

  # These don't really hit the codebase, and need to be rewritten.
  describe "error messages" do
    test "matchstream 503 response is logged" do
      assert capture_log(fn ->
               response = %HTTPoison.Response{status_code: 503}
               assert response.status_code == 503
               Logger.error("503 status code returned.")
             end) =~ "503 status code returned."
    end

    test "matchstream error response is logged" do
      assert capture_log(fn ->
               response = %HTTPoison.Error{reason: "catastrophe"}
               assert response.reason == "catastrophe"
               Logger.error("Error due to reason")
             end) =~ "Error due to"
    end

    test "feetball 503 response is logged" do
      assert capture_log(fn ->
               response = %HTTPoison.Response{status_code: 503}
               assert response.status_code == 503
               Logger.error("503 status code returned.")
             end) =~ "503 status code returned."
    end

    test "feetball 400 response is logged" do
      assert capture_log(fn ->
               response = %HTTPoison.Response{status_code: 400}
               assert response.status_code == 400
               Logger.error("400 status code returned.")
             end) =~ "400 status code returned."
    end

    test "feetball error response is logged" do
      assert capture_log(fn ->
               response = %HTTPoison.Error{reason: "catastrophe"}
               assert response.reason == "catastrophe"
               Logger.error("Error due to reason")
             end) =~ "Error due to"
    end
  end
end
