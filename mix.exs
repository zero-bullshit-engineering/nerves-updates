defmodule Fwuppoc.MixProject do
  use Mix.Project

  @all_targets [:rpi0]

  def project do
    [
      app: :fwuppoc,
      version: "0.1.0",
      elixir: "~> 1.8",
      archives: [nerves_bootstrap: "~> 1.4"],
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.target() != :host,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Fwuppoc.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.4", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:nerves_init_gadget, "~> 0.6"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},
      {:httpoison, "~> 1.4"},
      {:jason, "~> 1.1.2"},
      {:nerves_firmware, "~> 0.4.0"},
      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets, override: true},

      # Dependencies for specific targets
      {:nerves_system_rpi0, "~> 1.6", runtime: false, targets: :rpi0}
    ]
  end
end
