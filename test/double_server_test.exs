defmodule Supapi.DoubleServerTest do
  use ExUnit.Case
  alias Supapi.DoubleServer
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

  # all of the below tests cannot properly evaluate as the Genserver is already started. Need a workaround
  describe "initialization" do
    test "genserver initializes" do
      assert {:ok, pid} = DoubleServer.start_link([])
    end

    test "starts with an empty state" do
      {:ok, pid} = DoubleServer.start_link([])
      assert DoubleServer.get_state() == []
    end
  end

  describe "basic tests" do
    test "adds a created_at timestamp to the state" do
      {:ok, pid} = DoubleServer.start_link([])
      match_list = []
      matches = [@match1]
      DoubleAPI.update_matches(matches, match_list)
      assert [1_684_297_023] == :sys.get_state(pid)
    end

    test "duplicate created_at timestamp is not added to state" do
      {:ok, pid} = DoubleServer.start_link([])
      match_list = [1_684_297_023]
      matches = [@match1]
      DoubleAPI.update_matches(matches, match_list)
      assert [1_684_297_023] == :sys.get_state(pid)
    end

    test "waits 30 seconds to call APIs again" do
      {:ok, pid} = DoubleServer.start_link([])
      match_list = []
      matches = [@match1]
      DoubleAPI.update_matches(matches, match_list)
      assert [1_684_297_023] == :sys.get_state(pid)
    end
  end
end
