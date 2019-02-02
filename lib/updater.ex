defmodule Updater do
  @ip "172.21.254.22"
  def pull_update do
    res = HTTPoison.get!("http://" <> @ip <> "/fwuppoc.fw")
    File.write!("/tmp/firmware", res.body, [:binary, :write])
    Nerves.Firmware.apply("/tmp/firmware", :upgrade)
  end
end
