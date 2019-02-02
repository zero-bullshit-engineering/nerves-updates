defmodule Fwuppoc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fwuppoc.Supervisor]
    Supervisor.start_link(children(@target), opts)
    :timer.apply_interval(30_000, Updater, :pull_update, [])
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Starts a worker by calling: Fwuppoc.Worker.start_link(arg)
      # {Fwuppoc.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: Fwuppoc.Worker.start_link(arg)
      # {Fwuppoc.Worker, arg},
    ]
  end
end
