defmodule Supapi.Application do
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      Supapi.Repo,
      {Supapi.DoubleServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Supapi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
