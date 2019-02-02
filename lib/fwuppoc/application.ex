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
    ensure_serial()
    HTTPoison.start()
    :timer.apply_interval(30_000, Updater, :pull_update, [])
    :timer.apply_interval(30_000, Updater, :report_status, [])
    Supervisor.start_link(children(@target), opts)
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

  def ensure_serial do
    serial = Nerves.Runtime.KV.get("nerves_serial_number")

    if serial == "" do
      new_serial = UUID.uuid4()
      System.cmd("fw_setenv", ["nerves_serial_number", new_serial])
      reboot()
    end
  end
end
