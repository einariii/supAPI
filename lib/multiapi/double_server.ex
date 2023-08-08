defmodule Supapi.DoubleServer do
  @moduledoc """
  Genserver for scheduling API calls and managing state.
  """
  use GenServer
  require Logger
  alias Supapi.DoubleAPI

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(match_list \\ {}) do
    Logger.info("Starting server")
    schedule_query(0)
    {:ok, match_list}
  end

  # To scale up, add new API calls from DoubleAPI to the pipeline below
  def handle_info(:start_calls, state) do
    new_state =
      state
      |> DoubleAPI.matchstream_call()
      |> DoubleAPI.feetball_call()

    # Adjust the query interval value here, in seconds
    schedule_query(30)
    {:noreply, new_state}
  end

  defp schedule_query(interval) do
    Process.send_after(self(), :start_calls, interval)
  end
end
