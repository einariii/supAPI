defmodule Supapi.DoubleAPI do
  @moduledoc """
  Functions for calling the APIs and normalizing the JSON responses where necessary.
  The final function determines whether to persist a specific entry in the database, based on Genserver state.
  Add functions to add APIs to the supervision tree!

  NB: This implementation lacks protocol for protecting against snowballing API calls that take more than 30 seconds to complete!!!
  """
  require Logger
  alias Supapi.Matches

  @doc """
  This function calls the matchstream API and normalizes the data for unified format by splitting the single "teams" key
  into two separate keys, "home_team" and "away_team." It then sends the list of matches to `update_match`, below.
  """
  def matchstream_call(match_list) do
    case HTTPoison.get("http://mocktest.footballapis.com:8080/feed/matchstream/") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        matches =
          Jason.decode!(body)
          |> Kernel.get_in(["matches"])

        Enum.map(matches, fn match ->
          [home_team, away_team] =
            Map.get(match, "teams")
            |> String.split(" - ")

          match
          |> Map.put("home_team", home_team)
          |> Map.put("away_team", away_team)
          |> Map.delete("teams")
        end)

        update_matches(matches, match_list)

      {:ok, %HTTPoison.Response{status_code: 503}} ->
        Logger.error("503 status code returned.")
        {:error, "Sorry! Service temporarily unavailable."}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Error due to #{reason}.")
        {:error, reason}

      _ ->
        Logger.error(
          "Unknown problems. Please review your code and/or check with the API provider."
        )
    end
  end

  @doc """
  This function calls the feetball API and then sends the list of matches to `update_match`, below.
  """
  def feetball_call(match_list, only_after \\ nil) do
    # The `only_after` parameter should be a timestamp. If passed to the function, the response will only contain the matches created after `only_after`.
    url =
      if only_after do
        "http://mocktest.footballapis.com:8080/feed/feetball?only_after=#{only_after}"
      else
        "http://mocktest.footballapis.com:8080/feed/feetball/"
      end

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        matches =
          Jason.decode!(body)
          |> Kernel.get_in(["matches"])

        update_matches(matches, match_list)

      {:ok, %HTTPoison.Response{status_code: 503}} ->
        Logger.error("503 status code returned.")
        {:error, "Sorry! Service temporarily unavailable."}

      {:ok, %HTTPoison.Response{status_code: 400}} ->
        Logger.error("400 status code returned.")
        {:error, "Hmmm. It seems the query was invalid."}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Error due to #{reason}.")
        {:error, reason}

      _ ->
        Logger.error(
          "Unknown problems. Please review your code and/or check with the API provider."
        )
    end
  end

  @doc """
  This function determines whether to persist a specific entry in the database, based on Genserver state.
  If the created_at timestamp is in state, the entire match map is sent to the Match context to persist.
  """
  def update_matches(matches, match_list) do
    dedup =
      Enum.map(matches, fn each ->
        if Map.get(each, :created_at) not in match_list do
          Matches.create_match(each)
        end

        Map.get(each, "created_at")
      end)

    check = Enum.reject(dedup, fn elem -> elem == nil end)

    (check ++ match_list)
    |> Enum.uniq()
  end
end
